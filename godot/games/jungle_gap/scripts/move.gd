extends Node
class_name JG_MoveState

var velocity: Vector2

export(int) var walk_speek

export(NodePath) onready var player = get_node(player) as KinematicBody2D
export(NodePath) onready var sprite = get_node(sprite) as Sprite
export(NodePath) onready var spawn = get_node(spawn) as Position2D
export(NodePath) onready var animation = get_node(animation) as AnimationPlayer

func move() -> void:
	if player.is_attacking:
		return
		
	velocity = get_direction() * walk_speek
	player.move_and_slide(velocity)
	
func get_direction() -> Vector2:
#	if Input.is_mouse_button_pressed(2):
		var dir = Vector2(
			Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
			(Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")) / 2
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
#		var mouse = player.get_global_mouse_position()
#		var play = player.global_position
#		var dir2 = (mouse - play).normalized()
#	else:
#		return Vector2.ZERO	
	#conferir se, divide por 2 o y no isometrico ou normaliza o total  
