extends Node
tool

var name_node
var date_node
var no_node
var img_node
var msg_node
var filesUrl = "https://i.4cdn.org/vg/%s"
var http

func _init():
	pass

func _ready():
	pass

func drawImageJPG(result, response_code, headers, body):
	img_node = get_node("%img") as TextureRect
	var img = Image.new()
	img.load_jpg_from_buffer(body)
	var texture = ImageTexture.new()
	texture.create_from_image(img)
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
	msg_node.bbcode_text = msg
