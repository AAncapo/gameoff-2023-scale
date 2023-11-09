extends Spatial

onready var spwner = $spawner
var enemy_tscn = preload("res://enemy.tscn")
export (int) var enemy_count = 8
onready var enemies_remaining = enemy_count
onready var player := $player


func _ready():
	$Timer.start()


func spawn_wave():
	var spwn_area = $floor.mesh.size/2
	for e in enemy_count:
		var spwn_pos = Vector3(rand_range(-spwn_area.x,spwn_area.x),0,rand_range(-spwn_area.z,spwn_area.z))
		var enemy = enemy_tscn.instance()
		spwner.add_child(enemy)
		enemy.global_translation = spwn_pos
		enemy.connect("died",self,"_on_enemy_died")


func _on_enemy_died():
	player.sword_power += 1
	enemies_remaining -= 1
	if enemies_remaining <= 0:
		$Timer.start()


func _on_Timer_timeout():
	spawn_wave()
