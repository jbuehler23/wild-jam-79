extends Node2D
@export var sprite_size : Vector2i = Vector2i(128, 128)
 #----------Crutch, must be fixed!------------
@onready var cut_left = $CutRayLeft
@onready var cut_right = $CutRayRight


#Collision polygon MUST have it's points set clockwise to work properly
func cut(left_cut_coordinates = null, right_cut_coordinates = null, fruit_obj  = null, save_bottom = true):
	var multiple_fruit : bool = false
	#Prepariing variables
	cut_left.force_raycast_update()
	cut_right.force_raycast_update()
	# Make sure we are cutting the same fruit
	if cut_left.is_colliding() and cut_left.get_collider() != cut_right.get_collider():
		multiple_fruit = true
		var fruits = get_tree().get_nodes_in_group('fruits')
		for i in fruits:
			if !(cut_left.get_collider() != cut_right.get_collider()): 
				cut_right.add_exception(i)
				cut_right.force_raycast_update()
			else: 
				break
	else:
		multiple_fruit = false
	
	
	var fruit_collision  = null
	var fruit_sprite  = null
	var collision_breakpoint  = null
	var bottom_half = null
	
	#Starting the cut
	if cut_left.is_colliding() and cut_left.get_collider().is_in_group('fruits') and fruit_obj  == null:
		fruit_obj = cut_left.get_collider()
		left_cut_coordinates = fruit_obj.to_local(cut_left.get_collision_point())
		right_cut_coordinates = fruit_obj.to_local(cut_right.get_collision_point())
		print('Collider: ', fruit_obj)
		print('Local cut coordinates: ', left_cut_coordinates, right_cut_coordinates)
		bottom_half = fruit_obj.duplicate()
		bottom_half.global_transform = fruit_obj.global_transform
		$"..".add_child(bottom_half)
		# Move pieces apart
		var impulse = Vector2(randf_range(-30, 30),randf_range(-20, 20))
		var torque = randf_range(-.5, .5)
		bottom_half.apply_impulse(impulse)
		bottom_half.apply_torque_impulse(torque)
		fruit_obj.apply_impulse(-impulse)
		fruit_obj.apply_torque_impulse(-torque)
	
		#Hiding a half
	if fruit_obj != null:
		
		fruit_collision = fruit_obj.get_node('Collision')
		fruit_sprite = fruit_obj.get_node('Sprite')
		
		var material = load("res://test_assets/Fruit_ninja.gdshader")
		var shader_cut_point_left : Vector2 = Vector2(0, 0)
		shader_cut_point_left[0] = snapped((left_cut_coordinates[0])/(sprite_size[0]), 0.01)+0.5
		shader_cut_point_left[1] = snapped((left_cut_coordinates[1])/(sprite_size[1]), 0.01)+0.5
		var shader_cut_point_right : Vector2 = Vector2(0, 0)
		shader_cut_point_right[0] = snapped((right_cut_coordinates[0])/(sprite_size[0]), 0.01)+0.5
		shader_cut_point_right[1] = snapped((right_cut_coordinates[1])/(sprite_size[1]), 0.01)+0.5
		
		print('Shader left cut points: ', shader_cut_point_left, shader_cut_point_right)
		fruit_sprite.material = ShaderMaterial.new()
		fruit_sprite.material.set("shader", material)
		fruit_sprite.material.set_shader_parameter("A", shader_cut_point_left)
		fruit_sprite.material.set_shader_parameter("B", shader_cut_point_right)
		fruit_sprite.material.set_shader_parameter("bottom", save_bottom)
		
		
		#Saving half of the collision
		var poly_points_old = fruit_collision.polygon
		var poly_points_new = PackedVector2Array()
		print('Poly point count: ', poly_points_old.size())
		if save_bottom: # Choose which half to save
			for point in poly_points_old:
				if fruit_obj.to_global(point)[1] < fruit_obj.to_global(left_cut_coordinates)[1]:
					poly_points_new.append(point)
				elif collision_breakpoint == null:
					collision_breakpoint = poly_points_old.find(point)
					print('Breakpoint: ', collision_breakpoint)
					poly_points_new.append_array([right_cut_coordinates, left_cut_coordinates])
		else:
			for point in poly_points_old:
				if fruit_obj.to_global(point)[1] > fruit_obj.to_global(left_cut_coordinates)[1]:
					poly_points_new.append(point)
				elif collision_breakpoint == null:
					collision_breakpoint = poly_points_old.find(point)
					print('Breakpoint: ', collision_breakpoint)
					poly_points_new.append_array([right_cut_coordinates, left_cut_coordinates])
		
		print('Old array:: ', poly_points_old)
		print('New array:: ', poly_points_new)
		fruit_collision.polygon = poly_points_new
		# Making sure we cut all the fruit in line, but only once
		fruit_obj.set_collision_layer_value(2, false)
		cut_right.clear_exceptions()
		if bottom_half != null:
			cut(left_cut_coordinates, right_cut_coordinates, bottom_half, false)
		if multiple_fruit:
			cut()
		# Play sound effect
		fruit_obj.gravity_scale += 0.1
		$"../AudioStreamPlayer2D".global_position = fruit_obj.global_position
		$"../AudioStreamPlayer2D".play()


func _ready():
	#$"../Fruit".rotation += randf_range(0, 3)
	#$"../Fruit".apply_impulse(Vector2(randf_range(-100, 100),randf_range(-800, -600)))
	#$"../Fruit".apply_torque_impulse(randf_range(-1, 1))
	if OS.is_debug_build():
		$"../DebuggingControls".visible = true
	pass

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_accept"):  
		cut()
	if Input.is_action_just_pressed("interact"):  
		var fruits = get_tree().get_nodes_in_group('fruits')
		for fruit in fruits:
			fruit.gravity_scale = 0
			fruit.linear_velocity = Vector2(0,0)
			fruit.angular_velocity = 0
