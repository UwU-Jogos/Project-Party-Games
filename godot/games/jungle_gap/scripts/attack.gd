extends Node
class_name JG_AttackState

export(NodePath) onready var player = get_node(player) as KinematicBody2D
export(NodePath) onready var project_spawner = get_node(project_spawner) as Position2D
export(NodePath) onready var mira = get_node(mira) as Position2D
export(PackedScene) var fire_project
export(NodePath) onready var animation = get_node(animation) as AnimationPlayer

func attack() -> void:
	if Input.is_action_just_pressed("ui_select") or Input.is_action_just_pressed("attack"):
		#player.is_attacking = true
		animation.play("fire")


func spawn_fire() -> void:
	#var fire_direction: Vector2 = (player.get_global_mouse_position() - player.global_position).normalized()
	var fire_direction: Vector2 = (mira.global_position - player.global_position).normalized()
	var fire = fire_project.instance()
	get_tree().root.call_deferred("add_child", fire)
	fire.global_position = project_spawner.global_position
	fire.direction = fire_direction
