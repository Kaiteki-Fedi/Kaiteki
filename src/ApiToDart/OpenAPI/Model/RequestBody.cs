using System.Collections.Generic;
using System.Text.Json.Serialization;

namespace OpenApiBrowser.Model
{
	public class RequestBody
	{
		// [JsonPropertyName("content")]
		// public Dictionary<string, Content> Content { get; set; }
		public string Description { get; set; }
		public bool Required { get; set; }
	}
}