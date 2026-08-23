class_name MemoryUI extends Control

@onready var document_container: VBoxContainer = get_node("HBoxContainer/LoreContainer")
@onready var casette_container: VBoxContainer = get_node("HBoxContainer/CasetteContainer")
@onready var close_button: Button = get_node("Control/CloseButton")

@onready var document_view_control: Control = get_node("DocumentView")
@onready var document_texture: TextureRect = get_node("DocumentView/MarginContainer/DocumentTexture")

var bobot: Bobot

func _ready() -> void:
	for casette_option: CasetteOption in get_memory_casettes():
		casette_option.selected.connect(memory_selected)
	
	for document_option: DocumentOption in get_documents():
		document_option.selected.connect(view_document)
	
	bobot = get_tree().get_first_node_in_group("bobot")

func get_memory_casettes() -> Array[CasetteOption]:
	var casette_container_children: Array[Node] = casette_container.get_children()
	var casette_options: Array[CasetteOption]
	for casette_container_child: Node in casette_container_children:
		if casette_container_child is CasetteOption:
			casette_options.append(casette_container_child as CasetteOption)
	
	return casette_options

func get_documents() -> Array[DocumentOption]:
	var casette_container_children: Array[Node] = document_container.get_children()
	var casette_options: Array[DocumentOption]
	for casette_container_child: Node in casette_container_children:
		if casette_container_child is DocumentOption:
			casette_options.append(casette_container_child as DocumentOption)
	
	return casette_options

func update_display() -> void:
	update_casette_display()
	update_document_display()

func update_casette_display() -> void:
	var casette_options: Array[CasetteOption] = get_memory_casettes()
	
	var casette_option_index: int = 0
	for casette_option: CasetteOption in casette_options:
		var display_order: Array[GameData.Memory] = [GameData.Memory.GREENHOUSE, GameData.Memory.STORAGE_AREA, GameData.Memory.LAB, GameData.Memory.ALICE_QUARTERS]
		var actual_memory: int = display_order[casette_option_index]
		#if GameData.acquired_memories.size() > casette_option_index:
		if GameData.acquired_memories.has(actual_memory):
			casette_option.update_display(actual_memory)
			casette_option.visible = true
			
			# give casette focus if was selected previously
			if GameData.casette_is_selected and GameData.selected_casette == display_order[casette_option_index]:
				casette_option.button.grab_focus()
		else:
			casette_option.show_blank()
		casette_option_index += 1
	
	if not GameData.casette_is_selected:
		close_button.grab_focus()

func update_document_display() -> void:
	var casette_options: Array[DocumentOption] = get_documents()
	
	var casette_option_index: int = 0
	for casette_option: DocumentOption in casette_options:
		#var display_order: Array[GameData.Memory] = [GameData.Memory.GREENHOUSE, GameData.Memory.STORAGE_AREA, GameData.Memory.LAB, GameData.Memory.ALICE_QUARTERS]
		#var actual_memory: int = display_order[casette_option_index]
		#if GameData.acquired_memories.size() > casette_option_index:
		if GameData.acquired_documents.has(casette_option_index):
			casette_option.update_display(casette_option_index)
			casette_option.visible = true
			
			# give casette focus if was selected previously
			#if GameData.casette_is_selected and GameData.selected_casette == display_order[casette_option_index]:
			#	casette_option.button.grab_focus()
		else:
			casette_option.show_blank()
		casette_option_index += 1
	
	if not GameData.casette_is_selected:
		close_button.grab_focus()

func hide_display() -> void:
	#print("hide display")
	get_viewport().gui_release_focus()
	GameData.casette_is_selected = false
	visible = false

func memory_selected(memory_id: GameData.Memory) -> void:
	if not GameData.actual_progress["powered_box"]:
		GameData.selected_casette = memory_id
		GameData.casette_is_selected = true
		bobot.start_memory(memory_id)


func _on_close_button_button_down() -> void:
	get_viewport().set_input_as_handled()
	bobot.stop_charge()

func view_document(document_id: GameData.Document) -> void:
	document_view_control.visible = true
	document_texture.texture = GameData.document_sprites[document_id]

func stop_view_document() -> void:
	document_view_control.visible = false

func _on_close_document_button_button_down() -> void:
	stop_view_document()
