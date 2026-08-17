class_name MovementComponent extends Node

var motion_input: Vector2

@export var friction: float = 0.8
@export var movement_mult: float = 60.0

@export var target_character_body: CharacterBody2D

#@export var footprint_particles: GPUParticles3D

@export_group("Get Wiggly With It")
@export var sprite_to_wiggle: Node2D
@export var sprite_wiggle_msec: float = 50
@export var sprite_wiggle_intensity: float = 0.1

var starting_scale: float = 1.0

func _ready() -> void:
	if sprite_to_wiggle:
		starting_scale = sprite_to_wiggle.scale.x
		#sprite_wiggle_intensity *= starting_scale

func _physics_process(_delta: float) -> void:
	if motion_input.length() != 0:
		_move_character(motion_input)
		if sprite_to_wiggle:
			sprite_to_wiggle.scale.y = starting_scale + remap(sin(Time.get_ticks_msec() / sprite_wiggle_msec), -1.0, 1.0, -sprite_wiggle_intensity, sprite_wiggle_intensity) * starting_scale
	elif sprite_to_wiggle:
		sprite_to_wiggle.scale.y = starting_scale
	if target_character_body:
		_apply_friction_on_target()
	
	#if footprint_particles:
	#	footprint_particles.emitting = motion_input.length() != 0

func _move_character(movement: Vector2) -> void:
	var scaled_movement: Vector2 = movement * movement_mult
	#print(scaled_movement)
	target_character_body.velocity.x += scaled_movement.x
	target_character_body.velocity.y -= scaled_movement.y

func _apply_friction_on_target() -> void:
	target_character_body.velocity *= friction
	
	if target_character_body.velocity.length() < 0.0001:
		target_character_body.velocity = Vector2.ZERO
