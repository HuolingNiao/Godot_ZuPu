extends Node2D

@onready var tree = $Tree
var 数据 = SJSD_Only.成員
var a = RY.new("")
var b
func _ready() -> void:
	tree.set_column_expand(0, true)
	tree.set_column_expand(1, true)
	tree.set_column_title(0, "姓名")
	tree.set_column_title(1, "ID")
	tree.set_column_custom_minimum_width(1, 50)
	数据.加载数据库()
	刷新树形图()


func 刷新树形图():
	tree.clear()
	var root = tree.create_item()
	root.set_text(0, "家族成员")
	
	# 添加始祖(輩份为1的成员)
	for member in 数据.data["成员"]:
		if member.輩份 == 1:
			添加成员到树(member, root)

func 添加成员到树(member, parent_item):
	var item = tree.create_item(parent_item)
	var display_text = member.姓名
	if member.id:
		display_text += " (ID: %s)" % member.id
	
	item.set_text(0, display_text)
	item.set_text(1, str(member.id))  # 显示ID
	item.set_metadata(0, member.id)
	
	# 设置性别颜色
	if member.性别 == "男":
		item.set_custom_color(0, Color(0.2, 0.4, 1.0))
	
	# 添加配偶信息
	for spouse_id in member.配偶:
		var spouse = 数据.按ID查找(int(spouse_id))  # 确保转换为整数
		if spouse:
			var spouse_item = tree.create_item(parent_item)
			spouse_item.set_text(0, "配偶: %s" % spouse.姓名)
			spouse_item.set_text(1, str(spouse.id))
			spouse_item.set_custom_color(0, Color(1.0, 0.2, 0.2))
	
	# 添加子女
	for child_id in member.子女:
		var child = 数据.按ID查找(int(child_id))  # 确保转换为整数
		if child:
			添加成员到树(child, item)

func 創建始祖():
	$AnimationPlayer.play("進入")
	await $"VBoxContainer/数据库管理".完成
	a.創建始祖(b)
	数据.添加成员(a)
	刷新树形图()

func 添加配偶():
	$AnimationPlayer.play("進入")
	var selected = tree.get_selected()
	await $"VBoxContainer/数据库管理".完成
	if selected:
		var member_id = selected.get_metadata(0)  # Use get_metadata(0) instead of get_text(1)
		if member_id != null:
			a = 数据.按ID查找(member_id)
			if a:
				
				数据.添加成员(a.添加配偶(b))
				刷新树形图()
				信息展示("加入配偶成功")
	信息展示("加入配偶失敗")


func 添加子女():
	$AnimationPlayer.play("進入")
	var selected = tree.get_selected()
	await $"VBoxContainer/数据库管理".完成
	if selected:
		var member_id = selected.get_metadata(0)  # Use get_metadata(0) instead of get_text(1)
		if member_id != null:
			var member = 数据.按ID查找(member_id)
			if member:
				数据.添加子女($"VBoxContainer/数据库管理".新成員, member.id)
				刷新树形图()
				信息展示("加入子女成功")
	信息展示("加入子女失敗"+str(selected.get_metadata(0)))

func 添加兄弟():
	$AnimationPlayer.play("進入")
	var selected = tree.get_selected()
	await $"VBoxContainer/数据库管理".完成
	if selected:
		var member_id = selected.get_metadata(0)  # Use get_metadata(0) instead of get_text(1)
		if member_id != null:
			var member = 数据.按ID查找(member_id)
			if member:
				数据.添加兄弟($"VBoxContainer/数据库管理".新成員, member.id)
				刷新树形图()
				信息展示("加入兄妹成功")
	信息展示("加入兄妹失敗")

func 刪除成員():
	var selected = tree.get_selected()
	if selected:
		var member_id = selected.get_metadata(0)
		数据.删除成员(member_id)
		刷新树形图()

func 清空數據庫():
	数据.data["成员"] = []
	数据.保存数据库()
	刷新树形图()


func _on_数据库管理_button_pressed() -> void:
	$AnimationPlayer.play("出去")
	
	pass # Replace with function body.


func _on_数据库管理_錯誤(錯誤信息: Variant) -> void:
	信息展示(錯誤信息)
func 信息展示(s):
	$AcceptDialog.dialog_text = s
	$AcceptDialog.popup_centered()


func _on_数据库管理_完成(date: Variant) -> void:
	b = date
	pass # Replace with function body.
