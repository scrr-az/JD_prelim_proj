extends Node

const TURN_SPEED: float = 3.4
const THRUST: float = 420.0
const DRAG: float = 0.35
const MARGIN: float = 46.0
const ROCKS: int = 8

var ship: Node2D
var velocity: Vector2 = Vector2(230, -160)
var rocks: Array[Node2D] = []
var drifts: Array[Vector2] = []
var spins: Array[float] = []
var view: Vector2


func _ready() -> void:
	_add_background()

	view = get_viewport().get_visible_rect().size

	for i in ROCKS:
		var rock: Node2D = Node2D.new()
		rock.position = Vector2(randf_range(0, view.x), randf_range(0, view.y))
		rock.add_child(_make_rock(randf_range(18, 40)))
		add_child(rock)

		rocks.append(rock)
		drifts.append(Vector2(randf_range(-160, 160), randf_range(-160, 160)))
		spins.append(randf_range(-1.2, 1.2))

	ship = Node2D.new()
	ship.position = view * 0.5
	ship.add_child(_make_ship())
	add_child(ship)

	_add_label('left and right to turn, up to thrust, everything leaves one edge and returns on the other', Vector2(40, 40))

	print('arrow keys to fly, the ship wraps around the screen')


func _process(delta: float) -> void:
	ship.rotation += Input.get_axis('ui_left', 'ui_right') * TURN_SPEED * delta

	if Input.is_action_pressed('ui_up'):
		velocity += Vector2.RIGHT.rotated(ship.rotation) * THRUST * delta

	velocity = velocity.lerp(Vector2.ZERO, DRAG * delta)
	ship.position = _wrap(ship.position + velocity * delta)

	for i in rocks.size():
		rocks[i].position = _wrap(rocks[i].position + drifts[i] * delta)
		rocks[i].rotation += spins[i] * delta


func _wrap(at: Vector2) -> Vector2:
	return Vector2(wrapf(at.x, -MARGIN, view.x + MARGIN), wrapf(at.y, -MARGIN, view.y + MARGIN))


func _make_ship() -> Polygon2D:
	var ship_body: Polygon2D = Polygon2D.new()
	ship_body.polygon = PackedVector2Array([Vector2(30, 0), Vector2(-18, -17), Vector2(-9, 0), Vector2(-18, 17)])
	ship_body.color = Color('#8da5f3')

	return ship_body


func _make_rock(radius: float) -> Polygon2D:
	var points: PackedVector2Array = PackedVector2Array()

	for i in 9:
		var angle: float = TAU * i / 9.0
		points.append(Vector2(cos(angle), sin(angle)) * radius * randf_range(0.7, 1.2))

	var rock: Polygon2D = Polygon2D.new()
	rock.polygon = points
	rock.color = Color('#2a2f3d').lerp(Color('#8da5f3'), 0.22)

	return rock


func _add_label(text: String, at: Vector2) -> void:
	var label: Label = Label.new()
	label.text = text
	label.position = at
	label.add_theme_color_override('font_color', Color('#999999'))
	label.add_theme_font_size_override('font_size', 20)
	add_child(label)


func _add_background() -> void:
	var background: ColorRect = ColorRect.new()
	background.color = Color('#12141a')
	add_child(background)
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
