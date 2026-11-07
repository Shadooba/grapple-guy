extends Node2D

var maxDistance = 450
var force = 15
var isAttached = false
var attachedTo = null
var player = null
var retracting = false

#Starts timer to delete bullet
func _ready() -> void:
	retracting = false
	$Timer.start(2.5)

#Moves bullet forward
func _process(delta: float) -> void:
	if retracting:
		force -= delta + 0.7
	if not isAttached:
		if retracting:
			global_position += global_position.direction_to(player.global_position) * -force
		else:
			global_position += Vector2.RIGHT.rotated(rotation) * force
		if global_position.distance_to(player.global_position) > maxDistance:
			retracting = true
	else:
		global_position = attachedTo.global_position
	
	if global_position.distance_to(player.global_position) < 40:
		queue_free()
		
	$String.points = [player.global_position,self.global_position]
	
#Deletes bullet if miss
func _on_timer_timeout() -> void:
	if not isAttached:
		queue_free()

#Body collision
func _on_hitbox_body_entered(body: PhysicsBody2D) -> void:
	if not isAttached:
		if body is CharacterBody2D:
			print("hit" + body.name)
			if body.has_method("damage"):
				#Checks if body is alive
				if not body.damage(3):
					if body.has_method("hookAttach"):
						body.hookAttach(self)
					isAttached = true
					attachedTo = body
				else:
					queue_free()
		if body is StaticBody2D:
			if body.has_method("assignHooks"):
				body.assignHooks(player, self)
				isAttached = true
				attachedTo = body

func detach():
	isAttached = false
	attachedTo = null
	queue_free()
