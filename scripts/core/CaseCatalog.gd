extends RefCounted

const DEFAULT_CASE_FILE := "res://content/cases/first_arc_cases.json"

var arc_data: Dictionary = {}
var cases: Array = []
var case_by_id: Dictionary = {}

func load_from_file(path: String = DEFAULT_CASE_FILE) -> bool:
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_error("Could not open case catalog: %s" % path)
		return false

	var json := JSON.new()
	var error := json.parse(file.get_as_text())
	if error != OK:
		push_error("Could not parse case catalog %s: %s at line %d" % [
			path,
			json.get_error_message(),
			json.get_error_line(),
		])
		return false

	if typeof(json.data) != TYPE_DICTIONARY:
		push_error("Case catalog root must be a dictionary: %s" % path)
		return false

	arc_data = json.data
	cases = arc_data.get("cases", [])
	case_by_id.clear()

	for case_data in cases:
		if typeof(case_data) == TYPE_DICTIONARY and case_data.has("id"):
			case_by_id[str(case_data["id"])] = case_data

	return true

func get_first_case_id() -> String:
	if cases.is_empty():
		return ""

	var first_case = cases[0]
	if typeof(first_case) != TYPE_DICTIONARY:
		return ""

	return str(first_case.get("id", ""))

func get_case(case_id: String) -> Dictionary:
	return case_by_id.get(case_id, {})

func get_case_count() -> int:
	return cases.size()
