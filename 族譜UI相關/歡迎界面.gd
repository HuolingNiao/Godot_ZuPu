extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.


func _on_ex_pressed() -> void:
	get_tree().quit()


func _on_con_2_pressed() -> void:
	SJSD_Only.加載數據信息()
	get_tree().change_scene_to_file("res://数据库/分支樹管理系統.tscn")
	pass # Replace with function body.


func _on_new_pressed() -> void:
	get_tree().change_scene_to_file("res://族譜UI相關/引導介面/引導.tscn")
	pass # Replace with function body.


func _on_con_pressed() -> void:
	SJSD_Only.加載數據信息()
	get_tree().change_scene_to_file("res://族譜UI相關/主編輯界面.tscn")
	pass # Replace with function body.
