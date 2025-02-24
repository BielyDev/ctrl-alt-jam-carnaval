extends CanvasLayer

signal timeout()

@export var add_color: Color = Color.WEB_GREEN
@export var remove_color: Color = Color.WEB_MAROON

@export var time: float

const TIME_TEMPLATE: String = "%02d:%02d"

func _ready():
	$Timer.start(time)
	$Timer.timeout.connect(func(): timeout.emit())

func _process(_delta):
	$Time_Tex/TimerLabel.text = _format_time($Timer.time_left)

func update(time_change: float):
	$Timer.start($Timer.time_left + time_change)
	
	var mini_label = _crate_mini_label(time_change)
	add_child(mini_label)
	await _fade_mini_label(mini_label)	

func _format_time(time_value):
	var minutes: float = time_value / 60
	var seconds: float = fmod(time_value, 60)
	return TIME_TEMPLATE % [minutes, seconds]

func _crate_mini_label(time_change: float):
	var color = add_color if time_change > 0 else remove_color
	var mini_label = Label.new()
	mini_label.text = _format_time(time_change)
	mini_label.position = $Time_Tex/TimerLabel.position
	mini_label.set("theme_override_colors/font_color", color)	
	return mini_label

func _fade_mini_label(mini_label):	
	const tween_time: float = 0.75
	var movement = Vector2(0, -200)
	var target_position = mini_label.position + movement
	var target_color: Color = Color(mini_label.get("theme_override_colors/font_color"))
	target_color.a = 0
	var tween = create_tween()
	tween.tween_property(mini_label, "position", target_position, tween_time)
	tween.parallel().tween_property(mini_label, "modulate", target_color, tween_time)
	tween.tween_callback(mini_label.queue_free)
