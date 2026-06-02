extends Node

var money := 850
var reputation := 0
var stamina := 100
var audit_risk := 50
var day := 1
var active_case_id := ""
var unlocked_precedents: Array[String] = []
var case_states: Dictionary = {}

func reset_campaign() -> void:
	money = 850
	reputation = 0
	stamina = 100
	audit_risk = 50
	day = 1
	active_case_id = ""
	unlocked_precedents.clear()
	case_states.clear()

func ensure_case_state(case_id: String) -> Dictionary:
	if not case_states.has(case_id):
		case_states[case_id] = {
			"status": "available",
			"visited_locations": [],
			"discovered_evidence": [],
			"completed_interactions": [],
			"selected_theory": "",
			"resolution": "",
			"result_text": "",
			"reward_applied": false,
		}

	return case_states[case_id]

func start_case(case_id: String) -> void:
	var state := ensure_case_state(case_id)
	active_case_id = case_id
	if state.get("status", "available") != "resolved":
		state["status"] = "active"

func visit_location(case_id: String, location_id: String) -> void:
	var state := ensure_case_state(case_id)
	var visited: Array = state["visited_locations"]
	if not visited.has(location_id):
		visited.append(location_id)

func discover_evidence(case_id: String, evidence_id: String) -> void:
	var state := ensure_case_state(case_id)
	var discovered: Array = state["discovered_evidence"]
	if not discovered.has(evidence_id):
		discovered.append(evidence_id)

func complete_interaction(case_id: String, interaction_id: String) -> void:
	var state := ensure_case_state(case_id)
	var completed: Array = state["completed_interactions"]
	if not completed.has(interaction_id):
		completed.append(interaction_id)

func select_theory(case_id: String, theory_id: String) -> void:
	var state := ensure_case_state(case_id)
	state["selected_theory"] = theory_id

func resolve_case(case_id: String, resolution_key: String, rewards: Dictionary, result_text: String) -> void:
	var state := ensure_case_state(case_id)
	state["status"] = "resolved"
	state["resolution"] = resolution_key
	state["result_text"] = result_text

	if bool(state.get("reward_applied", false)):
		return

	money += int(rewards.get("money", 0))
	reputation += int(rewards.get("reputation", 0))
	audit_risk = clampi(audit_risk + int(rewards.get("audit_risk", 0)), 0, 100)
	stamina = clampi(stamina + int(rewards.get("stamina", 0)), 0, 100)

	var precedent_note := str(rewards.get("precedent_note", ""))
	if precedent_note != "" and not unlocked_precedents.has(precedent_note):
		unlocked_precedents.append(precedent_note)

	state["reward_applied"] = true

func get_resolved_case_count() -> int:
	var resolved_count := 0
	for state in case_states.values():
		if typeof(state) == TYPE_DICTIONARY and state.get("status", "") == "resolved":
			resolved_count += 1

	return resolved_count

func get_audit_label() -> String:
	if audit_risk < 35:
		return "Low"
	if audit_risk < 70:
		return "Medium"
	return "High"
