class_name Bobot extends CharacterBody2D

@onready var movement_component: MovementComponent = get_node("MovementComponent")
@onready var proximity_interactor_component: ProximityInteractorComponent = get_node("ProximityInteractorComponent")
@onready var sprite: Sprite2D = get_node("Sprite2D")
@onready var charge_label: RichTextLabel = get_node("CanvasLayer/RichTextLabel")
@onready var idle_timer: Timer = get_node("IdleTimer")

@export var sprites: Dictionary[String, Texture2D] = {
	"forward": null,
	"right": null,
	"backward": null,
	"left": null,
	"blink": null
}

var charge: float = 5.0
var max_charge: float = 10.0
var charge_per_sec: float = 5.0

func _ready() -> void:
	#start_charge(GameData.power_stations[GameData.bobot_last_power_station])
	GameLogic.power_stations_initialized.connect(_start_charge_on_load)

func _start_charge_on_load() -> void:
	start_charge(GameData.power_stations[GameData.bobot_last_power_station])

func add_memory(memory_id: GameData.Memory) -> void:
	GameData.pending_memories.append(memory_id)

func start_charge(power_station: PowerStation) -> void:
	global_position = power_station.global_position
	velocity = Vector2.ZERO
	movement_component.motion_input = Vector2.ZERO
	
	sprite.texture = sprites.forward
	
	GameData.bobot_last_power_station = power_station.power_station_id
	
	if GameData.pending_memories.size() > 0:
		start_memory(GameData.pending_memories[0])
	else:
		GameLogic.change_state(GameLogic.State.CHARGING)

func stop_charge() -> void:
	GameLogic.change_state(GameLogic.State.EXPLORING)

func charge_out() -> void:
	kill()

func kill() -> void:
	start_charge(GameData.power_stations[GameData.bobot_last_power_station])

func start_memory(memory_id: GameData.Memory) -> void:
	GameLogic.change_state(GameLogic.State.REMBERING)
	GameLogic.current_memory = memory_id
	GameData.pending_memories.remove_at(0)
	GameData.power_stations = {}
	
	GameLogic.change_scene(GameData.memory_controller_scene)

func _physics_process(_delta: float) -> void:
	match GameLogic.state:
		GameLogic.State.EXPLORING:
			_handle_movement_input()
		
	move_and_slide()

func _process(_delta: float) -> void:
	match GameLogic.state:
		GameLogic.State.EXPLORING:
			charge -= _delta
			if charge <= 0:
				charge_out()
		GameLogic.State.CHARGING:
			charge += _delta * charge_per_sec
			charge = min(charge, max_charge)
	
	charge_label.text = "[font_size=32]Charge: " + str(snappedf(charge, 0.1))
	charge_label.text += "\n"
	charge_label.text += "Pending Memories: " + str(GameData.pending_memories)
	charge_label.text += "\n"
	charge_label.text += "Acquired Memories: " + str(GameData.acquired_memories)

func _handle_movement_input() -> void:
	var x_direction: float = Input.get_axis("move_left_key", "move_right_key")
	var y_direction: float = Input.get_axis("move_down_key", "move_up_key")
	var movement_input: Vector2 = Vector2(x_direction, y_direction)
	
	if movement_input.length() > 0:
		movement_input = movement_input.normalized()
		if movement_component:
			movement_component.motion_input = movement_input
		
		if y_direction > 0:
			sprite.texture = sprites.backward
		elif y_direction < 0:
			sprite.texture = sprites.forward
		elif x_direction > 0:
			sprite.texture = sprites.right
		elif x_direction < 0:
			sprite.texture = sprites.left
		
		idle_timer.start()
		
	
	elif movement_component:
		movement_component.motion_input = Vector2.ZERO

func _unhandled_input(event: InputEvent) -> void:
	match GameLogic.state:
		GameLogic.State.EXPLORING:
			if event.is_action_pressed("interact_key"):
				if proximity_interactor_component.current_selection and proximity_interactor_component.current_selection.selected:
					proximity_interactor_component.current_selection.interact()
		
		GameLogic.State.CHARGING:
			if event.is_action_pressed("escape_key"):
				stop_charge()


func _on_idle_timer_timeout() -> void:
	sprite.texture = sprites.blink
