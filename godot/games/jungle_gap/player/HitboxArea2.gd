extends Area2D
class_name HitBoxArea2

export(NodePath) onready var player2 = get_node(player2) as KinematicBody2D

func _on_HitboxArea_area_entered(area):
	var area_name = area.get_name()
	print(area_name)
	if area_name == "Fire":
		if area.distancia_perc < 12:
			player2.move_and_slide(area.direction * 7000)
		elif area.distancia_perc > 12 and area.distancia_perc < 22:
			player2.move_and_slide(area.direction * 5500)
		elif area.distancia_perc > 22 and area.distancia_perc < 32:
			player2.move_and_slide(area.direction * 3500)
		else:
			player2.move_and_slide(area.direction * 2000)
