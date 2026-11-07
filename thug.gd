extends Node2D

@onready var corpseScene = preload("res://corpse.tscn")
var health = 10
var hooked = null

func _ready() -> void:
	pass

#Returs death
func damage(amount) -> bool:
	health -= amount
	print(health)
	if health <= 0:
		if hooked:
			hooked.detach() #error when enemy dies with hook
			#next steps: good corpse physics, dead enemy moves onto hook
		call_deferred("spawnCorpse")
		return true
	else:
		return false

func spawnCorpse():
	var corpse = corpseScene.instantiate()
	corpse.global_position = self.global_position
	get_tree().root.add_child(corpse)
	queue_free()

func hookAttach(object):
	hooked = object
	print(object)
