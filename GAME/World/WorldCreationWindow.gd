extends PanelContainer

signal menu_selected( what )

signal generate_map( data )

onready var params = get_node("box/Params")

onready var seed_box = params.get_node("Seed/box")
onready var size_box = params.get_node("Size/box")
onready var depth_box = params.get_node("Depth/box")
onready var name_box = params.get_node("Name/box")

onready var seed_input = seed_box.get_node("box/Input")

onready var size_x_input = size_box.get_node("box/Xinput")
onready var size_y_input = size_box.get_node("box/Yinput")

onready var depth_h_input = depth_box.get_node("box/Hinput")
onready var depth_d_input = depth_box.get_node("box/Dinput")
onready var depth_dirt_input = depth_box.get_node("box/DirtInput")

onready var name_input = name_box.get_node("box/NameInput")
onready var name_rnd_button = name_box.get_node("box/Rnd")

func _ready():
	name_input.set_text( NameGen.GetName() )
	seed_input.set_value( randi() % 16777216 )
	
	connect( "menu_selected", get_parent(), "_on_menu_selected" )
	connect( "generate_map", get_parent(), "_on_generate_map" )


func _on_SeedRnd_pressed():
	seed_input.set_value( randi() % 16777216 )


func _on_NameRnd_pressed():
	name_input.set_text( NameGen.GetName() )


func _on_Back_pressed():
	emit_signal("menu_selected", get_parent().MAIN_ACTION.EXIT)


func _on_Generate_pressed():
	var z = int( depth_h_input.get_value() ) + int( depth_d_input.get_value() )
	var data = {
		"name":	name_input.get_text(),
		"bounds":	Vector3(
			int( size_x_input.get_value() ),
			int( size_y_input.get_value() ),
			z),
		"zero":	z - int( depth_h_input.get_value() ),
		"dirt":	int( depth_dirt_input.get_value() ),
		}
	emit_signal("generate_map", data)








