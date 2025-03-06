extends Node2D
@onready var 創建始祖按钮 = $"VBoxContainer/添加始祖"
@onready var tree = $Tree
var 数据 = SJK.new()
var b
var 確認重要操作 = false
func _ready() -> void:
	tree.columns = 2
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
	for id in 数据.data.keys():
		var member = 数据.data[id]
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
		var spouse = 数据.按ID查找(spouse_id)
		if spouse:
			var spouse_item = tree.create_item(parent_item)
			spouse_item.set_text(0, "配偶: %s" % spouse.姓名)
			spouse_item.set_text(1, str(spouse.id))
			spouse_item.set_custom_color(0, Color(1.0, 0.2, 0.2))
	
	# 添加子女
	for child_id in member.子女:
		var child = 数据.按ID查找(child_id)
		if child:
			添加成员到树(child, item)

func 創建始祖():
	if not 数据.data.is_empty():
		信息展示("已存在家族成员，无法创建始祖")
		return
	$AnimationPlayer.play("進入")
	var a = RY.new("") 
	$"VBoxContainer/数据库管理".同步人員(a)
	await $"VBoxContainer/数据库管理".完成
	
	a=$"VBoxContainer/数据库管理".新成員 # 创建新的始祖成员
	数据.創建始祖(a)
	刷新树形图()

func 添加配偶():
	$AnimationPlayer.play("進入")
	var selected = tree.get_selected()
	var 配偶 = RY.new("")
	$"VBoxContainer/数据库管理".同步人員(配偶)
	await $"VBoxContainer/数据库管理".完成
	if selected:
		var member_id = selected.get_metadata(0)
		if member_id != null:
			var member = 数据.按ID查找(member_id)
			if member:
				配偶=$"VBoxContainer/数据库管理".新成員
				数据.添加配偶(配偶, member_id)
				刷新树形图()
				信息展示("加入配偶成功")
				return
	信息展示("加入配偶失敗")

func 添加子女():
	$AnimationPlayer.play("進入")
	var selected = tree.get_selected()
	var 子女 = RY.new("")
	$"VBoxContainer/数据库管理".同步人員(子女)
	await $"VBoxContainer/数据库管理".完成
	if selected:
		var member_id = selected.get_metadata(0)
		if member_id != null:
			
			子女=$"VBoxContainer/数据库管理".新成員
			数据.添加子女(子女, member_id)
			刷新树形图()
			信息展示("加入子女成功")
			return
	信息展示("加入子女失敗")

func 添加兄弟():
	$AnimationPlayer.play("進入")
	var selected = tree.get_selected()
	var 兄弟 = RY.new("")
	$"VBoxContainer/数据库管理".同步人員(兄弟)
	await $"VBoxContainer/数据库管理".完成
	if selected:
		var member_id = selected.get_metadata(0)
		if member_id != null:
			兄弟=$"VBoxContainer/数据库管理".新成員
			数据.添加兄弟(兄弟, member_id)
			刷新树形图()
			信息展示("加入兄妹成功")
			return
	信息展示("加入兄妹失敗")

func 刪除成員():
	var selected = tree.get_selected()
	if selected:
		var member_id = selected.get_metadata(0)
		if 数据.删除成员(member_id):
			刷新树形图()
			信息展示("删除成员成功")
		else:
			信息展示("删除成员失败")

func 清空數據庫():
	var dialog = ConfirmationDialog.new()
	add_child(dialog)
	dialog.dialog_text = "此操作爲不可挽回，所有數據即將丟失，請謹慎操作"
	dialog.title = "確認清空數據庫"
	
	# Connect the confirmation signal
	dialog.confirmed.connect(func():
		数据.data.clear()
		数据.保存数据库()
		刷新树形图()
		dialog.queue_free()
	)
	
	# Connect the close signal to clean up
	dialog.close_requested.connect(func():
		dialog.queue_free()
	)
	
	dialog.popup_centered()

func 修改成員():
	$AnimationPlayer.play("進入")
	var selected = tree.get_selected()
	if selected:
		var member_id = selected.get_metadata(0)
		if member_id != null:
			var cy = 数据.按ID查找(member_id)
			$"VBoxContainer/数据库管理".更新人員(cy)
			await $"VBoxContainer/数据库管理".完成
			cy=$"VBoxContainer/数据库管理".新成員
			数据.更新成员(cy)
			
			return

func 信息展示(s: String):
	$AcceptDialog.dialog_text = s
	$AcceptDialog.popup_centered()

func 更新始祖按钮状态():
	創建始祖按钮.disabled = not 数据.data.is_empty()


func _on_数据库管理_button_pressed(data: Variant) -> void:
	#b.初始化($"VBoxContainer/数据库管理".新成員)
	$"VBoxContainer/数据库管理".清空输入框()
	$AnimationPlayer.play("出去")
	pass # Replace with function body.

func 生成簡介():
	var selected = tree.get_selected()
	if selected:
		var member_id = selected.get_metadata(0)
		if member_id != null:
			var cy = 数据.按ID查找(member_id)
			cy.生成簡介()
			数据.更新成员(cy)
			print("簡介完成")
			$"VBoxContainer/数据库管理".更新人員(cy)
	pass
