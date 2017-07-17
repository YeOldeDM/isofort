extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	if has_node( "WindowSpace" ):
		connect( "mouse_enter", self, "_set_in_menu", [true] )
		connect( "mouse_exit", self, "_set_in_menu", [false] )


func _set_in_menu( what ):
	Globals.in_menu = what
	print(what)