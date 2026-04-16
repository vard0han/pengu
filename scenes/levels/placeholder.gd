extends Node2D

@onready var reticle = $Reticle


func _process(_delta):
	reticle.global_position = get_global_mouse_position()
