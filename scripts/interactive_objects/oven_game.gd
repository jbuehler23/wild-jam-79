extends Control

@onready var path_2d: Path2D = $Path2D
@onready var sprite_mover: PathFollow2D = $Path2D/SpriteMover
@onready var scoring_zone: PathFollow2D = $Path2D/ScoringZone
@onready var score_marker: Line2D = $Path2D/ScoreMarker

##Area for starting of "goal" area to press a button
@export var zone_start: float = 0.4
##Area for end of "goal" area to press a button
@export var zone_end: float = 0.6

func _ready() -> void:
	draw_scoring_zone()
	
func draw_scoring_zone():
	var curve_length = path_2d.curve.get_baked_length()
	
	var start_pos = path_2d.curve.sample_baked(zone_start * curve_length)
	var end_pos = path_2d.curve.sample_baked(zone_end * curve_length)
	
	#add the marker points
	score_marker.clear_points()
	score_marker.add_point(start_pos)
	score_marker.add_point(end_pos)
	
	score_marker.width = 4.0
	score_marker.default_color = Color.DARK_RED

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		var sprite_progress = sprite_mover.progress_ratio
		if zone_start <= sprite_progress and sprite_progress <= zone_end:
			var zone_center = (zone_start + zone_end) / 2
			var max_distance = (zone_end - zone_start) / 2
			var distance = abs(sprite_progress - zone_center)
			
			#calculate score based on when the player stops the movement
			var score = 100 * (1 - (distance / max_distance))
			score = max(0, score)
			
			print("Score: ", round(score))
		else:
			print("MISS")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_oven_start_game() -> void:
	pass # Replace with function body.
