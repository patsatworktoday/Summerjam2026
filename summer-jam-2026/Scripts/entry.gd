extends Sprite2D


@export var animals:Array[String] = ["worm","sheep","raven","sloth","slug","penguin","priest"]
@export var attire:Array[String] = ["none","monocle","sunglasses"]

@export var movement_speed:float = 1000
@onready var animated_sprite = $Animal_sliding
@onready var attire_sprite = $Animal_sliding/Attire
@onready var Audio:AudioStreamPlayer2D = get_tree().get_first_node_in_group("Audio")
@onready var pusher:Sprite2D = get_tree().get_first_node_in_group("pusher") 
var pusher_scale
var score:float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pusher_scale = pusher.scale
	score = 0
	pass # Replace with function body.
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_animated_sprite_2d_get_new_animal() -> void:
	create_new_animal()
	
func create_new_animal():
	var animal:String = select_new_animal()
	var clothes:String = select_new_attire()
	play_animations(animal,clothes)


func select_new_animal() -> String:
	var random_number = randi_range(0,len(animals)-1)
	return animals[random_number]
	
func select_new_attire() -> String:
	var random_number = randi_range(0,len(attire)-1)
	return attire[random_number]
	
func play_animations(animal:String,clothes:String):
	#set the animations to play
	pusher.scale = pusher_scale
	animated_sprite.idle_string = animal+"_idle"
	animated_sprite.die_string = animal+"_die"
	if clothes != "none":
		attire_sprite.texture = load("res://Sprites/"+clothes+".png")
	else:
		attire_sprite.texture = null
	#reset booleans
	animated_sprite.global_position = self.global_position
	animated_sprite.falling = false
	animated_sprite.will_live = true
	animated_sprite.scale = animated_sprite.init_scale
	animated_sprite.play(animated_sprite.idle_string)
	animated_sprite.movement_speed = movement_speed
	#play launch sound
	Audio.play_track(3)
