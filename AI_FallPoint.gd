extends AI_NavLink
class_name AI_NavLink_Fall

func _exec(body: Enemy):
	if enemy_queue.has(body):
		if body is Enemy:
			body._fall_through_oneway_platform()
			body.in_navLink = true
		
		enemy_queue.erase(body)
