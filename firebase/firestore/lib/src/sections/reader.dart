import "package:firestore/helpers.dart";

/// A collection of functions to read course data.
/// 
/// No function in this class actually performs logic on said data, just returns
/// it. This helps keep the program modular, by separating the data sources from
/// the data indexing.
class SectionReader {
	/// Maps course IDs to their respective names.
	static Future<Map<String, String>> get courseNames async => {
		await for (final Map<String, String> row in csvReader(DataFiles.courses))
			if (row ["SCHOOL_ID"] == "Upper")
				row ["ID"]: row ["FULL_NAME"]
	};

	static Future<Map<String, String>> getSectionFacultyIds() async => {
		await for (final Map<String, String> row in csvReader(DataFiles.section))
			if (row ["SCHOOL_ID"] == "Upper" && row ["FACULTY_ID"].isNotEmpty)
				row ["SECTION_ID"]: row ["FACULTY_ID"],
	};
}

class ZoomLinkReader {
	static Future<Map<String, String>> getZoomLinks() async => {
		await for (final Map<String, String> row in csvReader(DataFiles.zoomLinks))
			if (row ["LINK"].isNotEmpty)
				row ["ID"]: row ["LINK"],
	};
}
