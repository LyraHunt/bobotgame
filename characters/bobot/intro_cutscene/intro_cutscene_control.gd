extends Node

func _ready() -> void:
	Dialogic.start(GameData.intro_cutscene_timeline)
	await Dialogic.timeline_ended
	GameLogic.change_scene(load(GameData.world_scene_path) as PackedScene)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("escape_key"):
		if Dialogic.current_timeline != null:
			Dialogic.end_timeline()
