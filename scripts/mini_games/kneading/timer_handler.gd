extends Timer

@onready var time_remaining_label: Label = %TimeRemainingLabel

func update_timer_display() -> void:
	time_remaining_label.text = "Time: %.1f" % time_left

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if time_left > 0:
		update_timer_display()
