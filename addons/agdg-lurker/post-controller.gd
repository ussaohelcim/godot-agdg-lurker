extends Node
tool

var name_node
var date_node
var no_node
var img_node
var msg_node
var filesUrl = "https://i.4cdn.org/vg/"
var http

func _init():
	pass

func _ready():
	pass

func drawImageJPG(result, response_code, headers, body):
	var image = Image.new()
	var error = image.load_jpg_from_buffer(body)
	if error != OK:
			push_error("Couldn't load the image.")
	var texture = ImageTexture.new()
	texture.create_from_image(image)
	img_node = get_node("%img") as TextureRect
	img_node.texture = texture

func setPost(name:String,date:String,num:String,msg:String,filename:String):
	name_node = get_node("%name") as Label
	date_node = get_node("%date") as Label 
	no_node = get_node("%no") as Label 
	
	msg_node = get_node("%txt") as RichTextLabel 

	name_node.text = name
	date_node.text = date
	no_node.text = num

	var regex = RegEx.new()
	regex.compile("<.*?>")

	var toRemove = regex.search_all(msg)

	msg = msg.replace("<br>","\n")

	for garbage in toRemove:
		msg = msg.replace(garbage.get_string(),"")

	msg = msg.replace("&gt;",">")
	msg = msg.replace("&#039;","'")

	# var lines = msg.split("\n")
	# var full = ""

	# for line in lines:
	# 	var before = ""
	# 	var after = ""

	# 	if line[0] == ">" and line[1] == ">":
	# 		before = "color"
	# 		after = "color"

	# 	full += before + line + after + "\n"

	# if filename.length() > 0:
	# 	var http = HTTPRequest.new()
	# 	add_child(http)
	# 	http.connect("request_completed",self,"drawImageJPG")
	# 	var file = "https://i.4cdn.org/vg/" + filename
	# 	http.request(file)

	msg_node.bbcode_text = msg
