class_name PowerBox extends StaticBody2D

@export var sprites_to_hide: Array[Sprite2D]
@export var sprites_to_show: Array[Sprite2D]

@onready var hotkey_component: DynamicHotkeyComponent = get_node("DynamicHotkeyComponent")
@onready var second_shader_pass_component: SecondShaderPassComponent = get_node("SecondShaderPassComponent")
@onready var password_inputs: Control = get_node("CanvasLayer/PowerBoxPassword")

var bobot: Bobot

var flavor_text_id: String = "power_box_locked"

func _ready() -> void:
	if GameData.check_progress("opened_power_box"):
		open()

func _on_proximity_interaction_component_interacted() -> void:
	if not GameData.check_progress("opened_power_box"):
		#if not GameData.check_progress("has_power_box_passkey"):
		show_flavor_text()

func open() -> void:
	for sprite: Sprite2D in sprites_to_hide:
		#sprite.visible = false
		sprite.queue_free()
	for sprite: Sprite2D in sprites_to_show:
		sprite.visible = true
	hotkey_component.queue_free()
	if second_shader_pass_component:
		second_shader_pass_component.stop_mirroring()


func _on_proximity_interaction_component_selection_update(selected: bool) -> void:
	if second_shader_pass_component:
		if selected and not GameData.check_progress("opened_power_box"):
			second_shader_pass_component.start_mirroring()
		else:
			second_shader_pass_component.stop_mirroring()

func show_flavor_text() -> void:
	if GameLogic.state == GameLogic.State.EXPLORING and GameData.flavor_text_exists(flavor_text_id):
		GameLogic.state = GameLogic.State.FLAVOR
		
		if Dialogic.current_timeline != null:
			return
		GameData.play_flavor_timeline(flavor_text_id)
		
		await Dialogic.timeline_ended
		
		password_inputs.visible = true
		#Dialogic.start(load())
		#Dialogic.start_timeline()
		
		#GameLogic.state = GameLogic.State.EXPLORING


func _on_power_box_password_closed() -> void:
	password_inputs.visible = false
	GameLogic.state = GameLogic.State.EXPLORING


func _on_power_box_password_completed() -> void:
	password_inputs.visible = false
	GameLogic.state = GameLogic.State.EXPLORING
	
	GameData.pending_progress["opened_power_box"] = true
	open()
