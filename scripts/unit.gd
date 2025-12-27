extends CharacterBody2D
class_name Unit

#var grid_coords: Vector2i;
var destination: Vector2i;
var path: Array[Vector2i]

var move_tween: Tween;


const speed: float = 200


#signal changed_grid_coords(from: Vector2i, to: Vector2i)
#signal ready_for_action

@onready var input_handler: InputHandler = $"../../InputHandler"
@onready var pathfinding: Pathfinding = $"../../Pathfinding"
@onready var movement: Movement = $Movement


func _ready() -> void:
	input_handler.tile_clicked.connect(_on_tile_clicked, CONNECT_DEFERRED)


#func _on_ready_for_action():
	#move_to_next_tile()
	
func _on_tile_clicked(tile: Vector2i):
	movement.set_destination(tile)
	
