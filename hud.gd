extends Control

onready var sword_pwr_bar = $"%sword_power"
onready var hp_bar = $"%health"


func init():
	sword_pwr_bar.max_value = get_parent().MAX_SWORD_POWER
	sword_pwr_bar.value = get_parent().sword_power
	hp_bar.max_value = get_parent().MAX_HEALTH
	hp_bar.value = get_parent().health


func _on_player_hp_changed(new_value):
	hp_bar.value = new_value


func _on_sword_pwr_changed(new_value):
	if new_value > sword_pwr_bar.max_value:
		new_value = sword_pwr_bar.max_value
	sword_pwr_bar.value = new_value
