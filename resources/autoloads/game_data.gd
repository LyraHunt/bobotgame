extends Node

#enum Memory {GREENHOUSE, STORAGE_AREA, KITCHEN, ALICE_QUARTERS, LAB}
enum Memory {GREENHOUSE, STORAGE_AREA, ALICE_QUARTERS, LAB}

var memory_controller_scene: PackedScene = preload("res://main/memories/memory_controller.tscn")
var world_scene: PackedScene = preload("res://main/world/world.tscn")

var memory_timelines: Dictionary[Memory, DialogicTimeline] = {
	Memory.GREENHOUSE: preload("res://resources/dialogic stuffs/cutscenes/memory_greenhouse_bot.dtl"),
	Memory.STORAGE_AREA: preload("res://resources/dialogic stuffs/cutscenes/memory_cargo_bot.dtl"),
	#Memory.KITCHEN: preload("res://resources/dialogic stuffs/cutscenes/memory_chef_bot.dtl"),
	Memory.ALICE_QUARTERS: preload("res://resources/dialogic stuffs/cutscenes/memory_record_bot.dtl"),
	Memory.LAB: preload("res://resources/dialogic stuffs/cutscenes/memory_research_bot.dtl")
}

var memory_casette_sprites: Dictionary[Memory, Texture] = {
	Memory.GREENHOUSE: preload("res://ui/casettes ui/Bobot cassette.PNG"),
	Memory.STORAGE_AREA: preload("res://ui/casettes ui/Cargo bot cassette.PNG"),
	#Memory.KITCHEN: preload("res://ui/casettes ui/Bobot cassette.PNG"),
	Memory.ALICE_QUARTERS: preload("res://ui/casettes ui/Recording bot cassette.PNG"),
	Memory.LAB: preload("res://ui/casettes ui/Research bot cassette.PNG")
}

var robot_ids: Dictionary[Memory, String] = {
	Memory.GREENHOUSE: "BT-534-04",
	Memory.STORAGE_AREA: "CO-56-02",
	#Memory.KITCHEN: "CX-574-03",
	Memory.ALICE_QUARTERS: "MN-134-02",
	Memory.LAB: "SC-912-08"
}

var power_stations: Dictionary[int, PowerStation] = {}
var power_station_count: int = 2

var bobot_charge: float = 50.0
var bobot_max_charge: float = 50.0
var bobot_charge_per_sec: float = 10.0
var bobot_last_power_station: int

var pending_memories: Array[Memory] = []
var acquired_memories: Array[Memory] = []
var queue_first_memory: bool = true
#var acquired_memories: Array[Memory] = [Memory.GREENHOUSE, Memory.STORAGE_AREA, Memory.LAB]
#var acquired_memories: Array[Memory] = [Memory.STORAGE_AREA, Memory.LAB, Memory.ALICE_QUARTERS]

var selected_casette: Memory
var casette_is_selected: bool

var pending_progress: Dictionary[String, bool] = {
	"has_quarters_passkey": false,
	"has_lab_passkey": false,
	#"has_power_box_passkey": false,
	"opened_power_box": false,
	"picked_up_cable": false,
	"powered_box": false
}

var actual_progress: Dictionary[String, bool] = {
	"has_quarters_passkey": false,
	"has_lab_passkey": false,
	#"has_power_box_passkey": false,
	"opened_power_box": false,
	"picked_up_cable": false,
	"powered_box": false
}

# flavor text stuff
var flavor_text_folder: String = "res://resources/dialogic stuffs/flavor_texts/"

var debug_mode: bool = true

func add_power_station_id(new_id: int, power_station: PowerStation) -> void:
	power_stations.set(new_id, power_station)
	if power_stations.keys().size() == power_station_count:
		GameLogic.power_stations_initialized.emit()

func flavor_text_exists(flavor_id: String) -> bool:
	return FileAccess.file_exists(flavor_text_folder + flavor_id + ".dtl")

func play_flavor_timeline(flavor_id: String) -> void:
	if FileAccess.file_exists(flavor_text_folder + flavor_id + ".dtl"):
		Dialogic.start(load(flavor_text_folder + flavor_id + ".dtl"))

func check_progress(progress_key: String) -> bool:
	return pending_progress[progress_key] or actual_progress[progress_key]

func save_progression() -> void:
	for key: String in pending_progress.keys():
		actual_progress[key] = pending_progress[key] or actual_progress[key]
	pending_progress = actual_progress.duplicate()

func _ready() -> void:
	if debug_mode:
		actual_progress["has_quarters_passkey"] = true
		actual_progress["has_lab_passkey"] = true
		bobot_last_power_station = 1
		queue_first_memory = false
	
	else:
		bobot_last_power_station = 0
		acquired_memories.append(Memory.GREENHOUSE)
		queue_first_memory = true
