extends Control

## Number of keys to press
@export var sequence_length: int = 5
## Time in seconds to complete input
@export var time_limit: float = 5.0
## Time to display the key sequence for
@export var sequence_display_time: float = 1.5

var key_options = ["A", "S", "D", "Z", "X", "C"]
var key_sequence = []
var player_input = []
var game_active = false

@onready var key_sequence_label: Label = $KeySequenceLabel
@onready var player_input_label: Label = $PlayerInputLabel
@onready var result_label: Label = $ResultLabel
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var game_timer: Timer = $GameTimer
@onready var sequence_display_timer: Timer = $SequenceDisplayTimer

signal minigame_finished(result)

func start_game() -> void:
	result_label.visible = false
	game_active = true
	player_input.clear()
	key_sequence = generate_sequence(sequence_length)
	key_sequence_label.text = "Sequence: " + " ".join(key_sequence)
	player_input_label.text = "Your Input: "
	
	game_timer.start(time_limit)
	progress_bar.max_value = time_limit
	progress_bar.value = time_limit
	
	#start the sequence hide timer:
	sequence_display_timer.start(sequence_display_time)
	
func generate_sequence(length: int) -> Array:
	var sequence = []
	for i in range(length):
		sequence.append(key_options[randi() % key_options.size()])
	return sequence
	
func _process(delta):
	if game_active:
		#upate progress bar to reflect time left in game
		progress_bar.value = game_timer.time_left
	
func _input(event) -> void:
	if not game_active:
		return
	
	if event is InputEventKey and event.is_pressed():
		var key_string = OS.get_keycode_string(event.keycode).to_upper()
		
		if key_string in key_options:
			player_input.append(key_string)
			player_input_label.text = "Your Input: " + " ".join(player_input)
			
			# now check if the input is correct
			if player_input.size() > key_sequence.size() or player_input[player_input.size() -1] != key_sequence[player_input.size() - 1]:
				end_game(false)
				return
			
			# check if sequence is complete:
			if player_input == key_sequence:
				end_game(true)
				

func end_game(success):
	game_active = false
	game_timer.stop()
	
	if success:
		result_label.text = "Perfect Slice!"
	else:
		var accuracy = float(player_input.size()) / sequence_length
		if accuracy >= 0.8:
			result_label.text = "Good Slice!"
		elif accuracy >= 0.5:
			result_label.text = "Rough Slice!"
		else:
			result_label.text = "Failed!"
			
	result_label.visible = true
	key_sequence_label.visible = true
	minigame_finished.emit(true)


func _on_timer_timeout() -> void:
	end_game(false)


func _on_sequence_display_timer_timeout() -> void:
	#hide the main key sequence
	key_sequence_label.visible = false


func _on_cutting_board_start_game() -> void:
	start_game()
