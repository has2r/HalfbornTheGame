extends Projectile

func _process(_delta):
	$AnimatedSprite.play()
	if $AnimatedSprite.frame == 5:
		queue_free()
	
