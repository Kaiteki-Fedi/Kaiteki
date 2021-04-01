using System.Collections.Generic;
using System.Text.Json.Serialization;

namespace OpenApiBrowser.Model
{
    public class DataSchema
    {
        public string Description { get; set; }
        public dynamic Example { get; set; }

        public string Id { get; set; }

        [JsonPropertyName("properties")]
        public Dictionary<string, Property> Properties { get; set; }

        public string[] Required { get; set; }
        public string Title { get; set; }
        public string Type { get; set; }
    }
}