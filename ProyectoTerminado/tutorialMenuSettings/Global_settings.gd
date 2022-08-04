extends Node

signal fps_displayed(value)
signal brightness_updated(value)
signal fov_updated(value)
signal mouse_sens_updated(value)
#VIDEO
func change_displayMode(toggle):
	OS.window_fullscreen = toggle
	Save.game_data.full_screen_on =toggle
	Save.save_data()

func change_vsync(toggle):
	OS.vsync_enabled = toggle
	Save.game_data.vsync_on = toggle
	Save.save_data()

func toggle_fps_display(toggle):
	emit_signal("fps_displayed",toggle)

	Save.game_data.display_fps = toggle
	Save.save_data()

func set_max_fps(value):
	print(value)
	Engine.target_fps = value if value <500 else 0
	Save.game_data.max_fps = Engine.target_fps if value <500 else 500
	Save.save_data()

func update_brightness(value):
	emit_signal("brightness_updated",value)
	Save.game_data.brightness = value
	Save.save_data()

#AUDIO
func update_master_vol(bus_idx, vol): #-50 min slider
	AudioServer.set_bus_volume_db(bus_idx,vol if vol > -50 else AudioServer.set_bus_mute(bus_idx,true))
	match bus_idx:
		0:
			Save.game_data.master_vol = vol
			Save.save_data()
		1:
			Save.game_data.music_vol = vol
			Save.save_data()
		2:
			Save.game_data.sfx_vol = vol
			Save.save_data()

func update_fov(value):
	emit_signal("fov_updated",value)
	Save.game_data.fov = value
	Save.save_data()

func update_mouse_sens(value):
	emit_signal("mouse_sens_updated",value)
	Save.game_data.mouse_sens = value
	Save.save_data()
