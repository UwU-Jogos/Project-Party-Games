extends Area2D
class_name HitBoxDragon

var on_hit: bool = false
var on_death: bool = false

export(int) var health

var max_health_value: int


export(NodePath) onready var health_bar = get_node(health_bar) as TextureProgress

func _ready():
	max_health_value = health
	health_bar.init_bar(health)

func on_area_entered(area):
	print(area.distancia_perc)
	if area.distancia_perc < 22:
		print("a")
		health -= 25
		health_bar.update_value(health)
	elif area.distancia_perc > 22 and area.distancia_perc < 38:
		print("b")
		health -= 15
		health_bar.update_value(health)
	else:
		print("c")
		health -= 5
		health_bar.update_value(health)
