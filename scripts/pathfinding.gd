extends Node2D
class_name Pathfinding

@export var cell_size: Vector2i = Vector2i(64, 64)
@export var grid_size: Vector2i = Vector2i(20, 15)

@onready var terrain: Node2D = $"../Terrain"
	
var astar_grid: AStarGrid2D

func _ready():
	astar_grid = AStarGrid2D.new()
	astar_grid.region = _get_grid_region()
	astar_grid.cell_size = cell_size
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_AT_LEAST_ONE_WALKABLE
	astar_grid.default_estimate_heuristic = AStarGrid2D.HEURISTIC_OCTILE
	astar_grid.update()


func _get_grid_region() -> Rect2i:
	var grid_rect := Rect2i()
	for tm_layer: TileMapLayer in terrain.get_children():
		grid_rect = grid_rect.merge(tm_layer.get_used_rect())
	print("grid_region = ", grid_rect)
	return grid_rect
	
	
## Sets a single tile walkable (true) or not walkable (false)
func set_tile_walkable(grid_pos: Vector2i, walkable: bool) -> void:
	astar_grid.set_point_solid(grid_pos, not walkable)
	astar_grid.update()

## Finds path from start to end and calls callback with result
## Path is array of world positions (Vector2)
func find_path(start_pos: Vector2i, end_pos: Vector2i, callback: Callable) -> void:
	var path = astar_grid.get_point_path(start_pos, end_pos)
	callback.call_deferred(path)
