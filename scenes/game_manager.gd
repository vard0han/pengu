class_name GameManager
extends Node

signal level_loaded

@onready var main: Main = get_parent()

var current_level_instance: Node2D = null
var pending_level_path: String = ""
var weapon_select_instance: WeaponSelect = null
var selected_weapon: WeaponData = null
var is_level_ready: bool = false

func load_level(path: String) -> void:
	await SceneTransition.fade_to_black(0.2)
	
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
	
	call_deferred("_emit_level_loaded")
	
	await SceneTransition.fade_from_black(0.3)
	is_level_ready = true

func reset_current_level() -> void:
	if pending_level_path == "":
		push_warning("Cannot reset: no level path stored")
		return
	
	load_level(pending_level_path)

func reset_current_level_weapon() -> void:
	if pending_level_path == "":
		push_warning("Cannot reset: no level path stored")
		return
	
	show_weapon_select(pending_level_path)

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
	
	if current_level_instance:
		current_level_instance.queue_free()
		current_level_instance = null
	
	main.hud.visible = false
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	var weapon_select_scene: PackedScene = load("res://scenes/ui/weapon_select.tscn")
	weapon_select_instance = weapon_select_scene.instantiate()
	main.hud_layer.add_child(weapon_select_instance)
	
	weapon_select_instance.weapon_selected.connect(_on_weapon_selected)

func _on_weapon_selected(weapon: WeaponData) -> void:
	selected_weapon = weapon
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	
	weapon_select_instance.queue_free()
	weapon_select_instance = null
	
	main.hud.visible = true
	
	load_level(pending_level_path)

func get_particles_container() -> Node:
	if current_level_instance:
		return current_level_instance.get_node_or_null("Particles")
	return null

func spawn_particle(scene: PackedScene, position: Vector2, color: Color = Color.WHITE, rotation_angle: float = 0.0) -> GPUParticles2D:
	var container: Node = get_particles_container()
	if container == null:
		return
	
	var particle: Node2D = scene.instantiate()
	particle.global_position = position
	particle.modulate = color
	particle.rotation = rotation_angle
	
	container.add_child(particle)
	
	return particle
