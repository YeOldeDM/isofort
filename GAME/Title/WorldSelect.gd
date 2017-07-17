extends PanelContainer

signal menu_select( what )
signal restore_map( data )

onready var world_list = get_node("box/WorldList")

onready var world_data = Data.get_worlds()

func get_world_string():
	return world_list.get_item_text( world_list.get_selected_items()[0] )

func _ready():
	connect("menu_select", get_parent(), "_on_menu_select")
	connect("restore_map", get_parent(), "_on_restore_map")
	for world in world_data:
		world_list.add_item( world )


func _on_WorldList_item_activated( index ):
	emit_signal( "restore_map", Data.restore_world( get_world_string() ) )


func _on_Load_pressed():
	emit_signal( "restore_map", Data.restore_world( get_world_string() ) )


func _on_Back_pressed():
	get_parent().current_scene = get_parent().title_scene


func _on_Delete_pressed():
	pass # replace with function body


func _on_New_pressed():
	emit_signal( "menu_select", get_parent().MAIN_ACTION.NEW_WORLD )
