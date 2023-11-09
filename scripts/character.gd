class_name Character extends KinematicBody

signal died
signal hp_changed(hp)

export (int) var MAX_HEALTH = 3 
export (int) var health setget set_health
var damage = 1

func _ready():
	self.health = MAX_HEALTH

func set_health(value):
	value = clamp(value, 0, MAX_HEALTH)
	health = value
	emit_signal("hp_changed", health)
	if health <= 0:
		emit_signal("died")
		queue_free()

func take_damage(dmg):
	self.health -= dmg
