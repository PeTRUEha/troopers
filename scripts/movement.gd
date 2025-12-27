extends Node2D
class_name Movement

@onready var host: Unit = $".."
@onready var sprite: AnimatedSprite2D = $"../AnimatedSprite2D"
@onready var pathfinding: Pathfinding = $"../../../Pathfinding"
var grid_coords: Vector2i;
var destination: Vector2i;
var path: Array[Vector2i]
var move_tween: Tween;

var is_moving: bool = false

const speed: float = 200

signal changed_grid_coords(from: Vector2i, to: Vector2i)
signal arrived_at_tile
signal no_destination


func _ready() -> void:
	print("Hello")
	snap_to_tile()


func snap_to_tile():
	grid_coords = Functions.position_to_grid_coords(host.position)
	host.position = Functions.grid_coords_to_position(grid_coords)

func move():
	is_moving = true
	while path:
		await _move_to_next_tile()
	sprite.play("idle")
	no_destination.emit()
	is_moving = false
	

func _move_to_next_tile():
	if not path:
		return
	var to: Vector2i = path.pop_front()
	changed_grid_coords.emit(grid_coords, to)
	pathfinding.set_tile_walkable(grid_coords, true)
	pathfinding.set_tile_walkable(to, false)
	print("running from ", grid_coords, " to ", to)
	grid_coords = to
	var new_position = Functions.grid_coords_to_position(to)
	await run_to(new_position)
	arrived_at_tile.emit()
	
	
func run_to(target_position: Vector2) -> void:
	sprite.play("run")
	var move_vector = host.position - target_position
	var duration := move_vector.length() / speed
	update_move_tween(target_position, duration)
	sprite.flip_h = move_vector.x > 0
	await move_tween.finished
	
	
func update_move_tween(target_position: Vector2, duration: float):
	_kill_tween()
	move_tween = create_tween()
	move_tween.set_trans(Tween.TRANS_LINEAR)
	move_tween.tween_property(host, "position", target_position, duration)
	
func _kill_tween():
	if move_tween and move_tween.is_running():
		move_tween.finished.emit()
		move_tween.kill()
	
func set_destination(destination_: Vector2i):
	destination = destination_
	pathfinding.request_path.call_deferred(grid_coords, destination, move_along_path)

func move_along_path(calculated_path: Array):
	path = calculated_path
	#print("got new path ", path)
	if not is_moving:
		move()
	
