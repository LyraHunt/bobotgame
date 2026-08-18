class_name MemoryBank extends Node2D

@export var memory_id: GameData.Memory
@export var sprites_to_hide: Array[Sprite2D]
var bobot: Bobot

var been_collected: bool = false

func _ready() -> void:
	if GameData.acquired_memories.has(memory_id) or GameData.pending_memories.has(memory_id):
		collect()

func _on_proximity_interaction_component_interacted() -> void:
	if not been_collected:
		bobot = get_tree().get_first_node_in_group("bobot")
		bobot.add_memory(memory_id)
		collect()

func collect() -> void:
	been_collected = true
	for sprite: Sprite2D in sprites_to_hide:
		sprite.visible = false
