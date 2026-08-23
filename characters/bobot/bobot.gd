class_name Bobot extends CharacterBody2D

@export var spotlight_energy_ramp: Gradient
@export var eye_icon: Texture
@export var arm_icon: Texture

@onready var movement_component: MovementComponent = get_node("MovementComponent")
@onready var proximity_interactor_component: ProximityInteractorComponent = get_node("ProximityInteractorComponent")

@onready var animated_sprite: AnimatedSprite2D = get_node("AnimatedSprite2D")

@onready var charge_label: RichTextLabel = get_node("CanvasLayer/RichTextLabel")
@onready var casette_popup: CasettePopup = get_node("CanvasLayer/CasettePopup")
@onready var document_popup: DocumentPopup = get_node("CanvasLayer/DocumentPopup")
@onready var memory_ui: MemoryUI = get_node("CanvasLayer/MemoryUI")
@onready var vignette: Control = get_node("CanvasLayer/BobotVignette")
@onready var escape_countdown: EscapeCountdown = get_node("CanvasLayer/EscapeCountdown")
@onready var interaction_icon: TextureRect = get_node("CanvasLayer/InteractionIcon")
@onready var controls: ColorRect = get_node("CanvasLayer/Controls")
var node_for_icon_tracking: Node2D

@onready var idle_timer: Timer = get_node("IdleTimer")
@onready var escape_timer: Timer = get_node("EscapeTimer")
@onready var spotlight: PointLight2D = get_node("Spotlight")

@onready var escape_fade_black: ColorRect = get_node("CanvasLayer/EscapeFadeBlack")

@onready var collision_shape: CollisionShape2D = get_node("CollisionShape2D")

var casette_popup_timer: SceneTreeTimer
var death_cutscene_timer: SceneTreeTimer
var start_casette_timer: SceneTreeTimer

var eepy_tween: Tween
var camera: Camera

var is_playing_footsteps: bool = false
#var footsteps_audiostream: AudioStreamPlayer

var ready_to_escape: bool = false

func _ready() -> void:
	#start_charge(GameData.power_stations[GameData.bobot_last_power_station])
	GameLogic.power_stations_initialized.connect(_start_charge_on_load)
	GameLogic.start_countdown.connect(start_countdown_display)
	GameLogic.bobot_escaped.connect(escape)
	
	camera = get_tree().get_first_node_in_group("camera")
	SoundManager.stop_sound((SRM as SoundResourceManager).get_sound("casette_collected"))
	
	if GameData.queue_first_memory:
		GameData.queue_first_memory = false
		switch_to_memory(GameData.Memory.GREENHOUSE)
	elif GameData.queue_intro_cutscene:
		GameData.queue_intro_cutscene = false
		GameLogic.change_scene(GameData.intro_cutscene_control)
	elif GameData.queue_controls:
		GameData.queue_controls = false
		controls.visible = true
		GameLogic.change_state(GameLogic.State.CONTROLS)
		
		SoundManager.play_music((SRM as SoundResourceManager).get_sound("lab"))
	else:
		SoundManager.play_music((SRM as SoundResourceManager).get_sound("lab"))

func _start_charge_on_load() -> void:
	#add_memory(GameData.Memory.GREENHOUSE)
	if GameLogic.state != GameLogic.State.CONTROLS:
		print("starting charge")
		start_charge(GameData.power_stations[GameData.bobot_last_power_station])

func add_memory(memory_id: GameData.Memory) -> void:
	casette_popup.visible = true
	casette_popup.set_casette_and_animate(memory_id)
	GameLogic.change_state(GameLogic.State.POPUP)
	GameData.pending_memories.append(memory_id)
	SoundManager.play_sound((SRM as SoundResourceManager).get_sound("casette_collected")).volume_db = -8
	
	casette_popup_timer = get_tree().create_timer(2.5)
	casette_popup_timer.timeout.connect(close_casette_popup)

func close_casette_popup() -> void:
	casette_popup.visible = false
	GameLogic.change_state(GameLogic.State.EXPLORING)

func add_document(document_id: GameData.Document) -> void:
	document_popup.visible = true
	document_popup.set_document_and_animate(document_id)
	GameLogic.change_state(GameLogic.State.POPUP)
	GameData.pending_documents.append(document_id)
	SoundManager.play_sound((SRM as SoundResourceManager).get_sound("casette_collected")).volume_db = -8
	
	casette_popup_timer = get_tree().create_timer(2.5)
	casette_popup_timer.timeout.connect(close_document_popup)

func close_document_popup() -> void:
	document_popup.visible = false
	GameLogic.change_state(GameLogic.State.EXPLORING)

func start_charge(power_station: PowerStation) -> void:
	global_position = power_station.global_position
	velocity = Vector2.ZERO
	movement_component.motion_input = Vector2.ZERO
	idle_timer.start(2)
	
	GameData.bobot_last_power_station = power_station.power_station_id
	animated_sprite.animation = "charge"
	
	GameLogic.change_state(GameLogic.State.CHARGING)
	
	# move memories from pending to acquired
	for memory: GameData.Memory in GameData.pending_memories:
		GameData.acquired_memories.append(memory)
	GameData.acquired_memories.sort()
	GameData.pending_memories = []
	
	# move documents from pending to acquired
	for document: GameData.Document in GameData.pending_documents:
		GameData.acquired_documents.append(document)
	GameData.acquired_documents.sort()
	GameData.pending_documents = []
	
	GameData.save_progression()
	
	# show memory ui
	#if GameData.acquired_memories.size() > 0:
	memory_ui.visible = true
	memory_ui.update_display()

func stop_charge() -> void:
	#print("stop charge")
	memory_ui.hide_display()
	GameLogic.change_state(GameLogic.State.EXPLORING)

func charge_out() -> void:
	#kill()
	animated_sprite.animation = "death"
	animated_sprite.frame = 0
	
	SoundManager.play_sound((SRM as SoundResourceManager).get_sound("sfx_bobot_die")).volume_db = -8
	SoundManager.stop_music(0.4)
	
	GameLogic.change_state(GameLogic.State.DEATH_CUTSCENE)
	death_cutscene_timer = get_tree().create_timer(3.5)
	death_cutscene_timer.timeout.connect(kill)

func kill() -> void:
	GameData.pending_memories = []
	GameData.bobot_charge = GameData.bobot_max_charge
	GameData.pending_progress["powered_box"] = false
	GameData.actual_progress["powered_box"] = false
	GameLogic.reload_scene()

func start_memory(memory_id: GameData.Memory) -> void:
	SoundManager.play_sound((SRM as SoundResourceManager).get_sound("sfx_casette_play")).volume_db = -8
	GameLogic.change_state(GameLogic.State.START_REMBERING)
	start_casette_timer = get_tree().create_timer(2)
	start_casette_timer.timeout.connect(switch_to_memory.bind(memory_id))

func switch_to_memory(memory_id: GameData.Memory) -> void:
	GameLogic.change_state(GameLogic.State.REMBERING)
	GameLogic.current_memory = memory_id
	GameLogic.change_scene(GameData.memory_controller_scene)

func _physics_process(_delta: float) -> void:
	_handle_movement_input()
	move_and_slide()

func _process(_delta: float) -> void:
	match GameLogic.state:
		GameLogic.State.EXPLORING:
			GameData.bobot_charge -= _delta
			if GameData.bobot_charge <= 0:
				charge_out()
		GameLogic.State.CHARGING:
			GameData.bobot_charge += _delta * GameData.bobot_charge_per_sec
			GameData.bobot_charge = min(GameData.bobot_charge, GameData.bobot_max_charge)
	
	charge_label.visible = GameData.debug_mode
	charge_label.text = "[font_size=32]Charge: " + str(snappedf(GameData.bobot_charge, 0.1))
	charge_label.text += "\n"
	charge_label.text += "Pending Memories: " + str(GameData.pending_memories)
	charge_label.text += "\n"
	charge_label.text += "Acquired Memories: " + str(GameData.acquired_memories)
	
	charge_label.text += "\n"
	charge_label.text += "Pending Documents: " + str(GameData.pending_documents)
	charge_label.text += "\n"
	charge_label.text += "Acquired Documents: " + str(GameData.acquired_documents)
	
	var charge_ratio: float = GameData.bobot_charge / GameData.bobot_max_charge
	spotlight.color = spotlight_energy_ramp.sample(charge_ratio)
	
	interaction_icon.visible = not node_for_icon_tracking == null
	if node_for_icon_tracking:
		interaction_icon.global_position = (node_for_icon_tracking.global_position - global_position) * camera.zoom + Vector2(960, 540) + Vector2(-40, 20)
	
	if GameLogic.state == GameLogic.State.ESCAPED and ready_to_escape:
		if not SoundManager.is_music_playing((SRM as SoundResourceManager).get_sound("escape")):
			GameLogic.change_scene(GameData.game_complete_screen)

func _handle_movement_input() -> void:
	var x_direction: float = Input.get_axis("move_left_key", "move_right_key")
	var y_direction: float = Input.get_axis("move_down_key", "move_up_key")
	var movement_input: Vector2 = Vector2(x_direction, y_direction)
	
	if GameLogic.state != GameLogic.State.EXPLORING:
		movement_input = Vector2.ZERO
	if GameLogic.state == GameLogic.State.ESCAPED:
		movement_input = Vector2.UP
		x_direction = 0.0
		y_direction = 0.0
	
	if movement_input.length() > 0:
		movement_input = movement_input.normalized()
		
		if Input.is_action_pressed("sprint_key") and GameData.debug_mode:
			movement_input *= 1.75
		
		movement_input.y *= 0.8
		
		if movement_component:
			movement_component.motion_input = movement_input
		
		if y_direction > 0:
			animated_sprite.animation = "walk_up"
		elif y_direction < 0:
			animated_sprite.animation = "walk_down"
		elif x_direction > 0:
			animated_sprite.animation = "walk_right"
		elif x_direction < 0:
			animated_sprite.animation = "walk_left"
		
		if not is_playing_footsteps:
			var footsteps: AudioStreamPlayer = SoundManager.play_sound((SRM as SoundResourceManager).get_sound("bobot_footsteps"))
			is_playing_footsteps = true
			await get_tree().process_frame
			footsteps.volume_db = -8
			#footsteps.stop()
			footsteps.play(randf_range(0.0, 3.0))
		
		idle_timer.start(4)
		
	
	elif movement_component:
		movement_component.motion_input = Vector2.ZERO
		
		if animated_sprite.animation.contains("walk_"):
			var animation_suffix: String = animated_sprite.animation.split("_")[1]
			animated_sprite.animation = "stand_" + animation_suffix
		
		if is_playing_footsteps:
			SoundManager.stop_sound((SRM as SoundResourceManager).get_sound("bobot_footsteps"))
			is_playing_footsteps = false

func _unhandled_input(event: InputEvent) -> void:
	match GameLogic.state:
		GameLogic.State.EXPLORING:
			if event.is_action_pressed("interact_key"):
				if proximity_interactor_component.current_selection and proximity_interactor_component.current_selection.selected:
					proximity_interactor_component.current_selection.interact()
		
		GameLogic.State.CHARGING:
			if event.is_action_pressed("escape_key"):
				if memory_ui.document_view_control.visible:
					memory_ui.stop_view_document()
				else:
					stop_charge()
		
		GameLogic.State.POPUP:
			if event.is_action_pressed("escape_key") or event.is_action_pressed("interact_key"):
				casette_popup_timer.timeout.emit()
				casette_popup_timer = null
		
		GameLogic.State.START_REMBERING:
			if event.is_action_pressed("escape_key"):
				start_casette_timer.timeout.emit()
				start_casette_timer = null
		
		GameLogic.State.DEATH_CUTSCENE:
			if event.is_action_pressed("escape_key"):
				death_cutscene_timer.timeout.emit()
				death_cutscene_timer = null
		
		GameLogic.State.CONTROLS:
			if event.is_action_pressed("interact_key"):
				var controls_tween: Tween = get_tree().create_tween()
				controls_tween.tween_property(controls, "modulate", Color.TRANSPARENT, 0.5)
				controls_tween.tween_callback(func () -> void:
					controls.visible = false
				)
				start_charge(GameData.power_stations[GameData.bobot_last_power_station])
			elif event.is_action_pressed("escape_key"):
				var controls_tween: Tween = get_tree().create_tween()
				controls_tween.tween_property(controls, "modulate", Color.TRANSPARENT, 0.5)
				controls_tween.tween_callback(func () -> void:
					controls.visible = false
				)
				start_charge(GameData.power_stations[GameData.bobot_last_power_station])


func _on_idle_timer_timeout() -> void:
	match GameLogic.state:
		GameLogic.State.EXPLORING, GameLogic.State.CHARGING:
			if animated_sprite.animation == "charge":
				animated_sprite.animation = "charge_eepy"
			else:
				animated_sprite.animation = "eepy"
			if eepy_tween:
				eepy_tween.kill()
			eepy_tween = get_tree().create_tween()
			eepy_tween.tween_property(animated_sprite, "scale", Vector2(0.3, 0.25), 0.15)
			eepy_tween.tween_property(animated_sprite, "scale", Vector2(0.3, 0.3), 0.15)
		_:
			idle_timer.start(1)

func track_eye_icon(node: Node2D) -> void:
	node_for_icon_tracking = node
	interaction_icon.texture = eye_icon
	interaction_icon.custom_maximum_size = Vector2(70, 70)

func track_arm_icon(node: Node2D) -> void:
	node_for_icon_tracking = node
	interaction_icon.texture = arm_icon
	interaction_icon.custom_maximum_size = Vector2(100, 100)

func start_countdown_display() -> void:
	escape_timer.start()
	escape_countdown.visible = true
	escape_countdown.timer_ref = escape_timer


func _on_escape_timer_timeout() -> void:
	GameLogic.failed_countdown.emit()
	if GameLogic.state == GameLogic.State.EXPLORING:
		charge_out()

func escape() -> void:
	print("bobot 'scape!")
	
	escape_countdown.timer_ref = null
	escape_countdown.visible = false
	movement_component.movement_mult = 30.0
	animated_sprite.animation = "walk_down"
	collision_shape.disabled = true
	
	escape_fade_black.visible = true
	await get_tree().create_timer(1).timeout
	var escape_tween: Tween = get_tree().create_tween()
	escape_tween.tween_property(escape_fade_black, "modulate", Color.WHITE, 2.0)
	
	await get_tree().create_timer(2).timeout
	SoundManager.stop_sound((SRM as SoundResourceManager).get_sound("bobot_footsteps"))
	ready_to_escape = true
