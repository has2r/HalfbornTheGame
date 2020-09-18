extends Control

var hearts = 4 setget set_hearts
var max_hearts = 4 setget set_max_hearts
var mana_points = 4 setget set_mana_points
var max_mana_points = 4 setget set_max_mana_points

onready var HeartUI_full = $HeartUI_full
onready var HeartUI_empty = $HeartUI_empty
onready var ManaUI_full = $ManaUI_full
onready var ManaUI_empty = $ManaUI_empty

func set_hearts(value):
	hearts = clamp(value, 0, max_hearts)
	if HeartUI_full!= null:
		HeartUI_full.rect_size.x = hearts * 13
	
func set_max_hearts(value):
	max_hearts = max(value, 0) 
	self.hearts = min(hearts, max_hearts)
	if HeartUI_empty!= null:
		HeartUI_empty.rect_size.x = max_hearts * 13
		
func set_mana_points(value):
	mana_points = clamp(value, 0, max_mana_points)
	if ManaUI_full!= null:
		if (mana_points==0):
			ManaUI_full.visible = false
		ManaUI_full.rect_size.x = mana_points * 14
	
func set_max_mana_points(value):
	max_mana_points = max(value, 0) 
	self.mana_points = min(mana_points, max_mana_points)
	if ManaUI_empty!= null:
		ManaUI_empty.rect_size.x = max_mana_points * 14
	

func _ready():
	self.max_hearts = Stats.max_health
	self.hearts = Stats.health
	self.max_mana_points = Stats.max_mana
	self.mana_points = Stats.mana
	Stats.connect("health_changed", self, "set_hearts")
	Stats.connect("mana_changed", self, "set_mana_points")
	
