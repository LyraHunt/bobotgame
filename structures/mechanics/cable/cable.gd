class_name ProgressionPickup extends Node2D

@onready var hotkey_component: DynamicHotkeyComponent = get_node("DynamicHotkeyComponent")
@export var progression_id: String

func _ready() -> void:
	if GameData.check_progress(progression_id):
		collect()

func _on_proximity_interaction_component_interacted() -> void:
	if not GameData.check_progress(progression_id):
		GameData.pending_progress[progression_id] = true
		collect()

func collect() -> void:
	visible = false
	hotkey_component.queue_free()
