extends AI_NavLink
class_name AI_NavLink_Jump

@onready var path: Path2D = $Path2D

@export var Xspeed: float

func _exec(body: Enemy):
	if enemy_queue.has(body):
		var jumpHeight = 0
		
		for point in path.curve.get_baked_points():
			if point.y < jumpHeight:
				jumpHeight = point.y
		
		if body is Enemy:
			body._jump(_calculate_jump_height(jumpHeight))
			body.in_navLink = true
			body.in_jump_navLink = true
			body.current_navLink_speed = Xspeed
		
		enemy_queue.erase(body)

func _calculate_jump_height(pixel_height: float) -> float:
	var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
	return -sqrt(2 * gravity * abs(pixel_height))
