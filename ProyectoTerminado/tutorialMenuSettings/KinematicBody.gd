extends KinematicBody

onready var camera = $Pivot/Camera

var gravity = -30
var max_speed = 8
var mouse_sensitivity = 0.002  # radians/pixel

var velocity = Vector3()


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	GlobalSettings.connect("mouse_sens_updated", self ,"_on_mouse_sens_updated")

func _on_mouse_sens_updated(value):
	print(mouse_sensitivity)
	mouse_sensitivity = value


func get_input():
	var input_dir = Vector3()
	# desired move in camera direction
	if Input.is_action_pressed("ui_up"):
		input_dir += -global_transform.basis.z
	if Input.is_action_pressed("ui_down"):
		input_dir += global_transform.basis.z
	if Input.is_action_pressed("ui_left"):
		input_dir += -global_transform.basis.x
	if Input.is_action_pressed("ui_right"):
		input_dir += global_transform.basis.x
	input_dir = input_dir.normalized()
	return input_dir
	
func _unhandled_input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		$Pivot.rotate_x(-event.relative.y * mouse_sensitivity)
		$Pivot.rotation.x = clamp($Pivot.rotation.x, -1.2, 1.2)

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_select"):
		get_node("../SettingsMenu").popup()
		get_tree().paused=true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _physics_process(delta):
	velocity.y += gravity * delta
	var desired_velocity = get_input() * max_speed

	velocity.x = desired_velocity.x
	velocity.z = desired_velocity.z
	velocity = move_and_slide(velocity, Vector3.UP, true)
