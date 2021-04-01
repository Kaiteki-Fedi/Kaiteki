using System.Collections.Generic;
using System.Text.Json.Serialization;

namespace OpenApiBrowser.Model
{
	public class Response
	{
		public string Description { get; set; }

		[JsonPropertyName("content")]
		public Dictionary<string, Content> Content { get; set; }
	}
}