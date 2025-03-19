extends Control


## Number of times player must mix
@export var max_mixes: int = 15
## Time between correct mixes
@export var mix_time_window: float = 0.5
## Penalty for bad timing
@export var mix_penalty: float = 5.0
## Reward for good mixing
@export var mix_reward: float = 10.0

var current_mixes: int = 0
var last_mix_time: float = 0.0
var game_active: bool = false

@onready var mixing_progress: ProgressBar = $MixingProgress
@onready var result_label: Label = $ResultLabel
@onready var mixing_speed_timer: Timer = $MixingSpeedTimer
@onready var instructions_label: Label = $InstructionsLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	result_label.visible = false
	mixing_progress.value = 0
	start_game()
	
func start_game() -> void:
	game_active = true
	current_mixes = 0
	mixing_progress.value = 0
	mixing_speed_timer.start()
	last_mix_time = 0.0
	instructions_label.text = "Start Mixing! Press Q and E alternately"
	
func _input(event: InputEvent) -> void:
	if not game_active:
		return
	
	if Input.is_key_pressed(KEY_Q) or Input.is_key_pressed(KEY_E):
		handle_mix()
		
func handle_mix() -> void:
	var current_time = Time.get_ticks_msec() / 1000.0
	var time_since_last_mix = current_time - last_mix_time
	if last_mix_time > 0 and time_since_last_mix > mix_time_window:
		mixing_progress.value = max(mixing_progress.value - mix_penalty, 0) # apply penalty
		
	last_mix_time = current_time
	mixing_progress.value = min(mixing_progress.value + mix_reward, 1000)
	current_mixes += 1
	
	if current_mixes >= max_mixes:
		end_game()


func end_game() -> void:
	game_active = false
	mixing_speed_timer.stop()
	
	if (mixing_progress.value >= 90):
		result_label.text = "Pefect Mix!"
	elif (mixing_progress.value >= 60):
		result_label.text = "Decent Mix!"
	else:
		result_label.text = "Lumpy Batter...."
		
	result_label.visible = true
