extends State
class_name EnemyIdle

@export var enemy: CharacterBody2D
@export var move_speed := 10.0

var player: CharacterBody2D

var move_direction : Vector2
var wander_time : float

@export var current_states = enemy_states.MOVEDOWN
enum enemy_states{MOVERIGHT, MOVELEFT, MOVEUP, MOVEDOWN, PAUSE}

var dir

const lines: Array[String] = [
	"Hey!"
]

func enter():
	print("enter enter")
	player = get_tree().get_first_node_in_group("Player")
	randomize_wander()

func randomize_wander():
	#move_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	#wander_time = randf_range(1, 3)
	print("enter random wander")
	match current_states:
		enemy_states.MOVERIGHT:
			move_right()
		enemy_states.MOVELEFT:
			move_left()
		enemy_states.MOVEUP:
			move_up()
		enemy_states.MOVEDOWN:
			move_down()
		enemy_states.PAUSE:
			move_pause()

#func update(delta: float):
#	if wander_time > 0:
#		wander_time -= delta
#	else:
#		randomize_wander()

func Physics_Update(delta: float):
	if enemy:
		enemy.velocity = move_direction * move_speed
		
	var direction = player.global_position - enemy.global_position
	
	if direction.length() < 100 && move_direction.angle_to(player.global_position) < PI/4:
		Transitioned.emit(self, "Follow")

func move_right():
	move_direction = Vector2.RIGHT

func move_left():
	move_direction = Vector2.LEFT

func move_up():
	move_direction = Vector2.UP

func move_down():
	move_direction = Vector2.DOWN

func move_pause():
	move_direction = Vector2.ZERO

func random_generation():
	dir = randi() % 5
	print(dir)
	random_direction()
	
func random_direction():
	match dir:
		0:
			current_states = enemy_states.MOVERIGHT
		1:
			current_states = enemy_states.MOVELEFT
		2:
			current_states = enemy_states.MOVEUP
		3:
			current_states = enemy_states.MOVEDOWN
		4:
			current_states = enemy_states.PAUSE

func _on_timer_timeout():
	random_generation()
	$WalkTimer.start()
	randomize_wander()

