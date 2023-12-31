extends AnimatedSprite2D

var player_in_range = false
var should_highlight = false
@export var max_health = 10
var health = max_health
var should_disappear = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.dd
func _process(delta):
	var tween = get_tree().create_tween()
	tween.tween_property(sprite_frames, "modulate", Color(255,255,255,0), 4)
	



func _on_area_2d_mouse_entered():
	print("mouse entered")
	if player_in_range:
		RenderingServer.global_shader_parameter_set("color", Color(1,1,0,1))
		should_highlight = false
	else:
		should_highlight = true



func _on_area_2d_mouse_exited():
	print("mouse exited")
	RenderingServer.global_shader_parameter_set("color", Color(1,1,0,0))


func _on_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT and player_in_range:
		print("clicked tree")
		animation = "cut"
		
		health -= $"../CharacterBody2D".damage
		set_frame_and_progress(((max_health - health) / $"../CharacterBody2D".damage) - 1, 0)
		if health <= 0:
			# disable the shader
			RenderingServer.global_shader_parameter_set("color", Color(1,1,0,0))
			# increase the speed of the animation
			speed_scale = 3
			# disable animation looping
			sprite_frames.set_animation_loop("fall", false)
			# allow the tree to fall
			await play("fall")
			should_disappear = true
			$"../CharacterBody2D".inventory.append("wood")
			print($"../CharacterBody2D".inventory)
		print(self.health)



func _on_area_2d_area_entered(area):
	if area == $"../CharacterBody2D/InteractableArea":
		player_in_range = true
		
		# TODO
		# find a way to check if the mouse is in the tree's collision box
		if should_highlight:
			RenderingServer.global_shader_parameter_set("color", Color(1,1,0,1))

		
		print("Player in range: ", player_in_range)


func _on_area_2d_area_exited(area):
	if area == $"../CharacterBody2D/InteractableArea":
		player_in_range = false
		print("Player in range: ", player_in_range)
		RenderingServer.global_shader_parameter_set("color", Color(1,1,0,0))
