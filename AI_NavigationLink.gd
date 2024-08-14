extends Node2D
class_name AI_NavLink

@onready var exec_point: Area2D = $ExecPoint

var navigation_links: Array[NavigationLink2D]

# An array of enemies that await the execution of the transition function
var enemy_queue: Array[Enemy]

func _ready() -> void:
	for child in get_children():
		if child is NavigationLink2D:
			navigation_links.append(child)

func _physics_process(delta: float) -> void:
	for b in exec_point.get_overlapping_bodies():
		_exec(b)

func _exec(body: Enemy):
	pass
