extends Node2D

@export var projectile_scene: PackedScene

@onready var muzzle : Marker2D = $Muzzle
@onready var player : Player = get_parent()

func _unhandled_input(event) -> void:
	if event.is_action_pressed("attack"):
		spawn_projectile()

func spawn_projectile() -> void:
	# spawn the chosen projectile, adjust the position to muzzle's position
	var projectile : Projectile = projectile_scene.instantiate()
	projectile.global_position = muzzle.global_position
	
	# handle flight direction, set projectile as a child of "Projectiles" node in the level
	projectile.direction = Vector2.RIGHT if player.sprite.flip_h else Vector2.LEFT
	get_tree().current_scene.get_node("Projectiles").add_child(projectile)
