class_name MemoryController extends Node

func _ready() -> void:
	match GameLogic.current_memory:
		GameData.Memory.GREENHOUSE:
			print("green in the house")
			memory_ended()
		GameData.Memory.STORAGE_AREA:
			print("storing the area")
			memory_ended()

func memory_ended() -> void:
	GameData.acquired_memories.append(GameLogic.current_memory)
	GameLogic.state = GameLogic.State.CHARGING
	GameLogic.change_scene(GameData.world_scene)
