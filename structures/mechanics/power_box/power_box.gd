class_name PowerBox extends StaticBody2D

@export var sprites_to_hide: Array[Sprite2D]
@export var sprites_to_show: Array[Sprite2D]

@onready var hotkey_component: DynamicHotkeyComponent = get_node("DynamicHotkeyComponent")
@onready var second_shader_pass_component: SecondShaderPassComponent = get_node("SecondShaderPassComponent")
@onready var second_shader_pass_component_opened: SecondShaderPassComponent = get_node("SecondShaderPassComponentOpened")
@onready var password_inputs: PowerBoxPassword = get_node("CanvasLayer/PowerBoxPassword")

@onready var proximity_interaction_component: ProximityInteractionComponent = get_node("ProximityInteractionComponent")

@onready var sprite_cable: Sprite2D = get_node("Sprite2DCable")

var bobot: Bobot

var password_flavor_text_id: String = "power_box_locked"
var opened_flavor_text_id: String = "power_box_cable"

func _ready() -> void:
	if GameData.check_progress("opened_power_box"):
		open()

func _on_proximity_interaction_component_interacted() -> void:
	if not GameData.check_progress("opened_power_box"):
		#if not GameData.check_progress("has_power_box_passkey"):
		show_flavor_text()
	elif not GameData.check_progress("powered_box"):
		if not GameData.check_progress("picked_up_cable"):
			show_flavor_text()
		else:
			power()

func open() -> void:
	print("power box open")
	for sprite: Sprite2D in sprites_to_hide:
		#sprite.visible = false
		sprite.queue_free()
	for sprite: Sprite2D in sprites_to_show:
		sprite.visible = true
	if proximity_interaction_component.selected:
		second_shader_pass_component.stop_mirroring()
		second_shader_pass_component_opened.start_mirroring()
		GameLogic.change_state(GameLogic.State.EXPLORING)

func power() -> void:
	GameLogic.change_state(GameLogic.State.DOOR_OPEN)
	GameData.actual_progress["powered_box"] = true
	second_shader_pass_component.stop_mirroring()
	second_shader_pass_component_opened.stop_mirroring()
	hotkey_component.queue_free()
	sprite_cable.visible = true
	GameLogic.power_on.emit()

func _on_proximity_interaction_component_selection_update(selected: bool) -> void:
	if second_shader_pass_component:
		if selected:
			if not GameData.check_progress("opened_power_box"):
				print("not opened")
				second_shader_pass_component.start_mirroring()
			
			elif GameData.check_progress("opened_power_box") and not GameData.check_progress("powered_box"):
				second_shader_pass_component_opened.start_mirroring()
		else:
			second_shader_pass_component.stop_mirroring()
			second_shader_pass_component_opened.stop_mirroring()

func show_flavor_text() -> void:
	if GameLogic.state == GameLogic.State.EXPLORING:
		if not GameData.check_progress("opened_power_box"):
			if GameData.flavor_text_exists(password_flavor_text_id):
				GameLogic.change_state(GameLogic.State.FLAVOR)
				
				if Dialogic.current_timeline != null:
					return
				GameData.play_flavor_timeline(password_flavor_text_id)
				
				await Dialogic.timeline_ended
				
				password_inputs.visible = true
				password_inputs.update_display()
		elif not GameData.check_progress("powered_box"):
			if GameData.flavor_text_exists(opened_flavor_text_id):
				GameLogic.change_state(GameLogic.State.FLAVOR)
				
				if Dialogic.current_timeline != null:
					return
				GameData.play_flavor_timeline(opened_flavor_text_id)
				
				await Dialogic.timeline_ended
				GameLogic.change_state(GameLogic.State.EXPLORING)


func _on_power_box_password_closed() -> void:
	password_inputs.visible = false
	GameLogic.change_state(GameLogic.State.EXPLORING)


func _on_power_box_password_completed() -> void:
	password_inputs.visible = false
	GameData.pending_progress["opened_power_box"] = true
	SoundManager.play_sound((SRM as SoundResourceManager).get_sound("casette_collected")).volume_db = -8
	open()
