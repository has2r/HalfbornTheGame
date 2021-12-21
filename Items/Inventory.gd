extends Node

var faceRight = true
var isAttacking = false
signal weapon_changed
signal armor_changed
signal money_changed
signal ammo_changed
signal accessory_changed

var active_weapons = ["HorizonClaws"]
var active_armor = ["DefaultArmor", "IronArmor"]
var active_accessories = ["Glove"]
var active_consumables = []
var money = 0 setget money_set
var ammo = 10 setget ammo_set
var i = 0
var j = 0
var current_weapon = active_weapons[i]
var current_armor = active_armor[j]

func _ready():
	connect("accessory_changed", self, "instance_accessory")

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
func instance_accessory():
	var acc = load("res://Items/Accessories/"+active_accessories[-1]+".tscn")
	var instance = acc.instance()
	Utils.player.add_child(instance)
func money_set(value):
	money = value
	emit_signal("money_changed")
func ammo_set(value):
	ammo = value
	emit_signal("ammo_changed")
