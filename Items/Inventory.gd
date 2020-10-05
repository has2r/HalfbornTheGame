extends Node

var faceRight = true
var isAttacking = false
signal weapon_changed
signal armor_changed
signal money_changed

var active_weapons = ["SimpleSword", "SimpleBow", "FireballStaff", "Crossbow", "StrangeCard"]
var active_armor = ["DefaultArmor", "SkeletonCostume", "IronArmor"]
var active_accessories = ["Glove"]
var money = 0 setget money_set
var i = 0
var j = 0
var current_weapon = active_weapons[i]
var current_armor = active_armor[j]
var current_acc = active_accessories[j]

func _input(_event):
	if Input.is_action_just_pressed("weapon_change"):
		i+=1
		if i >= active_weapons.size():
			i = 0
		current_weapon = active_weapons[i]
		emit_signal("weapon_changed")
	if Input.is_action_just_pressed("armor_change"):
		j+=1
		if j >= active_armor.size():
			j = 0
		current_armor = active_armor[j]
		emit_signal("armor_changed")
func money_set(value):
	money = value
	emit_signal("money_changed")
