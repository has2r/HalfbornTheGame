extends Node

export(int) var max_health = 5 setget set_max_health
export(int) var max_mana = 5
var health = max_health setget set_health
var mana = max_mana setget set_mana

signal no_health(boolean)
signal health_changed(value)
signal max_health_changed(value)
signal mana_changed(value)
signal max_mana_changed(value)

func set_max_health(value):
	max_health = value
	self.health = min(health, max_health)
	emit_signal("max_health_changed", max_health)

func set_health(value):
	health = value
	emit_signal("health_changed", health)
	if health <= 0:
		emit_signal("no_health", true)

func set_mana(value):
	mana = value
	emit_signal("mana_changed", mana)

func set_max_mana(value):
	max_mana = value
	self.mana = min(mana, max_mana)
	emit_signal("max_mana_changed", max_mana)

func _ready():
	self.health = max_health
	self.mana = max_mana
