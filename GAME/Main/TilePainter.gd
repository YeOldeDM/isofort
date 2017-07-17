extends PanelContainer

onready var buttons = get_node("box/scroll/buttons")
onready var mode = get_node("box/Modes")


func make_buttons():
	buttons.clear()
	var world = get_node("../../../")
	for i in range( world.MATERIALS.size() ):
		buttons.add_button("["+str(i-1)+"] " + find_name(i-1))

func get_selected_mode():
	return mode.get_selected()

func get_selected_material():
	return buttons.get_selected() - 1

func find_name(idx):
	var world = get_node("../../../")
	for key in world.MATERIALS:
		if world.MATERIALS[key] == idx:
			return key

func _ready():
	call_deferred("make_buttons")


func _process(delta):
	if Input.is_mouse_button_pressed(BUTTON_LEFT) and Globals.in_worldspace:
		var world = get_node("../../../")
		var cpos = world.cursor.get_cursor_pos()
		var cell = Vector3( cpos.x, cpos.y, world.level )

		world.set_cell_data( get_selected_mode(), cell, get_selected_material() )



func _on_World_map_ready():
	set_process(true)
