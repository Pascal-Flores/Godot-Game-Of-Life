extends Node2D

const cell_scene : Resource = preload("res://scenes/cell/cell.tscn");
const cell_size : int = 16;
@export_range(1,200, 1) var next_generation_frequency : float = 1;

var hover_cell : Node;
var is_paused : bool;

func _ready():
	hover_cell = cell_scene.instantiate();
	hover_cell.modulate.a = 0.5;
	hover_cell.get_node("Area2D").monitorable = false;
	add_child(hover_cell, false, Node.INTERNAL_MODE_FRONT);
	is_paused = true;
	Engine.physics_ticks_per_second = next_generation_frequency;

func _process(delta):
	var snapped_mouse_position : Vector2i = snap_to_grid(get_global_mouse_position());
	hover_cell.position = snapped_mouse_position;
	
	if Input.is_action_just_pressed("start_pause"):
		is_paused = not is_paused;

	if Input.is_action_just_pressed("click"):
		if not get_children().any(func(cell): return Vector2i(cell.position) == snapped_mouse_position):
			var cell = cell_scene.instantiate();
			cell.position = snapped_mouse_position;
			add_child(cell);

func _physics_process(delta):
	if not is_paused:
		next_cell_generation();

func snap_to_grid(position : Vector2i) -> Vector2i:
	return Vector2(position.x - posmod(position.x, cell_size), position.y - posmod(position.y, cell_size));
	
func next_cell_generation():
	var possible_new_cells_positions : Dictionary = {};
	var new_cells : Array = [];
	var dead_cells : Array = [];
	for cell in get_children():
		add_possible_new_cells(cell, possible_new_cells_positions);
		if not (cell.get_adjacent_cells_number() == 2 or cell.get_adjacent_cells_number() == 3):
			dead_cells.append(cell);
	new_cells = create_new_cells(possible_new_cells_positions);
	for new_cell in new_cells:
		add_child(new_cell);
	for dead_cell in dead_cells:
		dead_cell.queue_free();

func add_possible_new_cells(cell: Node2D, possible_new_cells_positions : Dictionary):
	var offsets : Array[Vector2] = [
		Vector2(-cell_size, -cell_size),	Vector2(0, -cell_size),		Vector2(cell_size, -cell_size),
		Vector2(-cell_size, 0),											Vector2(cell_size, 0),
		Vector2(-cell_size, cell_size), 	Vector2(0, cell_size),		Vector2(cell_size, cell_size)
	]
	
	var cell_neighbours : Array[Area2D] = cell.get_adjacent_cells();
	for cell_neighbour in cell_neighbours:
		offsets.erase(cell_neighbour.global_position - cell.global_position);
		
	var offset_position : Vector2;
	for offset in offsets:
		offset_position = cell.global_position + offset;
		if not possible_new_cells_positions.has(offset_position):
			possible_new_cells_positions[offset_position] = 1;
		else:
			possible_new_cells_positions[offset_position] += 1;

func create_new_cells(possible_new_cells_positions : Dictionary):
	var new_cells : Array = [];
	for possible_new_cell_position in possible_new_cells_positions:
		if possible_new_cells_positions[possible_new_cell_position] == 3:
			var new_cell = cell_scene.instantiate();
			new_cell.position = possible_new_cell_position;
			new_cells.append(new_cell);
	return new_cells;
