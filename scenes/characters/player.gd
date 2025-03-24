class_name Player
extends CharacterBody2D

@onready var interaction_ray = $RayCast2D
@onready var interaction_ray_target = $DebugSprite

@export_category("Movement")
@export var SPEED: float = 80.0
var facing := Vector2i.DOWN


var _input_vector := Vector2.ZERO

# TODO: Remove this, it's just temp!
const _dialogue := preload("res://dialogue/test.dialogue")

func _ready():
	interaction_ray_target.visible = false
	if OS.is_debug_build(): #For testing the raycast, safe to remove
		interaction_ray_target.visible = true
	else:
		pass

func _physics_process(_delta: float) -> void:
	handle_interactions()
	var dir := _input_vector
	if dir:
		velocity = velocity.move_toward(dir * SPEED, 20)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, 20)

	move_and_slide()

	if dir:
		if absf(dir.x) > absf(dir.y):
			facing = Vector2i.RIGHT * signf(dir.x)
		else:
			facing = Vector2i.DOWN * signf(dir.y)
		# Play walk animationd
		match facing:
			Vector2i.LEFT:
				$AnimatedSprite2D.play("walk_left")
			Vector2i.RIGHT:
				$AnimatedSprite2D.play("walk_right")
			Vector2i.UP:
				$AnimatedSprite2D.play("walk_up")
			Vector2i.DOWN:
				$AnimatedSprite2D.play("walk_down")
	else:
		# Play idle animation
		match facing:
			Vector2i.LEFT:
				$AnimatedSprite2D.play("idle_left")
			Vector2i.RIGHT:
				$AnimatedSprite2D.play("idle_right")
			Vector2i.UP:
				$AnimatedSprite2D.play("idle_up")
			Vector2i.DOWN:
				$AnimatedSprite2D.play("idle_down")
	


func _unhandled_input(_event: InputEvent) -> void:
	_input_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")

	# TODO: Remove this, it's just temp!
	if Input.is_action_just_pressed("ui_accept"):
		DialogueManager.show_dialogue_balloon(_dialogue, "start")

func handle_interactions(): #Updates the raycast and handles interactions
	#interaction_ray.target_position = facing * 40 #Setting direction for interaction
	#interaction_ray_target.position = interaction_ray.target_position #Positioning the raycast target marker
	if OS.is_debug_build(): print('Tried interacting with ', interaction_ray.get_collider())
	if Input.is_action_just_pressed("interact"):
		if interaction_ray.is_colliding(): #Checks if the raycast found a target
			if OS.is_debug_build(): print('Tried interacting with ', interaction_ray.get_collider()) #Safe to remove
			if interaction_ray.get_collider().has_method('interact'): #Checks if the target is interactable
				interaction_ray.get_collider().interact() #Call the interact() method, containing all the logic
