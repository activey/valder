using bob.builder.json;

namespace bob.builder.recipe.project {
	
	public class BobBuildProjectDetails {

		private const string SEPARATOR_AUTHORS = ",";

		private const string MEMBER_DESCRIPTION = "description";
		private const string MEMBER_AUTHORS = "authors";
		private const string MEMBER_SECTION = "section";
		private const string MEMBER_ARCHITECTURE = "architecture";

		private string[] _authors = new string[0];

		public string[] authors { 
			get {
				return _authors;
			}
		}

		public string section { get; set; }
		public string architecture { get; set; }
		public string description { get; set; }

		public BobBuildProjectDetails.fromJsonObject(JsonObject jsonObject) {
			readAuthors(jsonObject.getObjectArrayEntry(MEMBER_AUTHORS));

			description = jsonObject.getStringEntry(MEMBER_DESCRIPTION, description);
			section = jsonObject.getStringEntry(MEMBER_SECTION, section);
			architecture = jsonObject.getStringEntry(MEMBER_ARCHITECTURE, architecture);
		}

		private void readAuthors(JsonArray? authorsArray) {
			if (authorsArray == null) {
				return;
			}
			authorsArray.forStringEachValue(addAuthor);
		}

		private void addAuthor(string author) {
			_authors += author;
		}
	}
}