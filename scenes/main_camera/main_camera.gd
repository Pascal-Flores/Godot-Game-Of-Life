extends Camera2D

const zoom_factor : float = 1.1;
const drag_speed : float = 150;
const max_zoom : Vector2 = Vector2(10,10);

var drag_origin : Vector2;
var shift_amount : Vector2;

func _process(delta):
	if Input.is_action_just_released("zoom_in"):
		zoom = clamp(zoom * zoom_factor, Vector2.ZERO, max_zoom);
	elif Input.is_action_just_released("zoom_out"):
		zoom /= zoom_factor;
		
	if Input.is_action_just_pressed("move_around"):
		drag_origin = get_viewport().get_mouse_position();
	elif Input.is_action_pressed("move_around"):
		shift_amount = (get_viewport().get_mouse_position() - drag_origin) * drag_speed * delta * -1 / zoom;
		translate(shift_amount);
		drag_origin = get_viewport().get_mouse_position();

