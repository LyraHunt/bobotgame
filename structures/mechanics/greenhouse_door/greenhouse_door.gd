class_name GreenhouseDoor extends Area2D

@onready var normal_sprite: Sprite2D = get_node("Sprite2D")
@onready var opened_sprite: Sprite2D = get_node("Sprite2DOpened")

@onready var proximity_inspection_component: ProximityInspectionComponent = get_node("ProximityInspectionComponent")
@onready var proximity_interaction_component: ProximityInteractionComponent = get_node("ProximityInteractionComponent")
@onready var dynamic_hotkey_component: DynamicHotkeyComponent = get_node("DynamicHotkeyComponent")

var bobot: Bobot

func _ready() -> void:
	bobot = get_tree().get_first_node_in_group("bobot")
	#open()

func open() -> void:
	proximity_inspection_component.queue_free()
	proximity_interaction_component.monitorable = true
	#dynamic_hotkey_component.icon_type_inspect = false
	opened_sprite.visible = true
	opened_sprite.modulate = Color.TRANSPARENT
	var open_tween: Tween = get_tree().create_tween()
	open_tween.set_parallel(true)
	open_tween.tween_property(normal_sprite, "global_position", normal_sprite.global_position + Vector2(0, 150), 0.8).set_ease(Tween.EASE_OUT)
	open_tween.tween_property(normal_sprite, "modulate", Color(0.0, 0.0, 0.0, 0.0), 1.0).set_ease(Tween.EASE_OUT)
	open_tween.tween_property(opened_sprite, "modulate", Color.WHITE, 1.0).set_ease(Tween.EASE_OUT)

func opened() -> void:
	normal_sprite.visible = false
	opened_sprite.modulate = Color.WHITE
	

func _on_proximity_interaction_component_selection_update(selected: bool) -> void:
	if selected:
		opened_sprite.modulate = Color(0.6,0.6,0.6)
	else:
		opened_sprite.modulate = Color.WHITE

func _on_proximity_interaction_component_interacted() -> void:
	GameLogic.change_state(GameLogic.State.ESCAPED)
	GameLogic.bobot_escaped.emit()
	proximity_interaction_component.queue_free()
	opened_sprite.material = null
	opened_sprite.modulate = Color.WHITE
