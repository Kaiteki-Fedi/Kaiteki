using System.Text.Json.Serialization;

namespace OpenApiBrowser.Model
{
	public class Content
	{
		[JsonPropertyName("schema")]
		public DataSchema Schema { get; set; }
	}
}