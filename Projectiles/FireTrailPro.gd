extends Projectile
var start_rot
var starting_position=Vector2(0,0)
func _init():
	damage = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	start_rot = $Particles2D.rotation_degrees
	starting_position.x = position.x
	starting_position.y = position.y

func _physics_process(delta):
	if start_rot + 45 < $Particles2D.rotation_degrees:
		queue_free()
	rotation_degrees += 180 * delta
	position.x = starting_position.x + cos(rotation) * 100
	position.y = starting_position.y + sin(rotation) * 100
