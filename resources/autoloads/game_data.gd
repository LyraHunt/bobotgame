extends Node

enum Memory {GREENHOUSE, STORAGE_AREA}

var memory_controller_scene: PackedScene = preload("res://main/memories/memory_controller.tscn")
var world_scene: PackedScene = preload("res://main/world/world.tscn")

var memory_scenes: Dictionary[Memory, PackedScene] = {
	#Memories.GREENHOUSE: preload("res://main/memories/greenhouse_memory.tscn")
}

var power_stations: Dictionary[int, PowerStation] = {}
var power_station_count: int = 2

var bobot_charge: float = 5.0
var bobot_last_power_station: int

var acquired_memories: Array[GameData.Memory] = []
var pending_memories: Array[GameData.Memory] = []

func add_power_station_id(new_id: int, power_station: PowerStation) -> void:
	power_stations.set(new_id, power_station)
	if power_stations.keys().size() == power_station_count:
		print(power_stations)
		GameLogic.power_stations_initialized.emit()

func _ready() -> void:
	bobot_last_power_station = 0
