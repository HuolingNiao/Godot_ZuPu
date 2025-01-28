extends Control

var sjk = null  # Reference to your database instance

func _ready():
	sjk = SJK.new()# Get the singleton instance

func 新建族譜():
	var file_dialog = FileDialog.new()
	add_child(file_dialog)
	
	file_dialog.access = FileDialog.ACCESS_FILESYSTEM
	file_dialog.file_mode = FileDialog.FILE_MODE_SAVE_FILE
	file_dialog.filters = ["*.bin ; Binary Files"]
	
	file_dialog.title = "選擇新族譜保存位置"
	file_dialog.current_path = "族譜.bin"
	
	file_dialog.size = Vector2(700, 500)
	file_dialog.popup_centered()
	
	file_dialog.file_selected.connect(func(path):
		sjk.database_file = path
		sjk.data = {}  # Clear existing data
		sjk.保存數據库()
		file_dialog.queue_free()
	)

func 載入族譜():
	var file_dialog = FileDialog.new()
	add_child(file_dialog)
	
	file_dialog.access = FileDialog.ACCESS_FILESYSTEM
	file_dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	file_dialog.filters = ["*.bin ; Binary Files"]
	
	file_dialog.title = "選擇族譜文件"
	file_dialog.size = Vector2(700, 500)
	file_dialog.popup_centered()
	
	file_dialog.file_selected.connect(func(path):
		sjk.database_file = path
		sjk.加载数据库()
		file_dialog.queue_free()
	)

func 導出數據():
	pass  # To be implemented later

func 導出pdf():
	pass  # To be implemented later

func 返回主菜單():
	get_tree().change_scene_to_file("res://族譜UI相關/歡迎界面.tscn")

func 退出():
	get_tree().quit()


func _on_文件排版_pressed() -> void:
	get_tree().change_scene_to_file("res://族譜UI相關/主編輯界面.tscn")
	pass # Replace with function bod"res://族譜UI相關/主編輯界面.tscn"y.
