extends Node
class_name CommonFunctions



static func get_first_input_event_name(event: InputEvent):
	if event.is_action_pressed("ui_up"):
		return "ui_up"
	elif event.is_action_pressed("ui_down"):
		return "ui_down"
	elif event.is_action_pressed("ui_left"):
		return "ui_left"
	elif event.is_action_pressed("ui_right"):
		return "ui_right"
	return null
	

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


static func sum_array(a):
	var sum = 0
	for i in a:
		sum = sum + i

	return sum
	
static func ranged_array(start: int, end: int, increment: int):
	var array := []
	var counter := start
	assert(end>start)
	while true:
		array.append(counter)
		counter = counter + increment
		if counter >= end:
			break

# This function is a special case where CommonFunctions needs
# to get instantiated CommonFunctions.waiter(self, time)
static func waiter(timer_parent: Node, time: float = 1):
		var wait_timer = timer_parent.get_tree().create_timer(time)
		await wait_timer.timeout

static func prepend(prepended_from: Array, prepended_to: Array):
		while prepended_from.size() > 0:
			prepended_to.insert(0, prepended_from.pop_back())
