class_name MemoryUI extends Control

@onready var lore_container: VBoxContainer = get_node("HBoxContainer/LoreContainer")
@onready var casette_container: VBoxContainer = get_node("HBoxContainer/CasetteContainer")

var bobot: Bobot

func _ready() -> void:
	for casette_option: CasetteOption in get_memory_casettes():
		casette_option.selected.connect(memory_selected)
	
	update_display()
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
		else:
			casette_option.visible = false
		casette_option_index += 1

func memory_selected(memory_id: GameData.Memory) -> void:
	bobot.start_memory(memory_id)
