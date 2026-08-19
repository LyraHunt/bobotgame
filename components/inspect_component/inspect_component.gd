class_name InspectComponent extends Node2D

@export var proximity_interaction_component: ProximityInteractionComponent
@export var flavor_text_id: String

@onready var icon: Sprite2D = get_node("Sprite2D")

func _ready() -> void:
	update_display(false)
	
	if proximity_interaction_component:
		proximity_interaction_component.selection_update.connect(update_display)
		proximity_interaction_component.interacted.connect(show_flavor_text)

func update_display(selected: bool) -> void:
	icon.visible = selected

func show_flavor_text() -> void:
	print(flavor_text_id)
	if GameLogic.state == GameLogic.State.EXPLORING:
		GameLogic.state = GameLogic.State.FLAVOR
		
		if Dialogic.current_timeline != null:
			return
		Dialogic.start(GameData.flavor_texts[flavor_text_id])
		
		await Dialogic.timeline_ended
		GameLogic.state = GameLogic.State.EXPLORING
