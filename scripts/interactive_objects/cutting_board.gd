extends Sprite2D

var player_in_zone = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact"):
		if player_in_zone:
			print("INTERACTED WITH CUTTING BOARD!")


func _on_interaction_detection_area_body_entered(body: Node2D) -> void:
	player_in_zone = true


func _on_interaction_detection_area_body_exited(body: Node2D) -> void:
	player_in_zone = false
