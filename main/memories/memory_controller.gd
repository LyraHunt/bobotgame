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
			#if Dialogic.current_timeline != null:
			#	return
			Dialogic.start(GameData.memory_timelines[GameData.Memory.GREENHOUSE]) 
		
		GameData.Memory.STORAGE_AREA:
			print("storing the area")
			#if Dialogic.current_timeline != null:
			#	return
			Dialogic.start(GameData.memory_timelines[GameData.Memory.STORAGE_AREA]) 
		
		#GameData.Memory.KITCHEN:
			print("getting cooked")
			#if Dialogic.current_timeline != null:
			#	return
		#	Dialogic.start(GameData.memory_timelines[GameData.Memory.KITCHEN])
		
		GameData.Memory.ALICE_QUARTERS:
			print("lesbians? in my game jam?")
			#if Dialogic.current_timeline != null:
			#	return
			Dialogic.start(GameData.memory_timelines[GameData.Memory.ALICE_QUARTERS])
		
		GameData.Memory.LAB:
			print("what is this, some kind of laboratory?")
			#if Dialogic.current_timeline != null:
			#	return
			Dialogic.start(GameData.memory_timelines[GameData.Memory.LAB])  
	
	SoundManager.play_music((SRM as SoundResourceManager).get_sound("memory_start")).volume_db = -8



func memory_ended() -> void:
	#GameData.acquired_memories.append(GameLogic.current_memory)
	await Dialogic.timeline_ended
	GameData.bobot_charge = GameData.bobot_max_charge
	
	GameLogic.state = GameLogic.State.CHARGING
	GameLogic.change_scene(GameData.world_scene)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("escape_key"):
		if Dialogic.current_timeline != null:
			Dialogic.end_timeline()
			memory_ended()
