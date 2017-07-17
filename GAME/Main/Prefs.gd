extends PopupPanel

signal preference_set( pref, value )

const PREFS_NAME = "prefs.cfg"

onready var config = ConfigFile.new()
onready var world = get_node("../../../")

onready var video_tab = get_node("box/Tabs/Video")

onready var bloom_enable = video_tab.get_node("BloomEnable")
onready var bloom_strength = video_tab.get_node("BloomStrength/Items")

onready var fxaa_enable = video_tab.get_node("FXAAEnable")

onready var video_mode = video_tab.get_node("VideoMode/Items")


var _cfg_path

func apply_prefs():
	config.set_value( "video", "bloom_enable", bloom_enable.is_pressed() )
	world.fx.set_bloom_enable( bloom_enable.is_pressed() )
	config.set_value( "video", "bloom_strength", bloom_strength.get_selected() )
	world.fx.set_bloom_mode( bloom_strength.get_selected() )
	config.set_value( "video", "fxaa_enable", fxaa_enable.is_pressed() )
	world.fx.set_fxaa_enable( fxaa_enable.is_pressed() )
	config.set_value( "video", "mode", video_mode.get_selected() )
	world.fx.set_video_mode( video_mode.get_selected() )
	
	config.save( _cfg_path )


func _init_config():
	config.set_value("video", "bloom_enable", true)
	config.set_value("video", "bloom_strength", 0)
	config.set_value("video", "mode", 0)
	config.set_value("video", "fxaa_enable", false)
	
	config.save(_cfg_path)
	print( "NEW WORLD PREFS CREATED" )
	
func _ready():
	_cfg_path = Data.get_open_world_path() + "/" + PREFS_NAME
	var file = File.new()
	if !file.file_exists( _cfg_path ):
		print("NO PREFS FOUND AT " + _cfg_path )
		_init_config()
	config.load( _cfg_path )
	print("LOADED PREFS")


func _on_Cancel_pressed():
	hide()


func _on_Prefs_about_to_show():
	bloom_enable.set_pressed( config.get_value("video","bloom_enable") )
	bloom_strength.select( config.get_value("video","bloom_strength") )
	fxaa_enable.set_pressed( config.get_value("video","fxaa_enable") )
	video_mode.select( config.get_value("video","mode") )





func _on_Apply_pressed():
	apply_prefs()



func _on_OK_pressed():
	apply_prefs()
	hide()
