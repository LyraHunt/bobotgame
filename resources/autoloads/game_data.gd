extends Node

enum Memory {GREENHOUSE, STORAGE_AREA, KITCHEN, ALICE_QUARTERS, LAB}

var memory_controller_scene: PackedScene = preload("res://main/memories/memory_controller.tscn")
var world_scene: PackedScene = preload("res://main/world/world.tscn")

var memory_timelines: Dictionary[Memory, DialogicTimeline] = {
	Memory.GREENHOUSE: preload("res://resources/dialogic stuffs/cutscenes/memory_greenhouse_bot.dtl"),
	Memory.STORAGE_AREA: preload("res://resources/dialogic stuffs/cutscenes/memory_cargo_bot.dtl"),
	Memory.KITCHEN: preload("res://resources/dialogic stuffs/cutscenes/memory_chef_bot.dtl"),
	Memory.ALICE_QUARTERS: preload("res://resources/dialogic stuffs/cutscenes/memory_record_bot.dtl"),
	Memory.LAB: preload("res://resources/dialogic stuffs/cutscenes/memory_research_bot.dtl")
}

var memory_casette_sprites: Dictionary[Memory, Texture] = {
	Memory.GREENHOUSE: preload("res://ui/casettes ui/Bobot cassette.PNG"),
	Memory.STORAGE_AREA: preload("res://ui/casettes ui/Bobot cassette.PNG"),
	Memory.KITCHEN: preload("res://ui/casettes ui/Bobot cassette.PNG"),
	Memory.ALICE_QUARTERS: preload("res://ui/casettes ui/Bobot cassette.PNG"),
	Memory.LAB: preload("res://ui/casettes ui/Research bot cassette.PNG")
}

var robot_ids: Dictionary[Memory, String] = {
	Memory.GREENHOUSE: "BT-534-04",
	Memory.STORAGE_AREA: "CO-56-02",
	Memory.KITCHEN: "CX-574-03",
	Memory.ALICE_QUARTERS: "MN-134-02",
	Memory.LAB: "SC-912-08"
}

var power_stations: Dictionary[int, PowerStation] = {}
var power_station_count: int = 2

var bobot_charge: float = 40.0
var bobot_max_charge: float = 40.0
var bobot_charge_per_sec: float = 10.0
var bobot_last_power_station: int

var pending_memories: Array[Memory] = []
var acquired_memories: Array[Memory] = []

func add_power_station_id(new_id: int, power_station: PowerStation) -> void:
	power_stations.set(new_id, power_station)
	if power_stations.keys().size() == power_station_count:
		print(power_stations)
		GameLogic.power_stations_initialized.emit()

func _ready() -> void:
	bobot_last_power_station = 0
