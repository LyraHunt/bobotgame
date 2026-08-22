class_name LabDoorway extends Doorway

var can_open: bool = false
var flavor_text_id: String = "lab_doorway_locked"

func _on_proximity_interaction_component_interacted() -> void:
	can_open = GameData.check_progress("has_lab_passkey")
	if can_open:
		enter()
	else:
		show_flavor_text()

func enter() -> void:
	if connected_doorway:
		SoundManager.play_sound((SRM as SoundResourceManager).get_sound("sfx_door_open")).volume_db = -12
		
		bobot.global_position = connected_doorway.global_position
		await get_tree().physics_frame
		await get_tree().physics_frame
		bobot.proximity_interactor_component.queue_proximity_check()

func show_flavor_text() -> void:
	if GameLogic.state == GameLogic.State.EXPLORING and GameData.flavor_text_exists(flavor_text_id):
		GameLogic.state = GameLogic.State.FLAVOR
		
		if Dialogic.current_timeline != null:
			return
		GameData.play_flavor_timeline(flavor_text_id)
		
		await Dialogic.timeline_ended
		GameLogic.state = GameLogic.State.EXPLORING
