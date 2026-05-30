extends AnimatedSprite2D

@export var movement_speed:float = 100
var will_live:bool 
var falling:bool
var has_child:bool
var init_scale:Vector2
var init_pusher_scale:Vector2
var idle_string:String = "sheep_idle"
var die_string = "sheep_die"


signal get_new_animal
signal blood_spatter


@onready var exit_point:Sprite2D = get_tree().get_first_node_in_group("Exit")
@onready var mulcher:Sprite2D = get_tree().get_first_node_in_group("mulcher")
@onready var pusher:Sprite2D = get_tree().get_first_node_in_group("pusher")
@onready var Audio:AudioStreamPlayer2D = get_tree().get_first_node_in_group("Audio")
@onready var Animal_Audio:AudioStreamPlayer2D = get_tree().get_first_node_in_group("Animal_Audio")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite_frames = sprite_frames.duplicate(true)
	self.visible = true
	play(idle_string)
	will_live = true
	init_scale = self.scale
	init_pusher_scale = pusher.scale
	falling = false
	has_child = false

	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if will_live == true:
		self.global_position.x += movement_speed*delta
	elif self.global_position.x != mulcher.global_position.x:
		if self.global_position.x > mulcher.global_position.x:
			self.global_position.x -= movement_speed*delta
			self.scale = self.scale * (1+(1 * delta))
			pusher.scale = pusher.scale * (1+(1 * delta))
		elif self.global_position.x < mulcher.global_position.x:
			self.global_position.x += movement_speed*delta
			self.scale = self.scale * (1+(1 * delta))
			pusher.scale = pusher.scale * (1+(1 * delta))
		pusher.scale = clamp(pusher.scale,Vector2(1,1),Vector2(5,5))
		self.scale = clamp(self.scale,init_scale,init_scale*2)
		
		
			
		
	if self.global_position.x > exit_point.global_position.x:
		animal_lived() 
			
	
	if Input.is_action_just_pressed("Reject_Animal"):
		if will_live == true:
			play(die_string)
			will_live = false
			Audio.play_track(0)
			
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
	_remove_animal()

func _remove_animal():
	get_new_animal.emit()
	
	
