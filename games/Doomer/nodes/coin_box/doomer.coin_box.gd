extends Node2D
class_name _Doomer_Coin_Box

@export var doomer : _Doomer
@export var container : CanvasItem
@export var viewport : SubViewport
@export var holder : _Doomer.Opponents:
	set(v):
		holder = v
		if is_node_ready():
			_on_holder_assignment()
		
@onready var coins : Node2D = find_child("Coins")
@onready var spawner : Area2D =  find_child("Spawner")



@onready var gravity_area : Area2D = find_children("Area2D Gravity")[0]
@onready var gravity_vector : Vector2:
	set(v):
		gravity_vector = v
		gravity_area.gravity_direction = gravity_vector
		
var spawn_point_randomness = Vector2(1300, 100)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_on_holder_assignment()
	add_coins(20)
	
func _on_holder_assignment():
	rotation = PI if holder == _Doomer.Opponents.Enemy else 0.0
	gravity_vector = Vector2(0, -1) if  holder == _Doomer.Opponents.Enemy else Vector2(0, 1)

func add_coins(count : int = 1):
	var coin : RigidBody2D
	
	var coin_batch = 2
	for batch_i in range(int(count/coin_batch)):
		for i in range(coin_batch):
			coin = _Doomer_Templates.coin_box_coin.instantiate()
			coin.visible = false
			coins.add_child(coin)
			coin.visible = true

			
			# print("cccc %f %f %f" % [spawner.global_position.x, spawner.global_position.y,  (randi() % spawn_point_randomness - (float(spawn_point_randomness)/2))] )
			coin.position = spawner.position 
			# coin.scale = Vector2(2,10)
			coin.position.x += (randi() % int(spawn_point_randomness.x) - (float(spawn_point_randomness.x)/2))
			
			# print("dddd %f %f %f" % [coin.global_position.x, coin.global_position.y,  (randi() % spawn_point_randomness - (float(spawn_point_randomness)/2))] )
			coin.position.y += (randi() % int(spawn_point_randomness.y) - (float(spawn_point_randomness.y)/2))
			# coin.sleeping = false
			
		await CommonFunctions.waiter(self, 0.01)
	
func _on_container_rect_changed():
	CommonFunctions.move_node_to_container(self, container)
