class_name CRT extends StaticBody2D


func _on_proximity_interaction_component_selection_update(selected: bool) -> void:
	if selected:
		modulate = Color(0.5, 0.5, 0.5)
	else:
		modulate = Color.WHITE
