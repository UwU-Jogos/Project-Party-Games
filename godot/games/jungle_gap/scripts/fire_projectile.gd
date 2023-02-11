extends Area2D
class_name FireProjectile

export(int) var distancia_perc = 0

var already_destroyed: bool = false

export(Vector2) var direction: Vector2 = Vector2.ZERO

export(int) var damage_base
export(int) var move_speed

export(PackedScene) var explosion_effect

func _process(delta) -> void:
	translate(direction * move_speed * delta)
	scale *= .98
	distancia_perc += 1

func kill() -> void:
	already_destroyed = true
	spawn_explosion()
	queue_free()

func on_screen_exited():
	if not already_destroyed:
		kill()

func on_body_entered(body):
	kill()

func spawn_explosion() -> void:
	var explosion = explosion_effect.instance()
	get_tree().root.call_deferred("add_child", explosion)
	explosion.global_position = global_position
