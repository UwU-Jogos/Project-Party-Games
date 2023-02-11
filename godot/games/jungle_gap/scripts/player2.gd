extends KinematicBody2D
class_name JG_Player2

onready var move_state: Node = get_node("States/Move")
onready var attack_state: Node = get_node("States/Attack")
onready var animation: Node = get_node("Animation")
onready var spawn: Node = get_node("ProjectSpawner")
onready var mira: Node = get_node("Mira")
export(PackedScene) var fire_project


onready var sprite: Sprite = get_node("Sprite")

var is_attacking: bool = false

func _physics_process(_delta: float) -> void:
	move()
	attack()
	move_mira()
	#pass

func attack() -> void:
	if Input.is_action_just_pressed("attack2"):
		#player.is_attacking = true
		animation.play("fire")
		
func spawn_fire() -> void:
	#var fire_direction: Vector2 = (player.get_global_mouse_position() - player.global_position).normalized()
	var fire_direction: Vector2 = (mira.global_position - global_position).normalized()
	var fire2 = fire_project.instance()
	get_tree().root.call_deferred("add_child", fire2)
	fire2.global_position = spawn.global_position
	fire2.direction = fire_direction
	
func move() -> void:
		#if is_attacking:
		#return
	var velocity = get_direction() * 250
	move_and_slide(velocity)
	
func get_direction() -> Vector2:
#	if Input.is_mouse_button_pressed(2):
		var dir = Vector2(
			Input.get_action_strength("ui_right2") - Input.get_action_strength("ui_left2"),
			(Input.get_action_strength("ui_down2") - Input.get_action_strength("ui_up2")) / 2
		)
		if dir.x > 0:
			sprite.flip_h = false
			spawn.position.x = 60
		elif dir.x < 0:
			sprite.flip_h = true
			spawn.position.x = -45
			
		if dir.y > 0:
			animation.play("walk")
			
		elif dir.y < 0:
			animation.play("walk_up")
			
		return dir

func move_mira() -> void:
		var dir = Vector2(
			Input.get_action_strength("mira_right") - Input.get_action_strength("mira_left"),
			(Input.get_action_strength("mira_down") - Input.get_action_strength("mira_up"))
		)
		mira.position.x = mira.position.x + (dir.x * 10)
		mira.position.y = mira.position.y + (dir.y * 10)


func _on_HitboxArea_body_entered(body):
	print(body)
	var body_name = body.get_name()
	if body_name == "Player2":
		return
	
	animation.play("fall")
	#queue_free()
