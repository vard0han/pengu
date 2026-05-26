extends Node

const SFX_PATH: String = "res://assets/audio/sfx/"
const MUSIC_PATH: String = "res://assets/audio/music/"

const MAX_SFX_PLAYERS: int = 16

var _sfx_players: Array[AudioStreamPlayer] = []
var _music_player: AudioStreamPlayer = null
var _sfx_cache: Dictionary = {}
var _current_music_path: String = ""

var _looped_players: Dictionary = {}

const SETTINGS_PATH: String = "user://settings.cfg"
const DEFAULT_MUSIC_VOLUME: float = 0.8
const DEFAULT_SFX_VOLUME: float = 0.8

var music_volume: float = DEFAULT_MUSIC_VOLUME
var sfx_volume: float = DEFAULT_SFX_VOLUME

func _ready() -> void:
	_load_settings()
	_apply_volumes()
	
	for i : int in range(MAX_SFX_PLAYERS):
		var player : AudioStreamPlayer = AudioStreamPlayer.new()
		player.bus = "SFX"
		add_child(player)
		_sfx_players.append(player)
	
	_music_player = AudioStreamPlayer.new()
	_music_player.bus = "Music"
	add_child(_music_player)

func play_sfx(sound_name: String, volume_db: float = 0.0, pitch_scale: float = 1.0) -> void:
	var stream: AudioStream = _get_sfx_stream(sound_name)
	if stream == null:
		return
	
	var player: AudioStreamPlayer = _get_free_sfx_player()
	if player == null:
		return
	
	player.stream = stream
	player.volume_db = volume_db
	player.pitch_scale = pitch_scale
	player.play()

func play_music(music_name: String, fade_in_duration: float = 0.0) -> void:
	var path: String = MUSIC_PATH + music_name + ".mp3"
	
	if _current_music_path == path and _music_player.playing:
		return
	
	if not ResourceLoader.exists(path):
		push_warning("Music file not found: " + path)
		return
	
	_current_music_path = path
	_music_player.stream = load(path)
	_music_player.play()
	
	if fade_in_duration > 0.0:
		_fade_in_music(fade_in_duration)

func stop_music(fade_out_duration: float = 0.0) -> void:
	if fade_out_duration > 0.0:
		_fade_out_music(fade_out_duration)
	else:
		_music_player.stop()
	
	_current_music_path = ""

func _get_sfx_stream(sound_name: String) -> AudioStream:
	if sound_name in _sfx_cache:
		return _sfx_cache[sound_name]
	
	var wav_path: String = SFX_PATH + sound_name + ".wav"
	var ogg_path: String = SFX_PATH + sound_name + ".ogg"
	var mp3_path: String = SFX_PATH + sound_name + ".mp3"
	
	var stream: AudioStream = null
	
	if ResourceLoader.exists(wav_path):
		stream = load(wav_path)
	elif ResourceLoader.exists(ogg_path):
		stream = load(ogg_path)
	elif ResourceLoader.exists(mp3_path):
		stream = load(mp3_path)
	else: 
		push_warning("SFX not found: " + sound_name)
	
	_sfx_cache[sound_name] = stream
	return stream

func _get_free_sfx_player() -> AudioStreamPlayer:
	for player: AudioStreamPlayer in _sfx_players:
		if not player.playing:
			return player
	return _sfx_players[0]

func _fade_in_music(duration: float) -> void:
	_music_player.volume_db = -60.0
	var tween: Tween = create_tween()
	tween.tween_property(_music_player, "volume_db", 0.0, duration)

func _fade_out_music(duration: float) -> void:
	var tween: Tween = create_tween()
	tween.tween_property(_music_player, "volume_db", -60.0, duration)
	tween.tween_callback(_music_player.stop)

func play_sfx_looped(sound_name: String, volume_db: float = -12.0, pitch_scale: float = 1.0) -> void:
	if sound_name in _looped_players and _looped_players[sound_name].playing:
		return  # already playing
	
	var stream: AudioStream = _get_sfx_stream(sound_name)
	if stream == null:
		return
	
	var player: AudioStreamPlayer
	if sound_name in _looped_players:
		player = _looped_players[sound_name]
	else:
		player = AudioStreamPlayer.new()
		player.bus = "SFX"
		add_child(player)
		_looped_players[sound_name] = player
	
	player.stream = stream
	player.volume_db = volume_db
	player.pitch_scale = pitch_scale
	player.play()

func stop_sfx_looped(sound_name: String) -> void:
	if sound_name in _looped_players:
		_looped_players[sound_name].stop()

func set_music_volume(value: float) -> void:
	music_volume = clampf(value, 0.0, 1.0)
	_apply_volumes()
	_save_settings()

func set_sfx_volume(value: float) -> void:
	sfx_volume = clampf(value, 0.0, 1.0)
	_apply_volumes()
	_save_settings()

func _apply_volumes() -> void:
	var music_bus: int = AudioServer.get_bus_index("Music")
	var sfx_bus: int = AudioServer.get_bus_index("SFX")
	
	AudioServer.set_bus_volume_db(music_bus, linear_to_db(music_volume))
	AudioServer.set_bus_volume_db(sfx_bus, linear_to_db(sfx_volume))

func _load_settings() -> void:
	var config : ConfigFile = ConfigFile.new()
	var err: Error = config.load(SETTINGS_PATH)
	if err != OK:
		return
	music_volume = config.get_value("audio", "music_volume", DEFAULT_MUSIC_VOLUME)
	sfx_volume = config.get_value("audio", "sfx_volume", DEFAULT_SFX_VOLUME)

func _save_settings() -> void:
	var config : ConfigFile = ConfigFile.new()
	config.set_value("audio", "music_volume", music_volume)
	config.set_value("audio", "sfx_volume", sfx_volume)
	config.save(SETTINGS_PATH)
