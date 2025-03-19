extends Node

## Number of presses needed to win
@export var goal_presses: int = 20  
## Time limit in seconds
@export var time_limit: float = 5.0 
var current_presses: int = 0
var game_active: bool = true

@onready var progress_bar: ProgressBar = %ProgressBar
@onready var time_remaining_label: Label = %TimeRemainingLabel
@onready var result_label: Label = %ResultLabel
@onready var timer: Timer = %Timer
@onready var mash_button: Button = %Mash

func _ready() -> void:
	result_label.visible = false
	mash_button.pressed.connect(increment_presses)
	timer.timeout.connect(_on_timer_timeout)
	start_game()
	update_progress()
	
func start_game() -> void:
	game_active = true
	current_presses = 0
	update_progress()
	timer.start(time_limit)
	
func _input(event: InputEvent) -> void:
	if game_active:
		#Check if Q is pressed
		if Input.is_key_pressed(KEY_Q):
			mash_button.pressed.emit()
	
func increment_presses() -> void:
	if game_active and current_presses < goal_presses:
		current_presses += 1
		update_progress()
		if current_presses >= goal_presses:
			end_game(true)
			
func update_progress() -> void:
	progress_bar.value = (current_presses * 100.0) / goal_presses
	
func _on_timer_timeout() -> void:
	end_game(false)
	
func end_game(won: bool) -> void:
	game_active = false
	result_label.visible = true
	if won:
		result_label.text = "You Win!"
	else:
		result_label.text = "Failed!"
		
	mash_button.disabled = true
	timer.stop()
