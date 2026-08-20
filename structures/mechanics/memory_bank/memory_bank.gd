class_name MemoryBank extends Node2D

signal collected

@export var memory_id: GameData.Memory
@export var sprites_to_hide: Array[Sprite2D]
@export var sprites_to_show: Array[Sprite2D]

@onready var hotkey_component: DynamicHotkeyComponent = get_node("DynamicHotkeyComponent")

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
	collected.emit()
	for sprite: Sprite2D in sprites_to_hide:
		#sprite.visible = false
		sprite.queue_free()
	for sprite: Sprite2D in sprites_to_show:
		sprite.visible = true
	hotkey_component.queue_free()
