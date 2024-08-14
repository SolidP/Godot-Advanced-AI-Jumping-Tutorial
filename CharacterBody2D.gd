extends CharacterBody2D
class_name Enemy

@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D

var speed: float = 300
var isGrounded: bool
var hasJumped: bool

var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

var targetPoint: Vector2

var in_navLink: bool
var in_jump_navLink: bool
var current_navLink_speed: float

func _physics_process(delta: float) -> void:
	_move(delta)

func _move(delta: float):
	navigation_agent_2d.get_next_path_position()
	var nextPoint = navigation_agent_2d.get_next_path_position()
	var signMoveDir = Vector2(sign(global_position.direction_to(nextPoint).x),
	sign(global_position.direction_to(nextPoint).y))
	
	if not is_on_floor():
		isGrounded = false
		velocity.y += gravity * delta
	else:
		if hasJumped:
			_land()
		
		isGrounded = true
		velocity.y += gravity * delta * 2
	
	var desiredXVel: float = 0
	if in_navLink && !isGrounded:
		desiredXVel = current_navLink_speed
	else:
		desiredXVel = signMoveDir.x * speed
	
	velocity.x = lerpf(velocity.x, desiredXVel, 0.15)
	
	move_and_slide()

func _land():
	hasJumped = false
	
	if in_navLink && in_jump_navLink:
		navigation_agent_2d.target_position = targetPoint
		
		in_navLink = false
		in_jump_navLink = false

func _jump(height: float):
	velocity.y = height
	
	hasJumped = true

func _fall_through_oneway_platform():
	set_collision_mask_value(3, false)
	await get_tree().create_timer(0.1, false, true).timeout
	set_collision_mask_value(3, true)

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("LMB"):
		targetPoint = get_global_mouse_position()
		navigation_agent_2d.target_position = targetPoint

func _on_navigation_agent_2d_link_reached(details: Dictionary) -> void:
	if details.owner.get_parent() is AI_NavLink:
		var nav_link: AI_NavLink = details.owner.get_parent()
		
		if !nav_link.enemy_queue.has(self):
			print ("Entered navlink" + str(nav_link))
			nav_link.enemy_queue.append(self)
