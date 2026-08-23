extends Control

@onready var complete_screen_2: TextureRect = get_node("TextureRect2")

func _ready() -> void:
	await get_tree().create_timer(1).timeout
	var escape_tween: Tween = get_tree().create_tween()
	escape_tween.tween_property(complete_screen_2, "modulate", Color.WHITE, 2.0)
