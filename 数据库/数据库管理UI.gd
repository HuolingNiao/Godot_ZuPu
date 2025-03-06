extends Node2D
@onready var 姓名 = $"Panel/VBoxContainer/成员姓名"
@onready var 出生時間 = $"Panel/VBoxContainer/出生時間"
@onready var 死亡時間 = $"Panel/VBoxContainer/出生時間2"
@onready var 簡介 = $"Panel/VBoxContainer/個人簡介"
@onready var 是否健在按鈕 = $"Panel/VBoxContainer/HBoxContainer/健在"
@onready var 性別按鈕 = $"Panel/VBoxContainer/HBoxContainer/性别"
var 是否健在 = true
signal button_pressed(data)
signal 錯誤(錯誤信息)
signal 完成()
signal 更新簡介(date)
var 新成員 = RY.new("")
#var 新成員 = {"姓名":"","出生時間":"","個人簡介":"","性别":"男","死亡時間":""}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#是否健在按鈕.button_pressed
	性別按鈕.toggled.connect(性别显示)
	是否健在按鈕.toggled.connect(健在顯示)
	

func 清空输入框():
	姓名.text = ""
	出生時間.date_input.text = ""
	死亡時間.date_input.text = ""
	簡介.text = ""

func 獲取人員信息():
	var 姓名 = 姓名.text.strip_edges()
	var 性别 = 性別按鈕.text
	var 出生时间 = $"Panel/VBoxContainer/出生時間/LineEdit".text.strip_edges()+"+"+str($"Panel/VBoxContainer/出生時間/OptionButton".selected)
	var 死亡时间 = $"Panel/VBoxContainer/出生時間2/LineEdit".text.strip_edges()+"+"+str($"Panel/VBoxContainer/出生時間2/OptionButton".selected)
	var 简介2 = 簡介.text
	if 姓名 == "" and 简介2 == "":
		錯誤.emit("请输入完整信息")
		return
	新成員.姓名 = 姓名
	新成員.性别 = 性别
	新成員.是否健在 = 是否健在
	新成員.出生時間 = 出生时间
	新成員.死亡時間 = 死亡时间
	新成員.個人簡介 = 简介2
	完成.emit()

func 性别显示(button_pressed):
	if button_pressed:
		性別按鈕.text = "女"
	else:
		性別按鈕.text = "男"
		
func 健在顯示(button_pressed):
	if button_pressed:
		是否健在按鈕.text = "健在"
		是否健在 = true
		$"Panel/VBoxContainer/出生時間2".visible = false
		$Panel/VBoxContainer/text2.visible = false
	else:
		是否健在按鈕.text = "仙逝"
		是否健在 = false
		$"Panel/VBoxContainer/出生時間2".visible = true
		$Panel/VBoxContainer/text2.visible = true
# Add this function to handle tree item selection
func _on_button_pressed():
	獲取人員信息()
	button_pressed.emit("確定")

	
func 生成簡介():
	獲取人員信息()
	新成員.生成簡介()
	簡介.text = 新成員.個人簡介
	獲取人員信息()
	

func 更新人員(ry:RY):
	新成員 = ry
	print("ry.個人簡介 类型: ", typeof(ry.個人簡介), " 值: ", ry.個人簡介)
	姓名.text = str(ry.姓名)  # 强制转换为字符串
	簡介.text = str(ry.個人簡介)  # 强制转换为字符串
	出生時間.更新文本(ry.出生時間)
	死亡時間.更新文本(ry.死亡時間)
	if ry.性别 == "女":
		性別按鈕.button_pressed = true
	else:
		性別按鈕.button_pressed = false
	if ry.是否健在:
		是否健在按鈕.button_pressed = true
	else:
		是否健在按鈕.button_pressed = false
func 同步人員(a:RY):
	新成員 = a
