extends CharacterBody2D
class_name Unit

var grid_coords: Vector2i;

signal changed_grid_coords(from: Vector2i, to: Vector2i)

func _ready() -> void:
	snap_to_tile()


func _on_changed_grid_coords(_from: Vector2, to: Vector2) -> void:
	position = Functions.grid_coords_to_position(to)


func snap_to_tile():
	print(position)
	grid_coords = Functions.position_to_grid_coords(position)
	position = Functions.grid_coords_to_position(grid_coords)
	print(grid_coords)
	
	
