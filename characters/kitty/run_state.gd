extends NodeState

@export var player: Player
@export var animation_player: AnimationPlayer
@onready var progress_bar: TextureProgressBar = $"../../blueProgressBar"


func _on_process(_delta : float) -> void:
	pass


func _on_physics_process(_delta : float) -> void:
	var direction: Vector2 = GameInputEvents.movement_input()
	
	#Player Animation
	if direction == Vector2.LEFT or direction == Vector2.UP:
		animation_player.play("run")
		$"../../Sprite2D".flip_h = true
	elif direction == Vector2.RIGHT or direction == Vector2.DOWN:
		animation_player.play("run")
		$"../../Sprite2D".flip_h = false
	
	
	#Storing player directional data to a variable on Player
	if direction != Vector2.ZERO: 
		player.player_direction = direction
	
	# Preferred metihod but bugged due to "not within scope"
	#player.velocity = move_toward(velocity.x, speed * direction.x, accel)
	#player.velocity = move_toward(velocity.y, speed * direction.y, accel)
	
	#player.velocity = direction * speed
	#player.move_and_slide()


func _on_next_transitions() -> void:	
	if !GameInputEvents.is_movement_input() or GlobalTrackingValues.game_over or GlobalTrackingValues.game_paused:
		transition.emit("idle")
		
	if !player.can_sprint or !GameInputEvents.is_sprinting():
		transition.emit("walk")
	
	elif Input.is_action_just_pressed("jump"):
		transition.emit("jump")

func _on_enter() -> void:
	player.movement_state = true #entering a movement state
	player.running = true #entering a running state
	progress_bar.visible = true
	progress_bar.modulate.a = 1.0


func _on_exit() -> void:
	animation_player.stop()
	player.movement_state = false #exiting a movement state
	player.running = false #exiting a running state
	player.velocity = Vector2.ZERO
	progress_bar.modulate.a = 0.75