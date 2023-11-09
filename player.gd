extends Character

signal sword_power_changed(swrd_pwr)

onready var cam = $cam_base
onready var hitbox = $hitbox
onready var hb_layers = hitbox.get_children()
onready var animp = $AnimationPlayer
onready var hud = $hud
var apply_gravity := false
var gravity := -30
var max_speed = 15
var mouse_sensitivity = 0.005
var velocity = Vector3()
var MAX_SWORD_POWER = 3
var sword_power = 1 setget set_sword_power


func _ready():
	Input.set_mouse_mode(2)
	connect("hp_changed",hud,"_on_player_hp_changed")
	connect("sword_power_changed",hud,"_on_sword_pwr_changed")
	hud.init()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)
		cam.rotation_degrees.x = clamp(cam.rotation_degrees.x,-90,90)
#		cam.rotate_x(-event.relative.y * mouse_sensitivity)
	
	if event is InputEventKey && event.pressed && event.scancode == KEY_ESCAPE:
		var mmode = Input.get_mouse_mode()
		Input.set_mouse_mode(2 if mmode== 0 else 0)


func _process(delta):
	if Input.is_action_just_pressed("attack"):
		attack()


func _physics_process(delta: float) -> void:
	if apply_gravity:
		velocity.y += gravity * delta
	var desired_velocity = get_input() * max_speed
	
	velocity.x = desired_velocity.x
	velocity.z = desired_velocity.z
	velocity = move_and_slide(velocity, Vector3.UP, true)


func set_sword_power(value):
	value = clamp(value, 1, MAX_SWORD_POWER)
	sword_power = value
	for layer in hb_layers:
		layer.disabled = layer.name != str(sword_power-1)
	emit_signal("sword_power_changed",sword_power)


func attack():
	hitbox.monitoring = true
	animp.play("sword_attack")
	yield(animp,"animation_finished")
	
	var enemies = hitbox.get_overlapping_bodies()
	for e in enemies:
		e.take_damage(damage)
		print('hit')
	
	hitbox.monitoring = false


func get_input():
	var input_dir = Vector3()
	
	if Input.is_action_pressed("forward"):
		input_dir += -cam.global_transform.basis.z
	if Input.is_action_pressed("back"):
		input_dir += cam.global_transform.basis.z
	if Input.is_action_pressed("left"):
		input_dir += -cam.global_transform.basis.x
	if Input.is_action_pressed("right"):
		input_dir += cam.global_transform.basis.x
	
	input_dir = input_dir.normalized()
	return input_dir


#func _on_hitbox_body_entered(body):
#	if body.is_in_group("damageable"): 
#		body.take_damage(damage)
#		print('hit')
