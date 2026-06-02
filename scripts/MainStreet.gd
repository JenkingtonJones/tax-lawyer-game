extends Node2D

const CASE_CATALOG_SCRIPT = preload("res://scripts/core/CaseCatalog.gd")

const PLAYER_SPEED := 235.0
const WALK_LEFT_LIMIT := 92.0
const WALK_RIGHT_LIMIT := 1188.0
const PLAYER_FLOOR_Y := 520.0
const JUMP_VELOCITY := -760.0
const JUMP_GRAVITY := 1800.0
const PLAYER_FRAME_SCALE := Vector2(0.42, 0.42)
const NPC_FRAME_SCALE := Vector2(0.42, 0.42)
const FALLBACK_DIALOGUE := "The case catalog did not load. Check content/cases/first_arc_cases.json."
const CLOSED_FILE_DIALOGUE := "Thank you. This file is closed."

var catalog: RefCounted
var active_case_id := ""
var active_case: Dictionary = {}
var active_theories: Array = []
var player_frozen := false
var near_client := false
var client_resolved := false
var waiting_for_continue := false
var vertical_velocity := 0.0
var is_jumping := false

@onready var player: CharacterBody2D = $World/Player
@onready var player_sprite: AnimatedSprite2D = $World/Player/Sprite
@onready var client_sprite: AnimatedSprite2D = $World/ElderlyClient/Sprite
@onready var interaction_area: Area2D = $World/ElderlyClient/InteractionArea
@onready var prompt: Label = $UI/Prompt
@onready var dialogue_panel: Control = $UI/DialoguePanel
@onready var dialogue_text: Label = $UI/DialoguePanel/DialogueText
@onready var choice_box: Sprite2D = $UI/DialoguePanel/ChoiceBox
@onready var choices: VBoxContainer = $UI/DialoguePanel/Choices
@onready var top_hud_text: Label = $UI/TopHudText
@onready var bottom_hud_text: Label = $UI/BottomHudText
@onready var choice_1: Button = $UI/DialoguePanel/Choices/Choice1
@onready var choice_2: Button = $UI/DialoguePanel/Choices/Choice2
@onready var choice_3: Button = $UI/DialoguePanel/Choices/Choice3

func _ready() -> void:
	_setup_case_content()
	_setup_text_layout()
	_setup_animations()
	_connect_signals()
	player_sprite.play("idle")
	client_sprite.play("idle")
	dialogue_panel.hide()
	prompt.hide()
	_update_hud()

func _setup_case_content() -> void:
	catalog = CASE_CATALOG_SCRIPT.new()
	if not catalog.load_from_file():
		return

	active_case_id = catalog.get_first_case_id()
	if active_case_id == "":
		return

	active_case = catalog.get_case(active_case_id)
	active_theories = active_case.get("theories", [])
	CampaignState.start_case(active_case_id)
	client_resolved = CampaignState.ensure_case_state(active_case_id).get("status", "") == "resolved"

func _setup_text_layout() -> void:
	dialogue_text.custom_minimum_size = Vector2(590, 132)
	dialogue_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	dialogue_text.text_overrun_behavior = TextServer.OVERRUN_TRIM_WORD_ELLIPSIS
	dialogue_text.clip_contents = true

	choices.clip_contents = true
	_refresh_choice_buttons()

	for button in [choice_1, choice_2, choice_3]:
		button.custom_minimum_size = Vector2(342, 32)
		button.add_theme_font_size_override("font_size", 17)
		button.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS

func _physics_process(_delta: float) -> void:
	if player_frozen:
		player.velocity = Vector2.ZERO
		return

	var direction := Input.get_axis("ui_left", "ui_right")
	if Input.is_action_just_pressed("jump") and not is_jumping:
		vertical_velocity = JUMP_VELOCITY
		is_jumping = true

	if is_jumping:
		vertical_velocity += JUMP_GRAVITY * _delta

	player.velocity = Vector2(direction * PLAYER_SPEED, vertical_velocity)
	player.move_and_slide()
	player.position.x = clampf(player.position.x, WALK_LEFT_LIMIT, WALK_RIGHT_LIMIT)
	if player.position.y >= PLAYER_FLOOR_Y:
		player.position.y = PLAYER_FLOOR_Y
		vertical_velocity = 0.0
		is_jumping = false

	if direction < 0.0:
		player_sprite.flip_h = true
		player_sprite.play("walk")
	elif direction > 0.0:
		player_sprite.flip_h = false
		player_sprite.play("walk")
	elif is_jumping:
		player_sprite.play("walk")
	else:
		player_sprite.play("idle")

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		if waiting_for_continue:
			_close_dialogue()
			get_viewport().set_input_as_handled()
		elif near_client and not player_frozen:
			_open_dialogue()
			get_viewport().set_input_as_handled()
		return

	if player_frozen and dialogue_panel.visible and choices.visible and event is InputEventKey and event.pressed and not event.echo:
		match event.keycode:
			KEY_1:
				_select_choice(1)
			KEY_2:
				_select_choice(2)
			KEY_3:
				_select_choice(3)

func _setup_animations() -> void:
	player_sprite.sprite_frames = SpriteFrames.new()
	_add_animation(player_sprite.sprite_frames, "idle", "res://assets/processed/player/idle/player_idle_%02d.png", 4, 5.0)
	_add_animation(player_sprite.sprite_frames, "walk", "res://assets/processed/player/walk/player_walk_%02d.png", 4, 8.0)
	player_sprite.scale = PLAYER_FRAME_SCALE

	client_sprite.sprite_frames = SpriteFrames.new()
	_add_animation(client_sprite.sprite_frames, "idle", "res://assets/processed/npcs/elderly_client/idle/client_elderly_idle_%02d.png", 4, 4.0)
	_add_animation(client_sprite.sprite_frames, "worried", "res://assets/processed/npcs/elderly_client/worried/client_elderly_worried_%02d.png", 4, 6.0)
	client_sprite.scale = NPC_FRAME_SCALE

func _add_animation(frames: SpriteFrames, animation_name: StringName, path_pattern: String, count: int, speed: float) -> void:
	frames.add_animation(animation_name)
	frames.set_animation_loop(animation_name, true)
	frames.set_animation_speed(animation_name, speed)

	for index in range(1, count + 1):
		var texture := load(path_pattern % index) as Texture2D
		frames.add_frame(animation_name, texture)

func _connect_signals() -> void:
	interaction_area.body_entered.connect(_on_interaction_body_entered)
	interaction_area.body_exited.connect(_on_interaction_body_exited)
	choice_1.pressed.connect(func(): _select_choice(1))
	choice_2.pressed.connect(func(): _select_choice(2))
	choice_3.pressed.connect(func(): _select_choice(3))

func _on_interaction_body_entered(body: Node2D) -> void:
	if body == player:
		near_client = true
		if not player_frozen:
			prompt.show()

func _on_interaction_body_exited(body: Node2D) -> void:
	if body == player:
		near_client = false
		prompt.hide()

func _open_dialogue() -> void:
	player_frozen = true
	player.velocity = Vector2.ZERO
	prompt.hide()
	waiting_for_continue = false
	client_resolved = _is_active_case_resolved()

	if client_resolved:
		_set_dialogue_text(_get_resolution_text())
		choice_box.hide()
		choices.hide()
		dialogue_panel.show()
		_show_continue_prompt()
		return

	_grant_prototype_case_file()
	_set_dialogue_text(_get_client_pitch())
	_refresh_choice_buttons()
	choice_box.visible = active_theories.size() > 0
	choices.visible = active_theories.size() > 0
	dialogue_panel.show()
	if active_theories.size() > 0:
		choice_1.grab_focus()
	else:
		_show_continue_prompt()

func _select_choice(option: int) -> void:
	if client_resolved or not dialogue_panel.visible or not choices.visible:
		return

	var theory := _get_theory(option)
	if theory.is_empty():
		return

	var resolution_key := _resolution_for_theory(theory)
	var result_text := _get_result_text(resolution_key)
	var rewards := _get_rewards(resolution_key)

	CampaignState.select_theory(active_case_id, str(theory.get("id", "")))
	CampaignState.resolve_case(active_case_id, resolution_key, rewards, result_text)
	client_resolved = true
	_update_hud()
	_set_dialogue_text(result_text)
	choice_box.hide()
	choices.hide()
	_show_continue_prompt()
	_play_worried_briefly()

func _close_dialogue() -> void:
	dialogue_panel.hide()
	player_frozen = false
	waiting_for_continue = false
	if near_client:
		prompt.text = "Press E to talk"
		prompt.show()

func _show_continue_prompt() -> void:
	waiting_for_continue = true
	prompt.text = "Press E to continue"
	prompt.show()

func _set_dialogue_text(text: String) -> void:
	var font_size := 18
	if text.length() > 220:
		font_size = 14
	elif text.length() > 130:
		font_size = 16

	dialogue_text.add_theme_font_size_override("font_size", font_size)
	dialogue_text.text = text

func _play_worried_briefly() -> void:
	client_sprite.play("worried")
	await get_tree().create_timer(1.0).timeout
	client_sprite.play("idle")

func _refresh_choice_buttons() -> void:
	var buttons := [choice_1, choice_2, choice_3]
	for index in range(buttons.size()):
		var button: Button = buttons[index]
		var has_theory := index < active_theories.size()
		button.visible = has_theory
		button.disabled = not has_theory
		if has_theory:
			var theory = active_theories[index]
			if typeof(theory) == TYPE_DICTIONARY:
				button.text = "%d. %s" % [index + 1, str(theory.get("label", "Theory"))]

func _grant_prototype_case_file() -> void:
	if active_case_id == "" or active_case.is_empty():
		return

	CampaignState.visit_location(active_case_id, "office_hub")
	# The current one-scene prototype exposes the whole first case file until travel and inspection scenes exist.
	for evidence in active_case.get("evidence", []):
		if typeof(evidence) == TYPE_DICTIONARY:
			CampaignState.discover_evidence(active_case_id, str(evidence.get("id", "")))

func _get_theory(option: int) -> Dictionary:
	var index := option - 1
	if index < 0 or index >= active_theories.size():
		return {}

	var theory = active_theories[index]
	if typeof(theory) != TYPE_DICTIONARY:
		return {}

	return theory

func _resolution_for_theory(theory: Dictionary) -> String:
	match str(theory.get("quality", "bad")):
		"strong":
			return "full"
		"partial", "weak":
			return "partial"
		_:
			return "bad"

func _get_client_pitch() -> String:
	if active_case.is_empty():
		return FALLBACK_DIALOGUE

	return "%s\n\n%s" % [
		str(active_case.get("title", "Untitled Case")),
		str(active_case.get("client_pitch", FALLBACK_DIALOGUE)),
	]

func _get_result_text(resolution_key: String) -> String:
	var resolutions: Dictionary = active_case.get("resolutions", {})
	var resolution: Dictionary = resolutions.get(resolution_key, {})
	return str(resolution.get("result_text", CLOSED_FILE_DIALOGUE))

func _get_resolution_text() -> String:
	if active_case_id == "":
		return CLOSED_FILE_DIALOGUE

	var state := CampaignState.ensure_case_state(active_case_id)
	return str(state.get("result_text", CLOSED_FILE_DIALOGUE))

func _get_rewards(resolution_key: String) -> Dictionary:
	var rewards_by_resolution: Dictionary = active_case.get("rewards", {})
	var rewards: Dictionary = rewards_by_resolution.get(resolution_key, {})
	return rewards

func _is_active_case_resolved() -> bool:
	if active_case_id == "":
		return false

	return CampaignState.ensure_case_state(active_case_id).get("status", "") == "resolved"

func _update_hud() -> void:
	var total_cases := 1
	if catalog != null:
		total_cases = maxi(catalog.get_case_count(), 1)

	top_hud_text.text = "Cases %d/%d    Rep %d" % [
		CampaignState.get_resolved_case_count(),
		total_cases,
		CampaignState.reputation,
	]
	bottom_hud_text.text = "Money $%d      Stamina %d                         Audit Risk %s" % [
		CampaignState.money,
		CampaignState.stamina,
		CampaignState.get_audit_label(),
	]
