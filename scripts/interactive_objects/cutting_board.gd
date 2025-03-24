extends StaticBody2D

var player_in_zone = false

signal start_game()


func interact():
	start_game.emit()
