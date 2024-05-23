extends CharacterBody2D
class_name GuardEnemy

@export var move_speed : float = 10
@export var start_direction : Vector2 = Vector2(0, 1)

@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")

func _ready():
	update_animation_param(start_direction)

func _physics_process(delta):
	update_animation_param(velocity * Vector2(1, -1))

	move_and_slide()
	change_state()


func update_animation_param(velocity : Vector2):
	if (velocity != Vector2.ZERO):
		animation_tree.set("parameters/Walk/blend_position", velocity)
		animation_tree.set("parameters/Idle/blend_position", velocity)

func change_state():
	if (velocity != Vector2.ZERO):
		state_machine.travel("Walk")
	else:
		state_machine.travel("Idle")

