class_name AudioSliders
extends VBoxContainer

@onready var _music_slider: HSlider = %MusicSlider 
@onready var _sfx_slider: HSlider = %SFXSlider

func _ready() -> void:
	_music_slider.value = AudioManager.music_volume
	_sfx_slider.value = AudioManager.sfx_volume
	
	_music_slider.value_changed.connect(_on_music_changed)
	_sfx_slider.value_changed.connect(_on_sfx_changed)

func _on_music_changed(value: float) -> void:
	AudioManager.set_music_volume(value)

func _on_sfx_changed(value: float) -> void:
	AudioManager.set_sfx_volume(value)
