class_name ProximityInteractionComponent extends Area2D

signal selection_update(selected: bool)
signal interacted()

@export var sprite: Sprite2D
@export var outline_sprite: bool = true

@export var dynamic_hotkey: DynamicHotkeyComponent


@export var outline_shader: ShaderMaterial
#var additional_sprite_outline_shader_component: AdditionalSpriteShaderComponent

var selected: bool = false

func update_outline() -> void:
	if selected:
		sprite.material = outline_shader
	else:
		sprite.material = null

func select() -> void:
	selection_update.emit(true)
	selected = true
	if sprite and outline_sprite:
		update_outline()
	if dynamic_hotkey:
		dynamic_hotkey.visible = true

func deselect() -> void:
	selection_update.emit(false)
	selected = false
	if sprite and outline_sprite:
		update_outline()
	if dynamic_hotkey:
		dynamic_hotkey.visible = false

func interact() -> void:
	interacted.emit()

# pick up via mouse, data from MouseHoverComponent
#func _on_mouse_hover_component_sprite_input_event(_camera: Node, event: InputEvent, _input_position: Vector3, _normal: Vector3) -> void:
	#if event is InputEventMouseButton and event.is_pressed():
		#if player.proximity_interactor_component.interactions_array.has(self):
		#	interact()
