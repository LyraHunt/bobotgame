extends Node

signal state_changed()
signal controls_changed()
@warning_ignore("unused_signal") signal power_stations_initialized()

enum State {EXPLORING, CHARGING, START_REMBERING, REMBERING, POPUP, MEM_POPUP, DEATH_CUTSCENE}
var state: State = State.CHARGING
var current_memory: GameData.Memory

var controls: Dictionary[String, String] = {
		"device": "",
		"controller_type": ""
	} as Dictionary[String, String]

func change_state(new_state: State) -> void:
	state = new_state
	state_changed.emit()

func change_scene(scene: PackedScene) -> void:
	GameData.power_stations = {}
	get_tree().change_scene_to_packed.call_deferred(scene)

func reload_scene() -> void:
	GameData.power_stations = {}
	get_tree().reload_current_scene()

func update_controller_type() -> void:
	if Input.get_joy_name(0) != "":
		print(Input.get_joy_name(0))
		controls.controller_type = Input.get_joy_name(0)
	else:
		if Input.get_joy_guid(0) == "__XINPUT_DEVICE__":
			controls.controller_type = "Xbox Controller"

func _input(event: InputEvent) -> void:
	var _last_device: String = controls.device
	var _last_controller_type: String = controls.controller_type
	
	match event.get_class():
		"InputEventKey","InputEventMouseButton":
			controls.device = "keyboard"
			controls.controller_type = ""
		
		"InputEventJoypadButton":
			controls.device = "controller"
			update_controller_type()
		
		"InputEventJoypadMotion":
			if absf((event as InputEventJoypadMotion).get_axis_value()) > 0.1:
				controls.device = "controller"
				update_controller_type()
			else:
				print(absf((event as InputEventJoypadMotion).get_axis_value()))
	
	if _last_device != controls.device or _last_controller_type != controls.controller_type:
		controls_changed.emit()
