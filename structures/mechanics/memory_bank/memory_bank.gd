class_name MemoryBank extends Node2D

@export var memory_id: GameData.Memory
var bobot: Bobot

func _ready() -> void:
	if is_inside_tree():
		bobot = get_tree().get_first_node_in_group("bobot")

func _on_proximity_interaction_component_selection_update(selected: bool) -> void:
	if selected:
		modulate = Color(0.5, 0.5, 0.5)
	else:
		modulate = Color.WHITE

func _on_proximity_interaction_component_interacted() -> void:
	bobot.add_memory(memory_id)
	queue_free()
