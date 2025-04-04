extends Node2D
@onready var spawn = $Spawn
@export var fruit : Array[PackedScene]
@export var spawn_number : int = 15
var spawned : int = 0
var fruit_pool = []
var score : int = 0

func _ready():
	pass

func _on_spawn_timer_timeout():
	if fruit_pool.size() < fruit.size(): # Needed not to spawn the same item too many times
		fruit_pool.append_array(fruit)
		fruit_pool.append_array(fruit)
		#fruit_pool.append_array(fruit)
	
	if spawned < spawn_number:
		spawned += 1
		var new_fruit 
		var spawn_position = randi_range(0, fruit_pool.size()-1)
		new_fruit = fruit_pool.pop_at(spawn_position)
		new_fruit = new_fruit.instantiate()
		self.add_child(new_fruit)
		new_fruit.global_transform = spawn.global_transform
		new_fruit.linear_velocity = Vector2(0,0)
		new_fruit.angular_velocity = 0
		new_fruit.rotation += randf_range(0, 3)
		new_fruit.gravity_scale = 0.5  
		new_fruit.apply_impulse(Vector2(randf_range(-100, 100),randf_range(-950, -800)))
		new_fruit.apply_torque_impulse(randf_range(-1, 1))


func _on_despawn_area_body_entered(body):
	body.queue_free()

func _physics_process(delta):
		if Input.is_action_just_pressed("move_down"):  
			if $SpawnTimer.is_stopped():
				$SpawnTimer.start()
			else:
				$SpawnTimer.stop()


func _on_fruit_leaving_area(body):
	body.linear_velocity[0] = -body.linear_velocity[0]*.9
