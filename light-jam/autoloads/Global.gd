extends Node

var latest_score: int = 0
var high_score: int = 0

func save_score(new_score: int) -> void:
	latest_score = new_score
	
	if latest_score > high_score:
		high_score = latest_score
	
	SaveHandler.save_key("latest_score", latest_score)
	SaveHandler.save_key("high_score", high_score)
