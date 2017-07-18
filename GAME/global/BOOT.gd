extends Node

var VERSION = {
	"major":	0,
	"minor":	0,
	"baby":		1,
	}

const USER_CFG_PATH = "user://user.cfg"

onready var usr_cfg = ConfigFile.new()

func update_usr_cfg():
	assert usr_cfg.has_section("meta")
	if !usr.cfg.has_section_key("meta","epoch"):
		usr_cfg.set_value( "meta", "epoch", OS.get_unix_time() )
	usr_cfg.set_value("meta", "version", BOOT.VERSION)
	usr_cfg.save(USER_CFG_PATH)

func set_last_world_opened( name ):
	usr_cfg.set_value( "last_session", "world_opened", name )
	update_usr_cfg()

func get_last_world_opened():
	if usr_cfg.has_section_key("last_session", "world_opened"):
		return usr_cfg.get_value("last_session", "world_opened")

func _ready():
	print( "BOOT" )
	Globals.in_worldspace = false
	

	var D = Directory.new()
	D.open( "user://" )
	# Create worlds/ folder if non-existent..
	if not D.file_exists( "worlds" ):
		D.make_dir( "worlds" )

	# Open or Create global user config
	var opened = usr_cfg.load( USER_CFG_PATH )
	if opened == OK:
		print( "LOADED USER CFG" )
	else:
		var F = File.new()
		if !F.file_exists( USER_CFG_PATH ):
			# Make a new user.cfg
			
			update_usr_cfg()
			print( "NEW USER CFG CREATED" )
	
