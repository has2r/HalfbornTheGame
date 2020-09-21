extends KinematicBody2D



export var ACCELERATION = 300
export var MAX_SPEED = 90
export var FRICTION = 200
export var WANDER_TARGET_RANGE = 4
export var damage = 1

enum {
	IDLE,
	WANDER,
	RUN,
	HURT,
	DEAD,
	STUN
}

var velocity = Vector2.ZERO
var knockback = Vector2.ZERO
var deathTimer

export var state = IDLE


onready var stats = $Stats
onready var hurtbox = $Hurtbox
onready var wanderController = $WanderController
onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var stateMachine = animationTree.get("parameters/playback")

func _ready():
	state = IDLE
	deathTimer = Timer.new()
	deathTimer.set_one_shot(true)
	deathTimer.set_wait_time(2)
	deathTimer.connect("timeout", self, "queue_free")
	add_child(deathTimer)

func _physics_process(delta):
	if stats.health <= 0:
		state = DEAD
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		STUN:
			stateMachine.travel("Idle")
			velocity = Vector2(0,0)
			
		IDLE:
			stateMachine.travel("Idle")
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
			if wanderController.get_time_left() == 0:
				update_wander()
				
		WANDER:
			stateMachine.travel("Run")
			seek_player()
			if wanderController.get_time_left() == 0:
				update_wander()
			accelerate_towards_point(wanderController.target_position, delta)
			if global_position.distance_to(wanderController.target_position) <= WANDER_TARGET_RANGE:
				update_wander()
			
		RUN:
			var player = Utils.player
			if (player != null and (Utils.player.global_position - global_position).length() < 200):
				stateMachine.travel("Run")
				accelerate_towards_point(player.global_position, delta)
			else:
				state = IDLE
				stateMachine.travel("Idle")
		HURT:
			stateMachine.travel("Hurt")
			velocity = Vector2(0,0)
		DEAD:
			$Hurtbox/CollisionShape2D2.disabled = true
			$CollisionShape2D.disabled = true
			stateMachine.travel("Dead")
			velocity = Vector2(0,0)


	velocity = move_and_slide(velocity)

func accelerate_towards_point(point, delta):
	var direction = global_position.direction_to(point)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	$Sprite.flip_h = velocity.x < 0

func seek_player():
	var player = Utils.player
	if (player!=null):
		if ((Utils.player.global_position - global_position).length() < 200):
			state = RUN
		
func update_wander():
	state = pick_random_state([IDLE, WANDER])
	wanderController.start_wander_timer(rand_range(1, 3))
	
func pick_random_state(state_list):
	return Utils.random_choice(state_list)


func _on_Hurtbox_area_entered(area):
	if (area.collision_layer == 16):
		if (stats.health - area.get_parent().damage > 0):
			state = HURT
		else:
			deathTimer.start()
			Utils.enemies_count-=1
			Utils.call_deferred("drop_item", Utils.random_choice(["Crossbow", "FireballStaff", "SimpleBow", "SimpleSword"]), position)
			state = DEAD
		stats.health -= area.get_parent().damage
		knockback = area.get_parent().knockback_vector * 150
