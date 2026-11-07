extends CharacterBody2D

@onready var bulletScene = preload("res://pistol_bullet.tscn")
@onready var hookScene = preload("res://hook.tscn")
var hook = null
var speed = 400
var state = 0 #0-Idle, 1-Melee, 2-Dash
var movement = true

func _ready() -> void:
	$MeleeHitbox.monitoring = false
	$MeleeHitbox.visible = false
	$SpecMeleeHitbox.monitoring = false
	$SpecMeleeHitbox.visible = false

func _process(delta):
	if movement:
		
		#Look At Mouse
		look_at(get_global_mouse_position())
	
		#Movement
		velocity = Vector2.ZERO
	
		if Input.is_action_pressed("down"):
			velocity.y += 1
		if Input.is_action_pressed("up"):
			velocity.y -= 1
		if Input.is_action_pressed("right"):
			velocity.x += 1
		if Input.is_action_pressed("left"):
			velocity.x -= 1
		
		if velocity.length() > 0:
			velocity = velocity.normalized() * speed
		
	position += velocity * delta #pos = vel * del makes for a good stick display
	
	if Input.is_action_just_pressed("mLeft") and state != 1 and state != 2:
		var bullet = bulletScene.instantiate()
		get_tree().root.add_child(bullet)
		bullet.global_transform = $Barrel.global_transform
		
	#Checks if hook exists before instantiating new
	if Input.is_action_just_pressed("mRight") and state != 1 and state != 2 and hook == null:
		hook = hookScene.instantiate()
		hook.player = self
		get_tree().root.add_child(hook)
		hook.global_transform = $Barrel.global_transform
	
	if Input.is_action_just_pressed("q"):
		movement = false
		state = 2
		velocity = Vector2.RIGHT.rotated(rotation) * 3000
		$DashTimer.start(0.15)
		print("start" + str(state))
	
	if Input.is_action_just_pressed("e") and state != 1:
		if state == 2:
			await $DashTimer.timeout
			movement = false
			state = 1
			$SpecMeleeHitbox.monitoring = true
			$SpecMeleeHitbox.visible = true
			$MeleeTimer.start(0.4)
		else:
			state = 1
			$MeleeHitbox.monitoring = true
			$MeleeHitbox.visible = true
			$MeleeTimer.start(0.25)
		
func _on_melee_timer_timeout() -> void:
		movement = true
		state = 0
		$MeleeHitbox.monitoring = false
		$MeleeHitbox.visible = false
		$SpecMeleeHitbox.monitoring = false
		$SpecMeleeHitbox.visible = false

func _on_melee_body_entered(body: PhysicsBody2D) -> void:
	if body is CharacterBody2D:
		print("hit" + body.name)
		if body.has_method("damage"):
			body.damage(5)

func _on_spec_melee_body_entered(body: PhysicsBody2D) -> void:
	if body is CharacterBody2D:
		print("hit" + body.name)
		if body.has_method("damage"):
			body.damage(6)

func _on_dash_timer_timeout() -> void:
	movement = true
	state = 0
	velocity = Vector2.ZERO
	print("end" + str(state))
