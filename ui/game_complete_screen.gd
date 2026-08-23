extends Control

@onready var complete_screen_2: TextureRect = get_node("TextureRect2")
@onready var complete_screen_3: TextureRect = get_node("TextureRect3")

func _ready() -> void:
	await get_tree().create_timer(1).timeout
	var escape_tween_1: Tween = get_tree().create_tween()
	escape_tween_1.tween_property(complete_screen_2, "modulate", Color.WHITE, 2.0)
	
	await get_tree().create_timer(3).timeout
	var escape_tween_2: Tween = get_tree().create_tween()
	escape_tween_2.tween_property(complete_screen_3, "modulate", Color.WHITE, 1.0)
