extends Sprite2D

@onready var player: Player = get_parent()

func _process(_delta: float) -> void:
	global_position = get_global_mouse_position()
	visible = player.weapon.pending_empowerment == null
