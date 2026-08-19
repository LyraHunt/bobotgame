@icon("res://ui/controls/keyboard/A_Key_Dark.png")
class_name DynamicHotkeyComponent extends Node2D

@export var sprite: Sprite2D
@export var inputName : String = "move_up_key"

var texture_should_reload: bool = true

func _ready() -> void:
	GameLogic.connect("controls_changed", mark_for_reload)
	mark_for_reload()

func mark_for_reload() -> void:
	if sprite.visible:
		reload_texture()
	else:
		texture_should_reload = true

func change_input(inputNameParam: String) -> void:
	inputName = inputNameParam
	reload_texture()

func iterate_and_find_event(target_input_name: String, input_type: InputEvent) -> InputEvent:
	for i: InputEvent in InputMap.action_get_events(target_input_name):
		if i.get_class() == input_type.get_class():
			return i
	return InputMap.action_get_events(inputName)[0]

func action_verify_input_event(target_input_name: String, input_type: InputEvent) -> bool:
	for i: InputEvent in InputMap.action_get_events(target_input_name):
		if i.get_class() == input_type.get_class():
			return true
	return false

func reload_texture() -> void:
	var hotkey_name : String
	
	#if most recent input was keyboard
	if GameLogic.controls.device == "keyboard":
		hotkey_name = (iterate_and_find_event(inputName, InputEventKey.new()) as InputEventKey).as_text_physical_keycode()
		sprite.texture = load("res://ui/controls/keyboard/" + hotkey_name + "_Key_Dark.png")
	
	#if most recent input was xbox controller
	elif GameLogic.controls.device == "controller":
		match GameLogic.controls.controller_type:
			"Xbox Controller", "Xbox One For Windows":
				#if most recent input was joystick
				if action_verify_input_event(inputName, InputEventJoypadMotion.new()):
					#find if it's left joystick or right joystick
					var joystickAxis : int = (iterate_and_find_event(inputName, InputEventJoypadMotion.new()) as InputEventJoypadMotion).get_axis()
					var joystickAxisValue : float = (iterate_and_find_event(inputName, InputEventJoypadMotion.new()) as InputEventJoypadMotion).get_axis_value()
					
					match joystickAxis:
						0:
							if joystickAxisValue == 1:
								hotkey_name = "Left_Stick_Right"
							elif joystickAxisValue == -1:
								hotkey_name = "Left_Stick_Left"
						1:
							if joystickAxisValue == 1:
								hotkey_name = "Left_Stick_Down"
							elif joystickAxisValue == -1:
								hotkey_name = "Left_Stick_Up"
						2:
							if joystickAxisValue == 1:
								hotkey_name = "Right_Stick_Right"
							elif joystickAxisValue == -1:
								hotkey_name = "Right_Stick_Left"
						3:
							if joystickAxisValue == 1:
								hotkey_name = "Right_Stick_Right"
							elif joystickAxisValue == -1:
								hotkey_name = "Right_Stick_Left"
				#else
				elif action_verify_input_event(inputName, InputEventJoypadButton.new()):
					var buttonIndex: int = (iterate_and_find_event(inputName, InputEventJoypadButton.new()) as InputEventJoypadButton).get_button_index()
					match buttonIndex:
						0:
							hotkey_name = "A"
						1:
							hotkey_name = "B"
						9:
							hotkey_name = "LB"
						10:
							hotkey_name = "RB"
				
				sprite.texture = load("res://ui/controls/xbox_controller/XboxSeriesX_" + hotkey_name + ".png")
		
			#if most recent input was ps4 controller
			"PS4 Controller":
				#if most recent input was joystick
				if action_verify_input_event(inputName, InputEventJoypadMotion.new()):
					#find if it's left joystick or right joystick
					var joystickAxis : int = (iterate_and_find_event(inputName, InputEventJoypadMotion.new()) as InputEventJoypadMotion).get_axis()
					var joystickAxisValue : float = (iterate_and_find_event(inputName, InputEventJoypadMotion.new()) as InputEventJoypadMotion).get_axis_value()
					
					match joystickAxis:
						0:
							if joystickAxisValue == 1:
								hotkey_name = "Left_Stick_Right"
							elif joystickAxisValue == -1:
								hotkey_name = "Left_Stick_Left"
						1:
							if joystickAxisValue == 1:
								hotkey_name = "Left_Stick_Down"
							elif joystickAxisValue == -1:
								hotkey_name = "Left_Stick_Up"
						2:
							if joystickAxisValue == 1:
								hotkey_name = "Right_Stick_Right"
							elif joystickAxisValue == -1:
								hotkey_name = "Right_Stick_Left"
						3:
							if joystickAxisValue == 1:
								hotkey_name = "Right_Stick_Right"
							elif joystickAxisValue == -1:
								hotkey_name = "Right_Stick_Left"
				#else
				elif action_verify_input_event(inputName, InputEventJoypadButton.new()):
					var buttonIndex: int = (iterate_and_find_event(inputName, InputEventJoypadButton.new()) as InputEventJoypadButton).get_button_index()
					match buttonIndex:
						0:
							hotkey_name = "Cross"
						1:
							hotkey_name = "Circle"
						9:
							hotkey_name = "LB"
						10:
							hotkey_name = "RB"
				
				sprite.texture = load("res://ui/controls/ps4_controller/PS4_" + hotkey_name + ".png")


func _on_sprite_2d_visibility_changed() -> void:
	if sprite.visible and texture_should_reload:
		texture_should_reload = false
		reload_texture()
