extends CharacterBody3D

var speed = 0
const SPRINT_SPEED = 8.0
var WALK_SPEED = 5.0
const JUMP_VELOCITY = 4.5
const SENSITIVITY = 0.003
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var head = $head
@onready var camera = $head/Camera3D
@onready var player = $"."
@onready var crosshair = $crosshair
@onready var interactInfo = $interactInfo

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	randomize()
	interactInfo.modulate.a = 0
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		player.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-40), deg_to_rad(60))

func positionUI():
	crosshair.position.x = get_viewport().size.x / 2 - 11
	crosshair.position.y = get_viewport().size.y / 2 - 11
	interactInfo.position.x = get_viewport().size.x / 2 - 65
	interactInfo.position.y = get_viewport().size.y / 2 + 20

func _physics_process(delta):
	positionUI()
	if $head/Camera3D/RayCast3D.is_colliding():
		interactInfo.modulate.a = 1
	else:
		interactInfo.modulate.a = 0
	
	if Input.is_action_pressed("sprint"):
		speed = SPRINT_SPEED
	else:
		speed = WALK_SPEED
		
	if Input.is_action_just_pressed("interact") && $head/Camera3D/RayCast3D.is_colliding():
		print("good!")
	
	if not is_on_floor():
		velocity.y -= gravity * delta
		
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (player.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	move_and_slide()
		
		
