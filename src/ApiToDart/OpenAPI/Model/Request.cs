using System.Collections.Generic;
using System.Text.Json.Serialization;

namespace OpenApiBrowser.Model
{
	public class Request
	{
		public bool Deprecated { get; set; }
		
		[JsonPropertyName("summary")]
		public string Summary { get; set; }
		
		public string OperationId { get; set; }
		
		[JsonPropertyName("requestBody")]
		public RequestBody RequestBody { get; set; }
		
		[JsonPropertyName("responses")]
		public Dictionary<string, Response> Responses { get; set; }
	}
}