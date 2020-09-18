extends Node

var faceRight = true
var isAttacking = false
signal weapon_changed

var active_weapons = ["SimpleSword", "SimpleBow", "FireballStaff", "Crossbow", "StrangeCard"]
var i = 0
var current_weapon = active_weapons[i]

func _input(_event):
	if Input.is_action_just_pressed("weapon_change"):
		i+=1
		if i >= active_weapons.size():
			i = 0
		current_weapon = active_weapons[i]
		emit_signal("weapon_changed")
