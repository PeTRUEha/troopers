extends CharacterBody2D
class_name Unit

var grid_coords: Vector2i;
var move_tween: Tween;

@onready var visuals: Visuals = $Visuals

const speed: float = 200


signal changed_grid_coords(from: Vector2i, to: Vector2i)
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	snap_to_tile()


func snap_to_tile():
	grid_coords = Functions.position_to_grid_coords(position)
	position = Functions.grid_coords_to_position(grid_coords)

	
func move_to_grid(to: Vector2i):
	changed_grid_coords.emit(grid_coords, to)
	var new_position = Functions.grid_coords_to_position(to)
	run_to(new_position)
	
	
func run_to(target_position: Vector2) -> void:
	# Cancel any previous tween on this node if needed
	var move_vector = position - target_position
	var duration := move_vector.length() / speed
	update_move_tween(target_position, duration)
	sprite.flip_h = move_vector.x > 0
	sprite.play("run")
	await move_tween.finished
	sprite.play("idle")
	
func update_move_tween(target_position: Vector2, duration: float):
	if move_tween and move_tween.is_running():
		move_tween.finished.emit()
		move_tween.kill()
	move_tween = create_tween()
	move_tween.set_trans(Tween.TRANS_LINEAR)
	move_tween.tween_property(self, "position", target_position, duration)
