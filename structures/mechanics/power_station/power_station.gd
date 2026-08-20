class_name PowerStation extends Node2D

@export var power_station_id: int = -1

@onready var dynamic_hotkey_component: DynamicHotkeyComponent = get_node("DynamicHotkeyComponent")
var bobot: Bobot

func _ready() -> void:
	bobot = get_tree().get_first_node_in_group("bobot")
	GameData.add_power_station_id(power_station_id, self)
	#GameData.power_stations[power_station_id] = self

func _on_proximity_interaction_component_selection_update(selected: bool) -> void:
	if selected:
		modulate = Color(0.5, 0.5, 0.5)
	else:
		modulate = Color.WHITE

func _on_proximity_interaction_component_interacted() -> void:
	bobot.start_charge(self)
	dynamic_hotkey_component.visible = false
