extends Control

signal saving_world()
signal saved_world()

enum MAIN_ACTION {
	NEW_WORLD,
	LOAD_WORLD,
	SAVE_WORLD,
	EXIT,
	QUIT,
	}

var current_scene = null setget _set_current_scene
var scn

export(String, FILE, "*.tscn") var title_scene = null
export(String, FILE, "*.tscn") var newgame_scene = null
export(String, FILE, "*.tscn") var loadgame_scene = null
export(String, FILE, "*.tscn") var world_scene = null


func Quit():
	pre_exit()
	get_tree().quit()


func pre_exit():
	emit_signal("saving_world")
	print("SAVING")
	if self.current_scene == self.world_scene:
		Data.save_world( self.scn.save_map() )
		yield(Data, "world_saved")
	call_deferred("emit_signal","saved_world")
	print("SAVED")

func _notification( what ):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		pre_exit()
		Quit()


func _set_current_scene( what ):
	if what != current_scene:
		var end = OK
		if current_scene:
			if scn.has_method("end"):
				end = scn.end()
		
		if end == OK:
			if scn:
				scn.queue_free()
			scn = load( what ).instance()
			add_child( scn )
			move_child( scn, 0 )
	current_scene = what


func _ready():
	self.current_scene = self.title_scene


func _on_menu_selected( what ):
	
	# GOTO TITLESCENE
	if what == MAIN_ACTION.EXIT:
		pre_exit()
		self.current_scene = self.title_scene
	
	# GOTO NEW WORLD SCENE
	if what == MAIN_ACTION.NEW_WORLD:
		self.current_scene = self.newgame_scene
	
	# SAVE GAME
	if what == MAIN_ACTION.SAVE_WORLD:
		pre_exit() # seems icky?
	
	# GOTO LOAD WORLD SCENE
	if what == MAIN_ACTION.LOAD_WORLD:
		self.current_scene = self.loadgame_scene
	
	# QUIT GAME
	if what == MAIN_ACTION.QUIT:
		Quit()
	


func _on_generate_map( data ):
	self.current_scene = self.world_scene
	self.scn.new_map( data )

func _on_restore_map( data ):
	self.current_scene = self.world_scene
	self.scn.start_map( data )