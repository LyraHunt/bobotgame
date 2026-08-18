class_name BobotVignette extends Control

func _process(_delta: float) -> void:
	var charge_ratio: float = GameData.bobot_charge / GameData.bobot_max_charge
	var vignette_opacity: float = remap(charge_ratio, 1.0, 0.0, -0.9, 0.9)
	self.modulate = Color(1,1,1,vignette_opacity)
