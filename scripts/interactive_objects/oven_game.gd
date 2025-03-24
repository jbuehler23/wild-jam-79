extends Control

@onready var path_2d: Path2D = $Path2D
@onready var sprite_mover: PathFollow2D = $Path2D/SpriteMover
@onready var scoring_zone: PathFollow2D = $Path2D/ScoringZone
@onready var score_marker: Line2D = $Path2D/ScoreMarker
@onready var minigame_ui: CanvasLayer = $"../.."
@onready var player = get_tree().get_first_node_in_group('player')

##Area for starting of "goal" area to press a button
@export var zone_start: float = 0.4
##Area for end of "goal" area to press a button
@export var zone_end: float = 0.6
var game_active: bool = false

func _ready():
	minigame_ui.visible = false

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



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not game_active: return
	if Input.is_action_just_pressed("ui_cancel"): finish_game()
	
	if Input.is_action_just_pressed("interact"):
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

func _on_oven_start_game() -> void:
	start_game()

func start_game():
	player.in_minigame = true #Locks player movement
	game_active = true
	draw_scoring_zone()
	minigame_ui.visible = true

func finish_game():
	player.in_minigame = false
	game_active = false
	minigame_ui.visible = false
