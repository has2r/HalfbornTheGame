extends Control

func _input(_event):
	if $ResumeButton.pressed:
		get_tree().paused = false
		get_parent().get_node("PauseMenu").visible = false
