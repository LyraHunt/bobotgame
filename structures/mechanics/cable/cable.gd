class_name ProgressionPickup extends Node2D

@onready var hotkey_component: DynamicHotkeyComponent = get_node("DynamicHotkeyComponent")
@export var progression_id: String
@export var flavor_text_id: String

func _ready() -> void:
	if GameData.check_progress(progression_id):
		collect()

func _on_proximity_interaction_component_interacted() -> void:
	if not GameData.check_progress(progression_id):
		GameData.pending_progress[progression_id] = true
		collect()

func collect() -> void:
	show_flavor_text()
	visible = false
	hotkey_component.queue_free()

func show_flavor_text() -> void:
	if GameLogic.state == GameLogic.State.EXPLORING and GameData.flavor_text_exists(flavor_text_id):
		GameLogic.change_state(GameLogic.State.FLAVOR)
		
		if Dialogic.current_timeline != null:
			return
		GameData.play_flavor_timeline(flavor_text_id)
		
		await Dialogic.timeline_ended
		GameLogic.change_state(GameLogic.State.EXPLORING)
