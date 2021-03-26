using System;
using System.IO;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Text.Json;
using System.Threading.Tasks;

using Humanizer;

using OpenApiBrowser.Model;

namespace ApiToDart
{
    internal class Program
    {
        private static readonly DartConverter _converter = new();

        private static readonly JsonSerializerOptions _jsonOptions = new()
        {
            PropertyNameCaseInsensitive = true,
        };

        private static async Task ConvertSchemaAsync(Job job, Specification spec, DataSchema schema, string schemaName)
        {
            var settings = Utils.GetJobSettings(job, schemaName);

            if (settings.Ignore)
            {
                Console.WriteLine("Skipped " + schemaName);
                return;
            }
            else
            {
                Console.WriteLine("Converting " + schemaName + "...");
            }

            var fileName = DartConverter.ApplyNaming(schemaName, DartConverter.DartNamingConvention.FileName) + ".dart";
            var filePath = Path.Combine(settings.OutputDirectory, fileName);

            var source = _converter.ToDartFile(job, spec, schema, schemaName);

            await File.WriteAllTextAsync(filePath, source);
        }

        private static void Main(string[] args)
        {
            Console.WriteLine("ApiToDart starting...");
            MainAsync(args).GetAwaiter().GetResult();
        }

        private static async Task MainAsync(string[] args)
        {
            var jobPaths = Directory.GetFiles("jobs", "*.json");
            var tasks = jobPaths.Select((path) => ParseAndRunJobAsync(path));

            await Task.WhenAll(tasks);
        }

        private static async Task ParseAndRunJobAsync(string path)
        {
            await using (var fileStream = new FileStream(path, FileMode.Open, FileAccess.Read))
            {
                var job = await JsonSerializer.DeserializeAsync<Job>(fileStream, _jsonOptions);
                await RunJobAsync(job);
            }
        }

        private static async Task RunJobAsync(Job job)
        {
            var json = await Utils.FetchJson(job);
            var spec = JsonSerializer.Deserialize<Specification>(json, _jsonOptions);

            var outputDirectoryPath = job.Default.OutputDirectory;
            if (!Directory.Exists(outputDirectoryPath))
            {
                Directory.CreateDirectory(outputDirectoryPath);
            }

            var schemas = spec.Components.Schemas.Where(kv => kv.Value.Type == "object");

            foreach (var (key, schema) in schemas)
            {
                await ConvertSchemaAsync(job, spec, schema, schema.Title ?? key);
            }
        }
    }
}