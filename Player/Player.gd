extends KinematicBody2D


const ACCELERATION = 500
export var MAX_SPEED = 80
const FRICTION = 500


var velocity = Vector2.ZERO
var dead = false


var mousePos = Vector2(0,0)
var current_weapon_node
var current_weapon_instance
var cooldownTimer
var invincibilityTimer
var blinkTimer



onready var weaponSprite = $Weapon
onready var actualSprite = $Weapon/Sprite
onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var stateMachine = animationTree.get("parameters/playback")


func _ready():
	Utils.player = self
	Stats.connect("no_health", self, "set_dead")
	Inventory.connect("weapon_changed", self, "set_weapon")
	
	cooldownTimer = Timer.new()
	cooldownTimer.set_one_shot(true)
	cooldownTimer.set_wait_time(0.4)
	cooldownTimer.connect("timeout", self, "_on_SpriteArm_animation_finished")
	add_child(cooldownTimer)
	
	invincibilityTimer = Timer.new()
	invincibilityTimer.set_one_shot(true)
	invincibilityTimer.set_wait_time(2)
	invincibilityTimer.connect("timeout", self, "invincibility_ends")
	add_child(invincibilityTimer)
	
	blinkTimer = Timer.new()
	blinkTimer.set_one_shot(true)
	blinkTimer.set_wait_time(0.1)
	blinkTimer.connect("timeout", self, "blink_ends")
	add_child(blinkTimer)
	

func _physics_process(_delta):

	if(!dead):
		move_state()
		mousePos = get_local_mouse_position()
		if (weaponSprite.autoattack):
			if Input.is_action_pressed("attack"):
				Inventory.isAttacking = true
				weaponSprite.shoot(mousePos)
				attack_animation()
		else:
			if Input.is_action_just_pressed("attack"):
				Inventory.isAttacking = true
				weaponSprite.shoot(mousePos)
				attack_animation()
	else:
		visible = false
	if Input.is_action_just_pressed("accessory_change"):
		if (dead):
			dead = false
			visible = true
		
func set_weapon():
		current_weapon_node = load("res://Items/Weapons/" + Inventory.current_weapon + ".tscn")
		current_weapon_instance = current_weapon_node.instance()
		weaponSprite.queue_free()
		add_child(current_weapon_instance)
		weaponSprite = current_weapon_instance
		actualSprite = weaponSprite.get_node("Sprite")
		
	
func move_state():
	var input_vector = Vector2.ZERO
	var _current_anim = stateMachine.get_current_node()
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector!= Vector2.ZERO:
		stateMachine.travel("RunRight")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION)
	else:
		stateMachine.travel("IdleRight")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION)
		actualSprite.position.x = 0
		actualSprite.position.y = 0
		actualSprite.rotation_degrees = 0 
	velocity = move_and_slide(velocity)
	
	
	if mousePos.x > 0:
			$Sprite.scale.x = 1
			$SpriteArm.scale.x = 1
			Inventory.faceRight = true
	elif mousePos.x < 0:
			$Sprite.scale.x = -1
			$SpriteArm.scale.x = -1
			Inventory.faceRight = false
			
func attack_animation():
	$SpriteArm.animation = "melee_attack"
	if (weaponSprite.melee):
		$SpriteArm.playing = true
	else:
		if(Inventory.faceRight):
			$SpriteArm.frame = (rad2deg(get_local_mouse_position().angle()) + 90) / 45
		else:
			$SpriteArm.frame = (rad2deg((get_local_mouse_position()*Vector2(-1,1)).angle() ) + 90) / 45
		cooldownTimer.start()

func _on_Sprite_frame_changed():
	var sprite_offset_x = 0
	var sprite_offset_y = 0
	if (!Inventory.isAttacking):
		$SpriteArm.frame = $Sprite.frame
		$SpriteArm.position = Vector2(0,0)
		match ($Sprite.frame):
			0:
				actualSprite.position.x = 0
				actualSprite.position.y = 0
			1:
				actualSprite.position.x = 1 * faceRight_sign()
				actualSprite.position.y = 0
			2:
				actualSprite.position.x = 2 * faceRight_sign()
				actualSprite.position.y = -1
			3:
				actualSprite.position.x = 1 * faceRight_sign()
				actualSprite.position.y = 0
			4:
				actualSprite.position.x = 0
				actualSprite.position.y = -1
			5:
				actualSprite.position.x = 0
				actualSprite.position.y = -2
		actualSprite.rotation_degrees = 0 
	else:
		if (Inventory.faceRight):
			actualSprite.rotation_degrees = (-45 + 45 * $SpriteArm.frame) + weaponSprite.rot_offset
		else: 
			actualSprite.rotation_degrees = ((-45 + 45 * $SpriteArm.frame) * -1) - weaponSprite.rot_offset
		sprite_offset_x += cos(actualSprite.rotation-0.6) * -10 * faceRight_sign() - 5.5
		sprite_offset_y += sin(actualSprite.rotation-0.6) * -10 * faceRight_sign() + 2
		
		actualSprite.position.x = sprite_offset_x
		actualSprite.position.y = sprite_offset_y
		#actualSprite.rotation_degrees = 0 
		#if (Inventory.faceRight):
			#actualSprite.rotation_degrees = (-45 + 45 * $SpriteArm.frame) + weaponSprite.rot_offset
		#else: 
			#actualSprite.rotation_degrees = ((-45 + 45 * $SpriteArm.frame) * -1) - weaponSprite.rot_offset
	

func _on_SpriteArm_animation_finished():
	Inventory.isAttacking = false
	$SpriteArm.playing = false
	$SpriteArm.animation = "default"

func _on_Area2D_area_entered(area):
	if (area.collision_layer!=8):
		Stats.health -= area.get_parent().damage
		$Area2D/Hurtbox.set_deferred("disabled", true)
		$Sprite.material.set("shader_param/active", true)
		$SpriteArm.material.set("shader_param/active", true)
		blinkTimer.start()
		
func blink_ends():
	$Sprite.material.set("shader_param/active", false)
	$SpriteArm.material.set("shader_param/active", false)
	$Sprite.modulate = Color(1, 1, 1, 0.5)
	$SpriteArm.modulate = Color(1, 1, 1, 0.5)
	invincibilityTimer.start()
	
func invincibility_ends():
	$Area2D/Hurtbox.disabled = false
	$Sprite.modulate = Color(1, 1, 1, 1)
	$SpriteArm.modulate = Color(1, 1, 1, 1)
	
	
func set_dead(value):
	dead = value
	
func faceRight_sign():
	if Inventory.faceRight:
		return -1
	else:
		return 1
