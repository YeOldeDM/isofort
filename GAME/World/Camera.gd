extends Position2D

onready var camera = get_node("Camera")


var mo = Vector2()

var zoom = 2 setget _set_zoom


func _ready():
	pass


func _process(delta):
	var DRAG = Input.is_mouse_button_pressed(BUTTON_MIDDLE)
	
	var new_pos = get_pos()

	new_pos -= ( get_viewport().get_mouse_pos() - mo ) * DRAG * camera.get_zoom()
	
	if new_pos != get_pos():
		set_pos( new_pos )
	
	mo = get_viewport().get_mouse_pos()

	
	# HACK Save game
	if Input.is_action_pressed("ui_accept"):
		Data.save_world( get_parent().save_map() )


func _set_zoom( what ):
	zoom = what
	var z = [0.5,1.0,2.0,3.0][zoom]
	camera.set_zoom(Vector2(z,z))


func _on_Zoom_set_zoom( to ):
	self.zoom = to


func _on_World_map_ready():
	set_process(true)
