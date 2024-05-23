extends CharacterBody2D

@export var move_speed : float = 100
@export var start_direction : Vector2 = Vector2(0, 1)

# parameters/Idle/blend_position
# parameters/Walk/blend_position

@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")

var player : CharacterBody2D

func _ready():
	update_animation_param(start_direction)
	player = get_tree().get_first_node_in_group("Player")
	PlayerVariables.spawn_coords = player.global_position

func _physics_process(_delta):
	
	var input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	
	update_animation_param(input_direction)
	
	velocity = input_direction * move_speed
	
	move_and_slide()
	
	change_state()

func update_animation_param(move_input : Vector2):
	
	if (move_input != Vector2.ZERO):
		animation_tree.set("parameters/Walk/blend_position", move_input)
		animation_tree.set("parameters/Idle/blend_position", move_input)

func change_state():
	if (velocity != Vector2.ZERO):
		state_machine.travel("Walk")
	else:
		state_machine.travel("Idle")
