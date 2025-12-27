extends Node2D

class_name InputHandler

signal tile_clicked(Vector2i)


func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var mouse_pos = get_global_mouse_position()  # World coordinates
		var grid_tile = Functions.position_to_grid_coords(mouse_pos)  # Your existing function
		print("Clicked tile: ", grid_tile)
		tile_clicked.emit(grid_tile)
