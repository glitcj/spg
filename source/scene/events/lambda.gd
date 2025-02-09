extends EventBase
class_name LambdaEvent

var callable: Callable
var variables: Array
var clean_up_signal = null


# Note: Lambdas are not suitable for adding nodes
# If a node is to be added, use add_node in a lambda ?
func initialise(callable_: Callable, variables_: Array, clean_up_signal_  = null) -> LambdaEvent:
	callable = callable_
	variables = variables_
	clean_up_signal = clean_up_signal_
	return self

func run():
	var unpacked_variables = []
	for v in variables:
		if v is Variables.Retriever:
			unpacked_variables.append(v.get_variable())
		else:
			unpacked_variables.append(v)
	# callable.callv(unpacked_variables)
	await callable.callv(unpacked_variables)
	
	"""
	var call_return: Node = callable.callv(unpacked_variables)
	
	# if call_return.autoplay_finished != null:
	if call_return is _Knews_AutoQuizAnswers:
		print(call_return.get_parent().name)
		print("6666")
		add_child(call_return)
		await call_return.autoplay_finished
	"""
	
	_clean_up()

func _event_type():
	return "LambdaEvent"

func print_event():
	pass
