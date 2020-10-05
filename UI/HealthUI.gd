extends Control

var hearts = 4 setget set_hearts
var max_hearts = 4 setget set_max_hearts
var mana_points = 4 setget set_mana_points
var max_mana_points = 4 setget set_max_mana_points
var money 

onready var HealthText = $HealthText
onready var ManaText = $ManaText
onready var MoneyText = $MoneyIcon/MoneyText

func set_hearts(value):
	hearts = clamp(value, 0, max_hearts)
	HealthText.clear()
	HealthText.add_text(String(hearts))
	
func set_max_hearts(value):
	max_hearts = max(value, 0) 
	self.hearts = min(hearts, max_hearts)
	HealthText.add_text(String(hearts))
func set_mana_points(value):
	mana_points = clamp(value, 0, max_mana_points)
	ManaText.clear()
	ManaText.add_text(String(mana_points))
	
func set_max_mana_points(value):
	max_mana_points = max(value, 0) 
	self.mana_points = min(mana_points, max_mana_points)
	ManaText.add_text(String(max_mana_points))
		
func set_money_text():
	MoneyText.clear()
	MoneyText.add_text(String(Inventory.money))
	

func _ready():
	self.max_hearts = Stats.max_health
	self.hearts = Stats.health
	self.max_mana_points = Stats.max_mana
	self.mana_points = Stats.mana
	HealthText.rect_clip_content = false
	MoneyText.clear()
	MoneyText.add_text(String(Inventory.money))
	Stats.connect("health_changed", self, "set_hearts")
	Stats.connect("mana_changed", self, "set_mana_points")
	Inventory.connect("money_changed", self, "set_money_text")
	
func _process(delta):
	if Utils.enemies_count == 0:
		$NextLevelButton.visible = true
		$NextLevelButton.disabled = false
	
func _input(event):
	if Input.is_action_just_pressed("Pause"):
		if (get_tree().paused):
			get_tree().paused = false
			get_node("PauseMenu").visible = false
		else:
			get_tree().paused = true
			get_node("PauseMenu").visible = true
	if $NextLevelButton.pressed:
		get_tree().change_scene("res://World/World.tscn")
		
	
