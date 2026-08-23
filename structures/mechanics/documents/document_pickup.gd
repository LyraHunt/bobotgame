class_name DocumentPickup extends Node2D

signal collected

@export var document_id: GameData.Document
@export var sprites_to_hide: Array[Sprite2D]
@export var sprites_to_show: Array[Sprite2D]

@onready var hotkey_component: DynamicHotkeyComponent = get_node("DynamicHotkeyComponent")

var bobot: Bobot
var been_collected: bool = false

func _ready() -> void:
	if GameData.acquired_documents.has(document_id) or GameData.pending_documents.has(document_id):
		collect()

func _on_proximity_interaction_component_interacted() -> void:
	if not been_collected:
		bobot = get_tree().get_first_node_in_group("bobot")
		bobot.add_document(document_id)
		collect()

func collect() -> void:
	been_collected = true
	collected.emit()
	for sprite: Sprite2D in sprites_to_hide:
		sprite.queue_free()
	for sprite: Sprite2D in sprites_to_show:
		sprite.visible = true
	hotkey_component.queue_free()
