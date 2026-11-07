extends Node2D

#Player bullets and enemies on second layer
var speed = 25

#Starts timer to delete bullet
func _ready() -> void:
	$Timer.start(0.5)

#Moves bullet forward
func _process(delta: float) -> void:
	global_position = global_position + Vector2.RIGHT.rotated(rotation) * speed
	
#Deletes bullet
func _on_timer_timeout() -> void:
	queue_free()

#Handles collision on enemies
func _on_area_2d_body_entered(body: PhysicsBody2D) -> void:
	queue_free()
	if body is CharacterBody2D:
		print("hit" + body.name)
		if body.has_method("damage"):
			body.damage(1)
