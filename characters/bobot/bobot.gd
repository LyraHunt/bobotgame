class_name Bobot extends CharacterBody2D

@onready var movement_component: MovementComponent = get_node("MovementComponent")
@onready var proximity_interactor_component: ProximityInteractorComponent = get_node("ProximityInteractorComponent")

@onready var animated_sprite: AnimatedSprite2D = get_node("AnimatedSprite2D")

@onready var charge_label: RichTextLabel = get_node("CanvasLayer/RichTextLabel")
@onready var casette_popup: CasettePopup = get_node("CanvasLayer/CasettePopup")
var casette_popup_timer: SceneTreeTimer
@onready var memory_ui: MemoryUI = get_node("CanvasLayer/MemoryUI")
@onready var vignette: Control = get_node("CanvasLayer/BobotVignette")


@onready var idle_timer: Timer = get_node("IdleTimer")

var eepy_tween: Tween
var world_scene: PackedScene = preload("res://main/world/world.tscn")

func _ready() -> void:
	#start_charge(GameData.power_stations[GameData.bobot_last_power_station])
	GameLogic.power_stations_initialized.connect(_start_charge_on_load)

func _start_charge_on_load() -> void:
	#add_memory(GameData.Memory.GREENHOUSE)
	start_charge(GameData.power_stations[GameData.bobot_last_power_station])

func add_memory(memory_id: GameData.Memory) -> void:
	#var casette_popup_timer: SceneTreeTimer = get_tree().create_timer(2).timeout.connect(close_casette_popup)
	casette_popup_timer = get_tree().create_timer(2.5)
	casette_popup_timer.timeout.connect(close_casette_popup)
	
	casette_popup.visible = true
	casette_popup.set_casette_and_animate(memory_id)
	GameLogic.state = GameLogic.State.POPUP
	GameData.pending_memories.append(memory_id)

func close_casette_popup() -> void:
	casette_popup.visible = false
	GameLogic.state = GameLogic.State.EXPLORING

func start_charge(power_station: PowerStation) -> void:
	global_position = power_station.global_position
	velocity = Vector2.ZERO
	movement_component.motion_input = Vector2.ZERO
	idle_timer.start(2)
	
	GameData.bobot_last_power_station = power_station.power_station_id
	animated_sprite.animation = "stand_down"
	
	GameLogic.change_state(GameLogic.State.CHARGING)
	
	# move memories from pending to acquired
	for memory: GameData.Memory in GameData.pending_memories:
		GameData.acquired_memories.append(memory)
	GameData.acquired_memories.sort()
	GameData.pending_memories = []
	
	# show memory ui if has memories
	if GameData.acquired_memories.size() > 0:
		memory_ui.visible = true
		memory_ui.update_display()

func stop_charge() -> void:
	memory_ui.visible = false
	GameLogic.change_state(GameLogic.State.EXPLORING)

func charge_out() -> void:
	#kill()
	animated_sprite.animation = "death"
	animated_sprite.frame = 0
	
	SoundManager.play_sound((SRM as SoundResourceManager).get_sound("sfx_bobot_die")).volume_db = -8
	
	GameLogic.change_state(GameLogic.State.POPUP)
	get_tree().create_timer(3).timeout.connect(kill)

func kill() -> void:
	GameData.pending_memories = []
	GameData.bobot_charge = GameData.bobot_max_charge
	GameLogic.reload_scene()

func start_memory(memory_id: GameData.Memory) -> void:
	SoundManager.play_sound((SRM as SoundResourceManager).get_sound("sfx_casette_play")).volume_db = -8
	GameLogic.change_state(GameLogic.State.REMBERING)
	get_tree().create_timer(2).timeout.connect(switch_to_memory.bind(memory_id))

func switch_to_memory(memory_id: GameData.Memory) -> void:
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
	
	charge_label.text = "[font_size=32]Charge: " + str(snappedf(GameData.bobot_charge, 0.1))
	charge_label.text += "\n"
	charge_label.text += "Pending Memories: " + str(GameData.pending_memories)
	charge_label.text += "\n"
	charge_label.text += "Acquired Memories: " + str(GameData.acquired_memories)

func _handle_movement_input() -> void:
	var x_direction: float = Input.get_axis("move_left_key", "move_right_key")
	var y_direction: float = Input.get_axis("move_down_key", "move_up_key")
	var movement_input: Vector2 = Vector2(x_direction, y_direction)
	
	if GameLogic.state != GameLogic.State.EXPLORING:
		movement_input = Vector2.ZERO
	
	if movement_input.length() > 0:
		movement_input = movement_input.normalized()
		
		if Input.is_action_pressed("sprint_key"):
			movement_input *= 2
		
		
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
		idle_timer.start(4)
		
	
	elif movement_component:
		movement_component.motion_input = Vector2.ZERO
		
		if animated_sprite.animation.contains("walk_"):
			var animation_suffix: String = animated_sprite.animation.split("_")[1]
			animated_sprite.animation = "stand_" + animation_suffix

func _unhandled_input(event: InputEvent) -> void:
	match GameLogic.state:
		GameLogic.State.EXPLORING:
			if event.is_action_pressed("interact_key"):
				if proximity_interactor_component.current_selection and proximity_interactor_component.current_selection.selected:
					proximity_interactor_component.current_selection.interact()
		
		GameLogic.State.CHARGING:
			if event.is_action_pressed("escape_key"):
				stop_charge()
		
		GameLogic.State.POPUP:
			if event.is_action_pressed("escape_key"):
				casette_popup_timer.timeout.emit()
				casette_popup_timer = null


func _on_idle_timer_timeout() -> void:
	match GameLogic.state:
		GameLogic.State.EXPLORING, GameLogic.State.CHARGING:
			animated_sprite.animation = "eepy"
			if eepy_tween:
				eepy_tween.kill()
			eepy_tween = get_tree().create_tween()
			eepy_tween.tween_property(animated_sprite, "scale", Vector2(0.3, 0.25), 0.15)
			eepy_tween.tween_property(animated_sprite, "scale", Vector2(0.3, 0.3), 0.15)
		_:
			idle_timer.start(1)
