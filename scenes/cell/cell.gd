extends Sprite2D

func get_adjacent_cells() -> Array[Area2D]:
	return $Area2D.get_overlapping_areas();
	
func get_adjacent_cells_number() -> int:
	return $Area2D.get_overlapping_areas().size();
	
