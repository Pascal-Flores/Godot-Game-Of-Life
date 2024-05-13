extends Node2D

const cell_scene : Resource = preload("res://scenes/cell/cell.tscn");
const cell_size : int = 16;
@export_range(1, 1000, 1) var next_generation_frequency : float = 1;

var hover_cell : Node;
var is_paused : bool;

var alive_cells : Dictionary;

func _ready():
	hover_cell = cell_scene.instantiate();
	hover_cell.modulate.a = 0.5;
	hover_cell.get_node("Area2D").monitorable = false;
	add_child(hover_cell, false, Node.INTERNAL_MODE_FRONT);
	is_paused = true;
	Engine.physics_ticks_per_second = next_generation_frequency;
	alive_cells = {};

func _process(delta):
	var snapped_mouse_position : Vector2 = snap_to_grid(get_global_mouse_position());
	hover_cell.position = snapped_mouse_position;
	
	if Input.is_action_just_pressed("start_pause"):
		is_paused = not is_paused;

	if Input.is_action_just_pressed("click"):
		if not alive_cells.has(snapped_mouse_position):
			alive_cells[snapped_mouse_position] = true;
			
#	print(alive_cells);
	queue_redraw();


func _physics_process(delta):
	if not is_paused:
		next_cell_generation();
	
	
func _draw():
	for cell in alive_cells:
		draw_rect(Rect2(cell.x, cell.y, cell_size, cell_size), Color.WHITE);

func snap_to_grid(position : Vector2i) -> Vector2:
	return Vector2(position.x - posmod(position.x, cell_size), position.y - posmod(position.y, cell_size));
	
func next_cell_generation():
	var new_alive_cells = alive_cells.duplicate();
	var maybe_new_cells : Dictionary = {};
	var offsets : PackedVector2Array = [
		Vector2(-cell_size, -cell_size),	Vector2(0, -cell_size),	Vector2(cell_size, -cell_size),
		Vector2(-cell_size, 0), 									Vector2(cell_size, 0),
		Vector2(-cell_size, cell_size),		Vector2(0, cell_size), 	Vector2(cell_size, cell_size)
	]
	var offset_cell : Vector2;
	var adjacent_cells_number : int;
	
	for cell in alive_cells:
		adjacent_cells_number = 0;
		for offset in offsets:
			offset_cell = cell + offset;
			if offset_cell in alive_cells:
				adjacent_cells_number += 1;
			elif offset_cell in maybe_new_cells:
				maybe_new_cells[offset_cell] += 1;
			else:
				maybe_new_cells[offset_cell] = 1;

		if adjacent_cells_number < 2 or adjacent_cells_number > 3:
			new_alive_cells.erase(cell);
	for maybe_new_cell in maybe_new_cells:
		if maybe_new_cells[maybe_new_cell] == 3:
			new_alive_cells[maybe_new_cell] = true;
	alive_cells = new_alive_cells;
			
