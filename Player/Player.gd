extends KinematicBody2D

var velocity = Vector2()
var dir = 1
var anim = "idle"
var is_dead = false
const SPEED = 200
const GRAVITY = 10
const JUMP = 400
const FLOOR = Vector2(0,-1)

const LIGHTBALL = preload("res://Player/Lightball.tscn")

func _ready():
	$anim.play("idle")
	
func _restart():
	get_tree().reload_current_scene()
	
func dead():
	is_dead = true
	$anim.play("dead")
	$Timer.connect("timeout", self, "_restart")
	$Timer.set_wait_time(1)
	$Timer.start()
	
func _physics_process(delta):
	
	if !is_dead:
		if Input.is_action_pressed("ui_left"):
			velocity.x = -SPEED
			anim = "run"
			dir = -1
			$anim.flip_h = bool(1-dir)
			$anim.position.x = -15
			if sign($Position2D.position.x) == 1:
				$Position2D.position.x *= -1
		elif Input.is_action_pressed("ui_right"):
			velocity.x = SPEED
			anim = "run"
			dir = 1
			$anim.flip_h = bool(1-dir)
			$anim.position.x = 15
			if sign($Position2D.position.x) == -1:
				$Position2D.position.x *= -1
		else:
			velocity.x = 0
			anim = "idle"
		
		if Input.is_action_pressed("ui_up") and is_on_floor():
			velocity.y = -JUMP
		
		if not $RayCast2D.is_colliding():
			anim = "jump"
			
		if Input.is_action_pressed("light_on"):
			$light.enabled = true
		else:
			$light.enabled = false
			
		if Input.is_action_just_pressed("left_click"):
			var lightball = LIGHTBALL.instance()
			if sign($Position2D.position.x) == 1:
				lightball.set_lightball_direction(1)
			else:
				lightball.set_lightball_direction(-1)
			get_parent().add_child(lightball)
			lightball.position = $Position2D.global_position
		
		$anim.play(anim)
		
		for i in get_slide_count():
			var collision = get_slide_collision(i)
			if "Enemy" in collision.collider.name:
				dead()
				self.collision_layer = 2
				self.collision_mask = 2
				
	velocity.y += GRAVITY	
	velocity = move_and_slide(velocity, FLOOR)
