extends CharacterBody2D


@export_category("Movement")
@export var SPEED: float = 80.0
@export var path_follow_2d: PathFollow2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var last_position: Vector2
var facing := Vector2i.DOWN
var _input_vector := Vector2.ZERO

func _ready() -> void:
	if path_follow_2d:
		position = path_follow_2d.global_position
	last_position = position

func _physics_process(_delta: float) -> void:
	if path_follow_2d:
		path_follow_2d.progress += SPEED * _delta
		position = path_follow_2d.global_position
	
	var dir := position - last_position
	if dir:
		velocity = velocity.move_toward(dir * SPEED, 10)
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
