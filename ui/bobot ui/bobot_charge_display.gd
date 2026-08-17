extends Control

@onready var charge_rect: ColorRect = get_node("ColorRect")
@export var charge_color_ramp: Gradient

var max_width: float = 5.24

func _process(_delta: float) -> void:
	charge_rect.color = charge_color_ramp.sample(GameData.bobot_charge / GameData.bobot_max_charge)
	charge_rect.scale.x = GameData.bobot_charge / GameData.bobot_max_charge * max_width
