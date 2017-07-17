extends WorldEnvironment

const VIDEO_MODE_WINDOWED = 0
const VIDEO_MODE_BORDERLESS = 1
const VIDEO_MODE_FULLSCREEN = 2

onready var env = get_environment()


func set_bloom_enable( what=true ):
	env.fx_set_param( env.FX_PARAM_GLOW_BLOOM, what )

func get_bloom_enable():
	return env.fx_get_param( env.FX_PARAM_GLOW_BLOOM )

func set_bloom_mode( what ):
	what = clamp( what, 0, 2 )
	env.fx_set_param( env.FX_PARAM_GLOW_BLUR_BLEND_MODE, 2 - what )

func get_bloom_mode():
	return env.fx_get_param( env.FX_PARAM_GLOW_BLUR_BLEND_MODE )

func set_fxaa_enable( what=false ):
	env.fx_set_param( env.FX_FXAA, what )

func get_fxaa_enable():
	return env.fx_set_param( env.FX_FXAA )

func set_video_mode( what=0 ):
	if what == VIDEO_MODE_WINDOWED:
		OS.set_window_fullscreen( false )
		OS.set_borderless_window( false )
	elif what == VIDEO_MODE_BORDERLESS:
		OS.set_window_fullscreen( false )
		OS.set_borderless_window( true )
	elif what == VIDEO_MODE_FULLSCREEN:
		OS.set_window_fullscreen( true )
		OS.set_borderless_window( false )

func get_video_mode():
	if OS.is_window_fullscreen():
		return VIDEO_MODE_FULLSCREEN
	elif !OS.is_window_resizable():
		return VIDEO_MODE_BORDERLESS
	else:
		return VIDEO_MODE_WINDOWED