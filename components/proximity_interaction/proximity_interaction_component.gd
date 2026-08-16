class_name ProximityInteractionComponent extends Area2D

signal selection_update(selected: bool)
signal interacted()

@export var sprite: Sprite3D
@export var outline_sprite: bool = true

@export var dynamic_hotkey: DynamicHotkeyComponent


@export var outline_shader: ShaderMaterial
@export var additional_sprite_outline_shader_ref: PackedScene
#var additional_sprite_outline_shader_component: AdditionalSpriteShaderComponent

var selected: bool = false

#var player: WastesPlayer

func _ready() -> void:
	#player = get_tree().get_first_node_in_group("wastes_player") as WastesPlayer
	pass
	"""if sprite and outline_sprite:
		additional_sprite_outline_shader_component = additional_sprite_outline_shader_ref.instantiate()
		additional_sprite_outline_shader_component.target_sprite = sprite
		
		additional_sprite_outline_shader_component.material_override = outline_shader.duplicate()
		(additional_sprite_outline_shader_component.material_override as ShaderMaterial).set_shader_parameter("sprite_texture", sprite.texture)
		(additional_sprite_outline_shader_component.material_override as ShaderMaterial).set_shader_parameter("glow_size", 8)
		additional_sprite_outline_shader_component.visible = false
		
		sprite.add_child(additional_sprite_outline_shader_component)"""

"""func update_outline() -> void:
	if selected:
		additional_sprite_outline_shader_component.visible = true
	else:
		additional_sprite_outline_shader_component.visible = false"""

func select() -> void:
	selection_update.emit(true)
	selected = true
	#if sprite and outline_sprite:
	#	update_outline()
	if dynamic_hotkey:
		dynamic_hotkey.visible = true

func deselect() -> void:
	selection_update.emit(false)
	selected = false
	#if sprite and outline_sprite:
	#	update_outline()
	if dynamic_hotkey:
		dynamic_hotkey.visible = false

func interact() -> void:
	interacted.emit()

# pick up via mouse, data from MouseHoverComponent
#func _on_mouse_hover_component_sprite_input_event(_camera: Node, event: InputEvent, _input_position: Vector3, _normal: Vector3) -> void:
	#if event is InputEventMouseButton and event.is_pressed():
		#if player.proximity_interactor_component.interactions_array.has(self):
		#	interact()
