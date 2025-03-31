extends Node2D
@onready var spawn = $Spawn
@onready var fruit = $Fruit


func _on_spawn_timer_timeout():
		var new_fruit = fruit.duplicate()
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
