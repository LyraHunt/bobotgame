class_name ProximityInteractorComponent extends Area2D

@export var target_character_body: CharacterBody2D

var _queue_proximity_array: bool = false
var interactions_array: Array[ProximityInteractionComponent] = []
var current_selection: ProximityInteractionComponent

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	#chunk_manager = get_tree().get_first_node_in_group("chunk_manager") as ChunkManager
	#chunk_manager.connect("world_updated", queue_proximity_check)

# Called every physics frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	if target_character_body and target_character_body.velocity.length() > 0:
		queue_proximity_check()
	
	if _queue_proximity_array:
		_update_proximity_interaction_array()

func queue_proximity_check() -> void:
	_queue_proximity_array = true

func _update_proximity_interaction_array() -> void:
	_queue_proximity_array = false
	
	# find all nearby areas to interact with
	interactions_array = []
	for area:Area2D in get_overlapping_areas():
		if area is ProximityInteractionComponent:
			interactions_array.push_back(area)
		#if area is ProximityPickupComponent:
		#	(area as ProximityPickupComponent).pick_up()
	
	if interactions_array.size() > 0:
		# find closest
		var closest_dist: float = 1000
		var closest_proximity_interaction_component: ProximityInteractionComponent
		for proximity_interaction_component:ProximityInteractionComponent in interactions_array:
			var current_dist: float = global_position.distance_to(proximity_interaction_component.global_position)
			if current_dist < closest_dist:
				closest_dist = current_dist
				closest_proximity_interaction_component = proximity_interaction_component
		
		# change selection
		var is_new_selection: bool
		if current_selection:
			is_new_selection = (closest_proximity_interaction_component != current_selection) or (not current_selection.selected)
		else:
			is_new_selection = true
		
		if is_new_selection:
			if current_selection:
				current_selection.deselect()
			closest_proximity_interaction_component.select()
			current_selection = closest_proximity_interaction_component
	
	elif current_selection and current_selection.selected:
		current_selection.deselect()
