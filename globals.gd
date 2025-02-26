# globals.gd
extends Node

var current_scene_number: int = 1
var data: Dictionary = {}
var void_area: Array = []

func _ready():
	for i in range(11):
		var row = []
		for j in range(5):
			row.append(1)
		void_area.append(row)
