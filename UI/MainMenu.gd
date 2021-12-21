extends Control


func _process(_delta):
	if $PlayButton.pressed:
		get_tree().change_scene("res://World/Forest.tscn")
	if $ExitButton.pressed:
		get_tree().quit()
