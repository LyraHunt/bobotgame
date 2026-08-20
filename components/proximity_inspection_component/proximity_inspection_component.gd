class_name ProximityInspectionComponent extends ProximityInteractionComponent

@export var flavor_text_id: String

@onready var icon: Sprite2D = get_node("Sprite2D")

@export var find_sprite_under_parent: bool = true

var bobot: Bobot

func _ready() -> void:
	bobot = get_tree().get_first_node_in_group("bobot")
	icon.visible = false
	outline_sprite = true
	update_display(false)
	
	selection_update.connect(update_display)
	interacted.connect(show_flavor_text)
	
	if find_sprite_under_parent:
		var available_sprites: Array[Node] = GameLogic.get_children_of_type(get_parent(), "Sprite2D")
		if available_sprites.size() > 0:
			sprite = available_sprites[0]

func update_display(was_selected: bool) -> void:
	if was_selected:
		bobot.track_eye_icon(icon)
	else:
		bobot.node_for_icon_tracking = null

func show_flavor_text() -> void:
	print(flavor_text_id)
	if GameLogic.state == GameLogic.State.EXPLORING:
		GameLogic.state = GameLogic.State.FLAVOR
		
		if Dialogic.current_timeline != null:
			return
		#Dialogic.start(GameData.flavor_texts[flavor_text_id])
		GameData.play_flavor_timeline(flavor_text_id)
		
		await Dialogic.timeline_ended
		GameLogic.state = GameLogic.State.EXPLORING
