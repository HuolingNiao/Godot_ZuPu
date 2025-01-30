extends Node2D
var 歡迎詞 = [
	"歡迎使用軒轅族譜管理系統",
	"在開始之前需要您耐心的填寫相關信息",
	"首先請輸入您想要編輯家族的姓氏",
	"您可知道此家族的字輩排序\n若你知曉請填入下方務必不要加標點符號！",
	"您若不知曉字輩排序請留空",
	"請確認你的族譜信息"
]
var 當前id = 0
var 姓氏 = ""
var 字輩 = ""
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Label.text = 歡迎詞[當前id]
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	
	if 當前id < 歡迎詞.size()-1:
		當前id += 1
		$Label.text = 歡迎詞[當前id]
		引導檢測()
	else:
		if 姓氏 == "":
			當前id = 1
			$Label.text = "您貌似沒有輸入姓氏呢"
		else:
			SJSD_Only.姓氏 = 姓氏
			SJSD_Only.字輩 = 字輩
			SJSD_Only.初始化(姓氏)
			SJSD_Only.儲存書籍信息()
			SJSD_Only.成員.data={}
			SJSD_Only.成員.保存数据库()
			get_tree().change_scene_to_file("res://数据库/分支樹管理系統.tscn")
		
	pass # Replace with function body.

func 引導檢測():
	姓氏 = $VBoxContainer/HBoxContainer/LineEdit.text
	字輩 = $VBoxContainer/HBoxContainer2/TextEdit.text	
