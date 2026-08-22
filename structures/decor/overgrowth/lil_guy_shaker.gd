extends Sprite2D

func _ready() -> void:
	self_modulate = Color(1.0, randf_range(0.9, 1.0), randf_range(0.9, 1.0))
	flip_h = randf() > 0.5
