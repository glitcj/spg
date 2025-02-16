extends Node
class_name CommonFunctions


static func zeros_row(n: int):
	var array := []
	for i in range(n):
		array.append(0)
	return array


static func zeros_2D_array(n: int, m: int):
	var array := []
	for j in range(n):
		var row := []
		for i in range(m):
			row.append(0)
		array.append(row)
	return array


static func nulls_2D_map(n: int, m: int):
	var map := {}
	for j in range(n):
		var row := {}
		for i in range(m):
			row[i] = null
		map[j] = row
	return map
