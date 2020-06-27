extends KinematicBody2D

var velocity = Vector2()
var direction = 1
var is_dead = false

const Gravity = 10
const Speed = 30
const Floor = Vector2(0,-1)

func _ready():
	$anim.play("walk")
	
func dead():
	is_dead = true
	velocity = Vector2(0,0)
	queue_free()
	
func _process(delta):
	if is_dead == false:
		velocity.x = direction * Speed
		if not $BottomRay.is_colliding():
			direction *= -1
			$BottomRay.position.x *= -1
			$anim.flip_h = bool(1-direction)
		velocity.y += Gravity
	
	velocity = move_and_slide(velocity, Floor)
