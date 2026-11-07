extends StaticBody2D

var player = null
var hooked = null
var force = 0
#set up velocity calculation and knockback

func _process(delta: float) -> void:
	if player != null:
		force = global_position.distance_to(player.global_position) * delta
		global_position += global_position.direction_to(player.global_position) * force
		if global_position.distance_to(player.global_position) <= 40:
			if hooked:
				hooked.detach()
				hooked = null
				player = null
				force = 0

func assignHooks(char, hook):
	player = char
	hooked = hook
	
