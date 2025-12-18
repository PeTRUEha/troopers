extends Node


func position_to_grid_coords(position: Vector2) -> Vector2i:
	return Vector2i(
		roundi((position.x - Constants.TILE_SIZE / 2.) / Constants.TILE_SIZE),
		roundi((position.y - Constants.TILE_SIZE / 2.) / Constants.TILE_SIZE) 
	)

func grid_coords_to_position(grid_coords: Vector2i) -> Vector2:
	return Vector2(
		grid_coords.x * Constants.TILE_SIZE + Constants.TILE_SIZE / 2.0,
		grid_coords.y * Constants.TILE_SIZE + Constants.TILE_SIZE / 2.0
	)
