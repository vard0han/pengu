extends CharacterBody2D

@export var move_speed : float = 200.0



func _physics_process(_delta):
	
	var direction : float = Input.get_axis("move_left", "move_right")
	
	velocity.x = move_speed * direction
	
	move_and_slide()
