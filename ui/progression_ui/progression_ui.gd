class_name ProgressionUI extends Control

@onready var quarters_keycard_sprite: TextureRect = get_node("HBoxContainer/QuartersKeycard/TextureRect")
@onready var lab_keycard_sprite: TextureRect = get_node("HBoxContainer/LabKeycard/TextureRect")
@onready var cable_sprite: TextureRect = get_node("HBoxContainer/Cable/TextureRect")

func _process(_delta: float) -> void:
	quarters_keycard_sprite.visible = GameData.check_progress("has_quarters_passkey")
	lab_keycard_sprite.visible = GameData.check_progress("has_lab_passkey")
	cable_sprite.visible = GameData.check_progress("picked_up_cable")
