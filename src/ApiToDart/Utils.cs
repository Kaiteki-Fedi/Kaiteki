using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net.Http;
using System.Threading.Tasks;

using OpenApiBrowser.Model;

namespace ApiToDart
{
    public static class Utils
    {
        public static string ApplyIndent(string input, int indentSize, char newLine = '\n')
        {
            IEnumerable<string> lines = input.Split(newLine);
            lines = lines.Select(line => line.PadLeft(line.Length + indentSize));
            return string.Join(newLine, lines);
        }

        public static async Task<string> DownloadString(string url)
        {
            using (var httpClient = new HttpClient())
            {
                var response = await httpClient.GetAsync(url);
                response.EnsureSuccessStatusCode();
                return await response.Content.ReadAsStringAsync();
            }
        }

        public static async Task<string> FetchJson(Job job)
        {
            if (!string.IsNullOrWhiteSpace(job.RemoteSpecification))
            {
                Console.WriteLine("Fetching " + job.RemoteSpecification + "...");
                return await DownloadString(job.RemoteSpecification);
            }

            if (!string.IsNullOrWhiteSpace(job.SpecificationPath))
            {
                return await File.ReadAllTextAsync(job.SpecificationPath);
            }

            throw new Exception("Job didn't specify the location of the API specification.");
        }

        public static JobSettings GetJobSettings(Job job, string schemaName = null)
        {
            if (!string.IsNullOrWhiteSpace(schemaName))
            {
                var @override = job.Overrides?.FirstOrDefault(js => js.EntityNames.Contains(schemaName));
                if (@override != null)
                    return @override.Settings;
            }

            return job.Default;
        }

        public static string GetPropertyReference(Property property)
        {
            if (property == null)
            {
                return null;
            }

            if (property.Items != null)
            {
                return GetPropertyReference(property.Items);
            }

            if (!string.IsNullOrWhiteSpace(property.Reference))
            {
                return property.Reference;
            }

            if (!string.IsNullOrWhiteSpace(property.JsonReference))
            {
                return property.JsonReference.Split('/').Skip(3).First();
            }

            return null;
        }

        public static void WriteWarning(string line)
        {
            Console.ForegroundColor = ConsoleColor.Yellow;
            Console.WriteLine(line);
            Console.ResetColor();
        }
    }
}