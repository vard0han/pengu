class_name GameManager
extends Node

signal level_loaded

@onready var main: Main = get_parent()

var current_level_instance: Node2D = null
var pending_level_path: String = ""
var weapon_select_instance: WeaponSelect = null

func _ready() -> void:
	call_deferred("load_level", "res://scenes/world/levels/level_01.tscn")
	call_deferred("show_weapon_select", "res://scenes/world/levels/level_01.tscn")

func load_level(path: String) -> void:
	# free existing level
	if current_level_instance:
		current_level_instance.queue_free()
		current_level_instance = null
	
	# instance new level
	var level_scene: PackedScene = load(path)
	if not level_scene:
		push_error("Failed to load level: " + path)
		return
	
	current_level_instance = level_scene.instantiate()
	main.current_level.add_child(current_level_instance)
	
	var spawn_marker: Marker2D = current_level_instance.get_node_or_null("PlayerSpawn")
	
	if spawn_marker:
		main.player.global_position = spawn_marker.global_position
	else:
		push_warning("Level has no PlayerSpawn market - player position unchanged")
	
	call_deferred("_emit_level_loaded")

func _emit_level_loaded() -> void:
	level_loaded.emit()

func get_projectiles_container() -> Node:
	if current_level_instance:
		return current_level_instance.get_node_or_null("Projectiles")
	return null

func get_pickups_container() -> Node:
	if current_level_instance:
		return current_level_instance.get_node_or_null("Pickups")
	return null

func show_weapon_select(level_path: String) -> void:
	pending_level_path = level_path
	
	# hide player during selection so it's not visibly floating
	main.player.visible = false
	main.hud.visible = false
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	var weapon_select_scene: PackedScene = load("res://scenes/ui/weapon_select.tscn")
	weapon_select_instance = weapon_select_scene.instantiate()
	main.hud_layer.add_child(weapon_select_instance)
	
	weapon_select_instance.weapon_selected.connect(_on_weapon_selected)

func _on_weapon_selected(weapon: WeaponData) -> void:
	main.player.weapon.set_weapon(weapon)
	
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	
	weapon_select_instance.queue_free()
	weapon_select_instance = null
	
	main.player.visible = true
	main.hud.visible = true
	
	load_level(pending_level_path)
