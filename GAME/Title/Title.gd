extends Control

signal menu_selected( what )

onready var main = get_node("/root/Main")


func end():
	return OK


func _ready():
	connect("menu_selected", get_parent(), "_on_menu_selected")
	print("TITLE")



func _on_New_pressed():
	emit_signal("menu_selected", main.MAIN_ACTION.NEW_WORLD)


func _on_Load_pressed():
	emit_signal("menu_selected", main.MAIN_ACTION.LOAD_WORLD)


func _on_Quit_pressed():
	emit_signal("menu_selected", main.MAIN_ACTION.QUIT)


func _on_Continue_pressed():
	pass
