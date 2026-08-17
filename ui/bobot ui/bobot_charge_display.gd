extends Control

@onready var charge_rect: ColorRect = get_node("ColorRect")
@onready var charge_border: TextureRect = get_node("ChargeBorder")
@export var charge_color_ramp: Gradient

var max_width: float = 4.5

func _process(_delta: float) -> void:
	var charge_ratio: float = GameData.bobot_charge / GameData.bobot_max_charge
	charge_rect.color = charge_color_ramp.sample(charge_ratio)
	charge_rect.scale.x = (charge_ratio) * max_width + 0.05
	
	charge_border.position.x = lerp(840, 1030, charge_ratio) + 5
	charge_border.modulate = charge_color_ramp.sample(charge_ratio)
	
