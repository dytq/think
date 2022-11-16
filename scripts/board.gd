extends Sprite2D

var bitmap : BitMap
var image : ImageTexture

var cache : Array
const MAX_ARRAY_CACHE : int = 100

const BUTTON_PRESSED = true
const BUTTON_RELEASED = false
var button_status = BUTTON_RELEASED

var pad : float = 0.0 	# padding to interpolate (accurate) 2 points receive from mouse 
var accuracy = 100 		# number of points between 2 points
var accuracy_pad = 0.01

const SIZE_SCREEN = Vector2(1152,648)


func _ready():
	image = ImageTexture.new()
	bitmap = BitMap.new()
	bitmap.create(Vector2(SIZE_SCREEN.x,SIZE_SCREEN.y))
	self.texture = image.create_from_image(bitmap.convert_to_image())
	self.position.x = SIZE_SCREEN.x / 2
	self.position.y = SIZE_SCREEN.y / 2

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				button_status = BUTTON_PRESSED
			if event.pressed == false:
				button_status = BUTTON_RELEASED
				update_display()
				cache.clear()

func update_display():
	for i in range(0, cache.size()):
		if(cache[i].x > 0 and cache[i].y > 0 and cache[i].x < SIZE_SCREEN.x and cache[i].y < SIZE_SCREEN.y):
			bitmap.set_bit(cache[i].x, cache[i].y, true)
	self.texture = image.create_from_image(bitmap.convert_to_image())

func _process(delta):
	var size_cache = cache.size()
	
	if button_status:
		var current_path_position = get_viewport().get_mouse_position()
		cache.append(current_path_position)
		
		size_cache = cache.size()
		
		if(size_cache > 1):
			var ancient_path_position = cache[size_cache - 2]
			var distance = current_path_position.distance_to(ancient_path_position)
			
			for _i in range(0, accuracy * distance * delta):
				pad += (accuracy_pad/(distance * delta))
				cache.append(ancient_path_position.lerp(current_path_position,pad))
			pad = 0
			
			update_display()

	if(size_cache > MAX_ARRAY_CACHE):
		var last_element = cache[size_cache -1]
		cache.clear()
		cache.append(last_element) 
