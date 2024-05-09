extends Sprite2D

func get_neighbours() -> Array[Area2D]:
	return $Area2D.get_overlapping_areas();
	
func get_neighbours_number() -> int:
	return $Area2D.get_overlapping_areas().size();
	
