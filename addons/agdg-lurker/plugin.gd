tool
extends EditorPlugin

var agdg_lurker = preload("res://addons/agdg-lurker/agdg-lurker-main.tscn").instance()
var postList

func _enter_tree():
	add_control_to_dock(DOCK_SLOT_RIGHT_UR, agdg_lurker)
	agdg_lurker.get_node("%refresh").connect("button_down",self,"refresh")
	agdg_lurker.get_node("%top").connect("button_down",self,"goTop")
	agdg_lurker.get_node("%bottom").connect("button_down",self,"goBottom")
	agdg_lurker.get_node("HTTPRequestCatalog").connect("request_completed",self,"onRequestCatalogCompleted")
	agdg_lurker.get_node("HTTPRequestThread").connect("request_completed",self,"onRequestThreadCompleted")

func _exit_tree():
	remove_control_from_docks(agdg_lurker)
	agdg_lurker.queue_free()

func goBottom():
	var scroll = agdg_lurker.get_node("ScrollContainer") as ScrollContainer
	var posts_container = agdg_lurker.get_node("%posts-container")
	scroll.scroll_vertical = posts_container.rect_size.y

func goTop():
	var scroll = agdg_lurker.get_node("ScrollContainer") as ScrollContainer
	scroll.scroll_vertical = 0

func refresh():
	agdg_lurker.get_node("HTTPRequestCatalog").request("https://a.4cdn.org/vg/catalog.json")
	var output = agdg_lurker.get_node("%output") as Label
	output.text = "refreshing..."

func onRequestCatalogCompleted(_result,_resCode,_headers,body):
	var linkTemplate = ["https://a.4cdn.org/vg/thread/",".json"]
	var json = JSON.parse(body.get_string_from_utf8())
	var fullLink = ""
	print("agdg-lurker requested catalog")
	for page in json.result:
		for thread in page.threads:
			if "/agdg/" in thread.sub:
				fullLink = linkTemplate[0] + str(thread.no) + linkTemplate[1]
				break

	print("agdg-lurker opening ",fullLink)

	agdg_lurker.get_node("HTTPRequestThread").request(fullLink)


func onRequestThreadCompleted(_result,_resCode,_headers,body):
	var json = JSON.parse(body.get_string_from_utf8())
	var posts_container = agdg_lurker.get_node("%posts-container")

	if posts_container.get_child_count() > 0 :
		for child in posts_container.get_children():
			posts_container.remove_child(child)
			child.queue_free()
	
	for p in json.result.posts:
		var post = preload("res://addons/agdg-lurker/agdg-post.tscn").instance()
		var msg = ""
		var filename = ""

		if "com" in p :
			msg = p.com
		
		if "filename" in p:
			filename = str(p.tim) +"s"
			filename += ".jpg"
		
		post.setPost(p.name,p.now, str(p.no) , msg,filename)
		posts_container.add_child(post)

	var output = agdg_lurker.get_node("%output") as Label
	output.text = json.result.posts[0].sub
	