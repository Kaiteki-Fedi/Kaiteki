using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using Humanizer;

using OpenApiBrowser.Model;

namespace ApiToDart
{
    public class DartConverter
    {
        public enum DartNamingConvention
        {
            FileName,
            Field
        }

        private static void AppendConstructor(StringBuilder sb, DataSchema schema, string className)
        {
            sb.AppendLine("  const " + className + "({");

            foreach (var (name, property) in schema.Properties)
            {
                sb.Append("    ");

                var isRequired = schema.Required?.Contains(name) == true;
                if (!property.Nullable || isRequired)
                {
                    sb.Append("required ");
                }

                sb.AppendLine("this." + ApplyNaming(name, DartNamingConvention.Field) + ",");
            }
            sb.AppendLine("  });");
            sb.AppendLine();
        }

        private static void AppendDartDocComment(StringBuilder sb, string comment)
        {
            if (string.IsNullOrWhiteSpace(comment))
                return;

            // TODO: Separate first sentence and trailing lines, etc.
            var lines = new[] { comment };

            foreach (var line in lines)
            {
                sb.AppendLine("/// " + line);
            }
        }

        private static void AppendImports(StringBuilder sb, Job job, Specification spec, IEnumerable<Property> properties, string currentSchema)
        {
            var dataTypes = properties.Select(Utils.GetPropertyReference)
                                      .Distinct()
                                      .Where(v => v != null)
                                      .Where(t => t != currentSchema);

            sb.AppendLine("import 'package:json_annotation/json_annotation.dart';");

            if (!dataTypes.Any())
                return;

            foreach (var type in dataTypes)
            {
                var currentSchemaName = spec.Components.Schemas.Keys.FirstOrDefault(k =>
                {
                    return k.Equals(type, StringComparison.OrdinalIgnoreCase);
                });

                if (currentSchemaName == null)
                {
                    Utils.WriteWarning("Couldn't find schema entry");
                    continue;
                }

                var schemaOverride = Utils.GetJobSettings(job, currentSchemaName);

                sb.AppendLine("import 'package:" + schemaOverride.ImportPrefix + "/" + ApplyNaming(currentSchemaName, DartNamingConvention.FileName) + ".dart';");
            }
        }

        private string ToDartType(Job job, Specification spec, Property property)
        {
            string type = property?.Type;

            var schemaReference = Utils.GetPropertyReference(property);
            if (schemaReference != null)
            {
                var referencedSchema = spec.Components.Schemas.FirstOrDefault(kv => kv.Key.Equals(schemaReference)).Value;

                if (referencedSchema == null)
                {
                    throw new Exception($"Couldn't find referenced schema/component: {schemaReference}");
                }

                if (referencedSchema.Type == "object")
                {
                    var settings = Utils.GetJobSettings(job, schemaReference);
                    return settings.ClassNamePrefix + schemaReference.Pascalize();
                }
                else
                {
                    type = referencedSchema.Type;
                }
            }

            switch (type)
            {
                case "string":
                    if (property.Format == "date-time")
                        return "DateTime";
                    else
                        return "String";

                case "object":
                    return "Map<String, dynamic>";

                case "array":
                    return "Iterable<" + ToDartType(job, spec, property.Items) + ">";

                case null:
                case "any":
                    return "dynamic";

                case "boolean":
                    return "bool";

                case "number":
                case "integer":
                    return "int";

                default:
                    throw new ArgumentOutOfRangeException(nameof(property), "Unknown type " + property.Type);
            }
        }

        private string ToField(string jsonKey, Job job, Specification spec, Property property, bool asFinal = false)
        {
            var sb = new StringBuilder();
            var fieldName = ApplyNaming(jsonKey, DartNamingConvention.Field);

            // add dartdoc comment
            AppendDartDocComment(sb, property.Description);

            // add json attribute
            sb.AppendLine("@JsonKey(name: \"" + jsonKey + "\")");

            // add final keyword
            if (asFinal)
            {
                sb.Append("final ");
            }

            // Add field declaration
            sb.Append(ToDartType(job, spec, property) + ' ' + fieldName);

            // Add nullable character
            if (property.Nullable)
            {
                sb.Append('?');
            }

            // finish with semicolon + newline
            sb.AppendLine(";");

            return sb.ToString();
        }

        public static string ApplyNaming(string input, DartNamingConvention convention)
        {
            var name = input;

            if (name[0] == '_')
                name = name[1..];

            name = convention switch
            {
                DartNamingConvention.FileName => name.Underscore(),
                DartNamingConvention.Field => name.Camelize(),
                _ => name,
            };

            return name;
        }

        public string ToDartFile(Job job, Specification spec, DataSchema schema, string schemaName)
        {
            var sb = new StringBuilder();
            var jobSettings = Utils.GetJobSettings(job, schemaName);
            var className = jobSettings.ClassNamePrefix + schemaName.Pascalize();

            // append imports
            AppendImports(sb, job, spec, schema.Properties.Values, schemaName);

            // append part reference
            sb.AppendLine("part '" + ApplyNaming(schemaName, DartNamingConvention.FileName) + ".g.dart';");
            sb.AppendLine();

            // append description
            AppendDartDocComment(sb, schema.Description);

            sb.AppendLine("@JsonSerializable()");
            sb.AppendLine("class " + className + " {");

            // write fields
            foreach (var (name, property) in schema.Properties)
            {
                var fieldCode = ToField(name, job, spec, property, true);
                fieldCode = Utils.ApplyIndent(fieldCode, 2);
                sb.AppendLine(fieldCode);
            }

            // append constructor
            AppendConstructor(sb, schema, className);

            // append json
            sb.AppendLine($"  factory {className}.fromJson(Map<String, dynamic> json) => _${className}FromJson(json);");
            sb.AppendLine($"  Map<String, dynamic> toJson() => _${className}ToJson(this);");

            sb.AppendLine("}");

            return sb.ToString();
        }
    }
}