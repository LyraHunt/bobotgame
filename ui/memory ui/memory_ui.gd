class_name MemoryUI extends Control

@onready var lore_container: VBoxContainer = get_node("HBoxContainer/LoreContainer")
@onready var casette_container: VBoxContainer = get_node("HBoxContainer/CasetteContainer")
@onready var close_button: Button = get_node("Control/CloseButton")

var bobot: Bobot

func _ready() -> void:
	for casette_option: CasetteOption in get_memory_casettes():
		casette_option.selected.connect(memory_selected)
	
	bobot = get_tree().get_first_node_in_group("bobot")

func get_memory_casettes() -> Array[CasetteOption]:
	var casette_container_children: Array[Node] = casette_container.get_children()
	var casette_options: Array[CasetteOption]
	for casette_container_child: Node in casette_container_children:
		if casette_container_child is CasetteOption:
			casette_options.append(casette_container_child as CasetteOption)
	
	return casette_options

func update_display() -> void:
	var casette_options: Array[CasetteOption] = get_memory_casettes()
	
	var casette_option_index: int = 0
	for casette_option: CasetteOption in casette_options:
		if GameData.acquired_memories.size() > casette_option_index:
			casette_option.update_display(GameData.acquired_memories[casette_option_index])
			casette_option.visible = true
			
			# give casette focus if was selected previously
			if GameData.casette_is_selected and GameData.selected_casette == GameData.acquired_memories[casette_option_index]:
				casette_option.button.grab_focus()
		else:
			casette_option.show_blank()
		casette_option_index += 1
	
	if not GameData.casette_is_selected:
		close_button.grab_focus()

func hide_display() -> void:
	get_viewport().gui_release_focus()
	visible = false

func memory_selected(memory_id: GameData.Memory) -> void:
	GameData.selected_casette = memory_id
	GameData.casette_is_selected = true
	bobot.start_memory(memory_id)


func _on_close_button_button_down() -> void:
	get_viewport().set_input_as_handled()
	print("close")
	GameData.casette_is_selected = false
	bobot.stop_charge()
