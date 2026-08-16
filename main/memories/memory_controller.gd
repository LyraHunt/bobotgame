class_name MemoryController extends Node

func _ready() -> void:
	Dialogic.signal_event.connect(func(param: Variant) -> void:
		if param is String:
			@warning_ignore("unsafe_cast")
			if (param as String) == "memory_ended":
				memory_ended()
	)
	
	match GameLogic.current_memory:
		GameData.Memory.GREENHOUSE:
			print("green in the house")
			if Dialogic.current_timeline != null:
				return
			Dialogic.start(GameData.memory_timelines[GameData.Memory.GREENHOUSE]) 
		GameData.Memory.STORAGE_AREA:
			print("storing the area")
			memory_ended()



func memory_ended() -> void:
	GameData.acquired_memories.append(GameLogic.current_memory)
	GameData.bobot_charge = GameData.bobot_max_charge
	
	GameLogic.state = GameLogic.State.CHARGING
	GameLogic.change_scene(GameData.world_scene)
