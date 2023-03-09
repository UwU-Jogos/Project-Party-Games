extends Node2D
class_name BoardPlayer

signal do_action
signal changed_hp

onready var animation: Tween = $Tween
onready var camera: Camera2D = $Camera2D

export var nick: String = ""
export var speed := 200

var actual_tile: Tile = null setget set_actual_tile
var deck := Deck.new()
var score := Score.new()
var max_hp := 30
var hp := max_hp setget set_hp
var dead = false
var initial_scale = self.scale
# TODO:
# find a way to organize this if necessary
# I don't know if it is a good ideia to the player have the graph
# reference inside it. Maybe we should do this with an autoload event?
var graph = null


func set_hp(new_hp):
	yield(get_tree(), "idle_frame")
	if new_hp <= 0:
		hp = 0
		yield(self.die(), "completed")
	elif new_hp >= max_hp:
		hp = max_hp
	else:
		hp = new_hp
	emit_signal("changed_hp", hp)


func get_camera() -> Camera2D:
	return camera


func set_actual_tile(new_tile: Tile):
	if actual_tile == null:
		self.position = new_tile.position
		actual_tile = new_tile
	elif new_tile == null:
		actual_tile = actual_tile
	else:
		actual_tile = new_tile


func move():
	var next_tile = yield(actual_tile.get_next_tile(), "completed") as Tile
	yield(move_to_tile(next_tile), "completed")


func move_to_tile(new_tile: Tile):
	var new_position = new_tile.position
	var old_position = actual_tile.position

#	var distance := new_tile.position.distance_to(actual_tile.position)
#	var duration := distance / self.speed

	var path = self.graph.get_path_node(actual_tile, new_tile) as Path2D
	var curve = path.curve.tessellate()

	for point in curve:
		var distance := self.position.distance_to(point)
		var duration := distance / self.speed
		animation.interpolate_property(
			self, "position", self.position, point, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
		)
		animation.start()
		yield(animation, "tween_completed")
	yield(get_tree(), "idle_frame")
	set_actual_tile(new_tile)


func play_pre_turn(board):
	yield(self.actual_tile.play_pre_turn_effect(board, self), "completed")


func play_turn(board):
	for card in deck.hand:
		if self.dead:
			break
		yield(self, "do_action")
		yield(card.play_effect(board, self), "completed")
	deck.reset_hand()


func die():
	self.dead = true
	var nearest_graveyard = self.graph.bfs(actual_tile, funcref(Tile, "is_graveyard"))
	yield(animate_dead(), "completed")
	self.position = nearest_graveyard.position
	self.actual_tile = nearest_graveyard
	yield(animate_restore(), "completed")


func restore():
	self.hp = max_hp
	self.dead = false
	yield(animate_scale(), "completed")


func _input(event):
	if event.is_action_pressed("ui_accept") and not event.is_echo():
		emit_signal("do_action")


func animate_dead():
	animation.interpolate_property(self, "scale", scale, Vector2.ZERO, 0.5)
	animation.start()
	yield(animation, "tween_completed")


func animate_restore():
	animation.interpolate_property(self, "scale", scale, initial_scale, 0.5)
	animation.start()
	yield(animation, "tween_completed")


func animate_scale():
	animation.interpolate_property(self, "scale", scale, scale * 2, 0.5)
	animation.start()
	yield(animation, "tween_completed")
	animation.interpolate_property(self, "scale", scale, scale / 2, 0.5)
	animation.start()
	yield(animation, "tween_completed")


func animate_rotation():
	animation.interpolate_property(
		self, "rotation_degrees", rotation_degrees, rotation_degrees + 360, 1
	)
	animation.start()
	yield(animation, "tween_completed")
