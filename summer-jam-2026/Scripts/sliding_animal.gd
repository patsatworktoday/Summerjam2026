extends AnimatedSprite2D

@export var movement_speed:float = 100
@export var animal_sfx:Dictionary[String,AudioStream]
@export var stinger_sfx:Dictionary[String,AudioStream]
var will_live:bool 
var falling:bool
var has_child:bool
var init_scale:Vector2
var init_pusher_scale:Vector2
var idle_string:String = "sheep_idle"
var die_string = "sheep_die"
var animal_string:String = "sheep"
var animal_frames:Dictionary[String,int] = {"worm":5,"sheep":5,"raven":5,"sloth":5,"slug":5,"penguin":5,"priest":65}
@export var reject_clothes:Array[String] = ["monocle","sunglasses"]
@export var accept_clothes:Array[String] = ["none"]
var animal_score:float
var clothes_string:String

signal get_new_animal
signal blood_spatter
signal increment_animal_score


@onready var exit_point:Sprite2D = get_tree().get_first_node_in_group("Exit")
@onready var mulcher:AnimatedSprite2D = get_tree().get_first_node_in_group("mulcher")
@onready var pusher:Sprite2D = get_tree().get_first_node_in_group("pusher")
@onready var score_label:Label = get_tree().get_first_node_in_group("ScoreLabel")
@onready var Audio:AudioStreamPlayer2D = get_tree().get_first_node_in_group("Audio")
@onready var stingers:AudioStreamPlayer2D = get_tree().get_first_node_in_group("Stingers")
@onready var Animal_Audio:AudioStreamPlayer2D = get_tree().get_first_node_in_group("Animal_Audio")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animal_score = 0
	SystemGlobal.animal_score = 0
	clothes_string = "sunglasses"
	sprite_frames = sprite_frames.duplicate(true)
	self.visible = true
	play(idle_string)
	will_live = true
	init_scale = self.scale
	init_pusher_scale = pusher.scale
	falling = false
	has_child = false
	score_label.text = "Score: 0"
	#_remove_animal()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if will_live == true:
		self.global_position.x += movement_speed*delta
	elif self.global_position.x != mulcher.global_position.x-50:
		if self.global_position.x > mulcher.global_position.x-50:
			self.global_position.x -= movement_speed*delta
			self.scale = self.scale * (1+(1 * delta))
			pusher.scale = pusher.scale * (1+(1 * delta))
		elif self.global_position.x < mulcher.global_position.x-50:
			self.global_position.x += movement_speed*delta
			self.scale = self.scale * (1+(1 * delta))
			pusher.scale = pusher.scale * (1+(1 * delta))
		pusher.scale = clamp(pusher.scale,Vector2(1,1),Vector2(5,5))
		self.scale = clamp(self.scale,init_scale,init_scale*2)
		
		
			
		
	if self.global_position.x > exit_point.global_position.x:
		animal_lived() 
			
	
	if Input.is_action_just_pressed("Reject_Animal"):
		if will_live == true:
			print_debug(clothes_string)
			if clothes_string in reject_clothes:
				increment_score()
				_play_stinger_sfx("accept")
			else:
				_play_stinger_sfx("reject")
			play(die_string)
			will_live = false
			Audio.play_track(0)
			#_play_animal_sfx("falling")
			await self.animation_finished
			Audio.play_track(1)
			blood_spatter.emit()
			
			falling = true
			
	
	if falling == true:
		pusher.scale = pusher.scale * (1-(1 * delta))
		pusher.scale = clamp(pusher.scale,init_pusher_scale,Vector2(5,5))
		blood_spatter.emit()
		self.global_position.y += movement_speed
		self.global_position.x = mulcher.global_position.x
		if self.global_position.y > 1200:
			if not Audio.is_playing():
				_remove_animal()
				
	
	
	
func animal_lived():
	if clothes_string in accept_clothes:
		increment_score()
		_play_stinger_sfx("accept")
	else:
		_play_stinger_sfx("reject")
	_remove_animal()

func _remove_animal():
	get_new_animal.emit()
	
func _play_animal_sfx(animal:String):
	if not Animal_Audio.is_playing():
		Animal_Audio.stream = animal_sfx[animal]
		Animal_Audio.play()
		
func _play_stinger_sfx(stinger:String):
	if not stingers.is_playing():
		stingers.stream = stinger_sfx[stinger]
		stingers.play()
	
func increment_score():
	animal_score += 1
	score_label.text = "Score: " + str(animal_score)
	SystemGlobal.animal_score +=1

func _on_frame_changed() -> void:
	if frame == animal_frames[animal_string]:
		_play_animal_sfx(animal_string)
