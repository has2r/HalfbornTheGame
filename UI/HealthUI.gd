extends Control

var hearts = 4 setget set_hearts
var max_hearts = 4 setget set_max_hearts
var mana_points = 4 setget set_mana_points
var max_mana_points = 4 setget set_max_mana_points
var money 

onready var HealthText = $HeartTexture/HealthText
onready var HealthImage = $HeartTexture
onready var ManaText = $Mana/ManaText
onready var ManaImage = $Mana
onready var DemonEnergyText = $Violet/DemonEnergyText
onready var DemonEnergyImage = $Violet
onready var AmmoText = $Ammo/AmmoText
onready var Ammo = $Ammo
onready var MoneyText = $MoneyIcon/MoneyText

func set_hearts(value):
	hearts = clamp(value, 0, max_hearts)
	HealthText.clear()
	HealthText.add_text(String(hearts))
	HealthImage.value = float(hearts)/max_hearts * 100 
	
func set_max_hearts(value):
	max_hearts = max(value, 0) 
	self.hearts = min(hearts, max_hearts)
	HealthText.add_text(String(hearts))
	HealthImage.value = 100 
func set_mana_points(value):
	mana_points = clamp(value, 0, max_mana_points)
	ManaText.clear()
	ManaText.add_text(String(mana_points))
	ManaImage.value = float(mana_points)/max_mana_points * 100 
	
func set_max_mana_points(value):
	max_mana_points = max(value, 0) 
	self.mana_points = min(mana_points, max_mana_points)
	ManaText.add_text(String(max_mana_points))
	ManaImage.value = 100
		
func set_money_text():
	MoneyText.clear()
	MoneyText.add_text(String(Inventory.money))
func set_ammo_text():
	AmmoText.clear()
	AmmoText.add_text(String(Inventory.ammo))
	
func draw_accessories():
	for i in range(Inventory.active_accessories.size()):
		var accTexture = TextureRect.new()
		accTexture.texture = load("res://Items/Accessories/" + Inventory.active_accessories[i] + ".png")
		if i > 2:
			accTexture.expand = true
			accTexture.stretch_mode = 4
			accTexture.rect_scale = Vector2(0.5,0.5)
			accTexture.rect_position.x = 107 + (i-2)*9
			accTexture.rect_position.y = 15
		else:
			accTexture.rect_position.x = 64 + i*16
			accTexture.rect_position.y = 6
		add_child(accTexture)
func _ready():
	self.max_hearts = Stats.max_health
	self.hearts = Stats.health
	self.max_mana_points = Stats.max_mana
	self.mana_points = Stats.mana
	HealthText.rect_clip_content = false
	Stats.connect("health_changed", self, "set_hearts")
	Stats.connect("mana_changed", self, "set_mana_points")
	Inventory.connect("money_changed", self, "set_money_text")
	Inventory.connect("ammo_changed", self, "set_ammo_text")
	Inventory.connect("accessory_changed", self, "draw_accessories")
	set_money_text()
	set_ammo_text()
	draw_accessories()
	
func _process(_delta):
	if Utils.enemies_count == 0:
		$NextLevelButton.visible = true
		$NextLevelButton.disabled = false
		
	
func _input(_event):
	if Input.is_action_just_pressed("Pause"):
		if (get_tree().paused):
			get_tree().paused = false
			get_node("PauseMenu").visible = false
		else:
			get_tree().paused = true
			get_node("PauseMenu").visible = true
	if $NextLevelButton.pressed:
		match Utils.area_number[0]:
			1:
				if Utils.area_number[1] == 4:
					Utils.area_number = [2,1]
					get_tree().change_scene("res://World/DemonDungeon.tscn")
				else:

					Utils.area_number[1] +=1
					get_tree().change_scene("res://World/World.tscn")
			2:
				if Utils.area_number[1] == 4:
					Utils.area_number = [3,1]
					get_tree().change_scene("res://World/Sandland.tscn")
				else:
					Utils.area_number[1] +=1
					get_tree().change_scene("res://World/DemonDungeon.tscn")
			3:
				get_tree().change_scene("res://World/Sandland.tscn")

		
	
