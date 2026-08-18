class_name Doorway extends Area2D

@export var connected_doorway: Doorway

var bobot: Bobot

func _ready() -> void:
	bobot = get_tree().get_first_node_in_group("bobot")


func _on_proximity_interaction_component_interacted() -> void:
	if connected_doorway:
		bobot.global_position = connected_doorway.global_position
