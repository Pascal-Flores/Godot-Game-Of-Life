extends Camera2D

const zoom_factor = 1.1;
const drag_speed = 10;
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_released("zoom_in"):
		zoom *= zoom_factor;
	elif Input.is_action_just_released("zoom_out"):
		zoom /= zoom_factor;
	print(zoom)
