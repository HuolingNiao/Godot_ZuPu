extends Node
class_name SJK

var database_file = "res://数据库.bin"  # 使用二进制文件保存
var data = {}  # 结构: {id: RY}
var 書籍信息 = {}  # 新增书籍信息字典
# 加载数据库
func 加载数据库():
	data = {}
	#書籍信息 = {}  # 初始化书籍数据
	if FileAccess.file_exists(database_file):
		var file = FileAccess.open(database_file, FileAccess.ModeFlags.READ)
		if file.get_length() > 0:
			var raw_data = file.get_var()
			if raw_data is Dictionary:
				for id in raw_data.keys():
					if id != 0:
						var ry = RY.new("")
						ry.从数据加载(raw_data[id])
						data[id] = ry
					else:
						書籍信息 = raw_data[0]
		file.close()
	else:
		保存数据库()

func 保存数据库():
	var file = FileAccess.open(database_file, FileAccess.ModeFlags.WRITE)
	var save_data = {}
	for id in data.keys():
		if id != 0:
			save_data[id] = data[id].转换为数据()
		else:
			save_data[0] = 書籍信息
	file.store_var(save_data)
	file.close()

func 另存為(路径: String) -> bool:
	var file = FileAccess.open(路径, FileAccess.ModeFlags.WRITE)
	if file:
		var save_data = {}
		for id in data.keys():
			save_data[id] = data[id].转换为数据()
		var content = var_to_bytes(save_data)
		file.store_buffer(content)
		file.close()
		return true
	return false

func 導入(路径: String) -> bool:
	if FileAccess.file_exists(路径):
		var file = FileAccess.open(路径, FileAccess.ModeFlags.READ)
		if file and file.get_length() > 0:
			var content = file.get_buffer(file.get_length())
			var parsed_data = bytes_to_var(content)
			if parsed_data is Dictionary:
				data.clear()
				for id in parsed_data.keys():
					var ry = RY.new("")
					ry.从数据加载(parsed_data[id])
					data[id] = ry
				file.close()
				保存数据库()
				return true
		file.close()
	return false

 #添加成员
func 添加成员(member: RY):
	if member.id == 0:  # 如果未分配 ID，则生成 ID
		member.id = 生成id(member)
	data[member.id] = member
	保存数据库()

# 删除成员
func 删除成员(member_id: int):
	if data.has(member_id):
		data.erase(member_id)
		保存数据库()

# 查找成员
func 查找成员(name: String) -> Array:
	var results = []
	for ry in data.values():
		if name in ry.姓名:
			results.append(ry)
	return results

# 根据ID查找成员
func 按ID查找(id: int) -> RY:
	if data.has(id):
		return data[id]
	return null

# 创建始祖
func 創建始祖(member: RY):
	data = {}  # 清空所有成员
	member.輩份 = 1
	member.排行 = 1
	member.父親排行 = 0
	member.id = 生成id(member)
	添加成员(member)

# 添加配偶
func 添加配偶(配偶: RY, 目標id: int):
	var 目標 = 按ID查找(目標id)
	if 目標:
		if 目標.性别 == "男":
			目標.關係 += "娶"+配偶.姓名+"為妻"
			配偶.關係 = "配"+目標.姓名
		else:
			目標.關係 += "嫁"+配偶.姓名
			配偶.關係 = "娶"+目標.姓名
		配偶.輩份 = 目標.輩份
		配偶.排行 = 0
		配偶.父親排行 = 目標.父親排行
		配偶.id = 生成id(配偶)
		目標.配偶.append(配偶.id)
		添加成员(配偶)
		更新成员(目標)

# 添加兄弟
func 添加兄弟(兄弟: RY, 目標id: int):
	var 目標 = 按ID查找(目標id)
	if 目標:
		兄弟.輩份 = 目標.輩份
		兄弟.父親排行 = 目標.父親排行
		兄弟.id = 生成id(兄弟)
		添加成员(兄弟)

# 添加子女
func 添加子女(子女: RY, 目標id: int):
	var  長幼 = ["長","次","三","四","五","六","七","八","九","十"]
	var 目標 = 按ID查找(目標id)
	if 子女.性别 == "女":
		長幼 = 長幼.map(func(x): return x + "女")
	else:
		長幼 = 長幼.map(func(x): return x + "子")
	
	if 目標:
		子女.輩份 = 目標.輩份 + 1
		子女.排行 = 目標.子女.size() + 1
		子女.父親排行 = 目標.父親排行
		子女.關係 = 目標.姓名+"之"+長幼[子女.排行]
		子女.id = 生成id(子女)
		目標.子女.append(子女.id)
		添加成员(子女)
		更新成员(目標)

# 生成ID
func 生成id(成員: RY) -> int:
	var gender_map = {
		"男": 1,
		"女": 0
	}
	var 世代碼 = str(成員.輩份).pad_zeros(3)
	var 父代碼 = str(成員.父親排行).pad_zeros(2)
	var 性別 = str(gender_map[成員.性别])
	var 自排行 = str(成員.排行).pad_zeros(2)
	var 隨機碼 = str(randi() % 1000).pad_zeros(3)
	var a = "%s%s%s%s%s" % [世代碼, 父代碼, 性別, 自排行, 隨機碼]
	return int(a)

func 更新成员(member: RY):
	if data.has(member.id):
		# 保持原有的关系数据
		var original = data[member.id]
		member.子女 = original.子女
		member.配偶 = original.配偶
		
		# 更新数据库中的成员
		data[member.id] = member
		保存数据库()
		print("更新完成")
		return true
	print("更新失敗")
	return false

func 導出JSON(路径: String) -> bool:
	var json_data = {}
	for id in data.keys():
		json_data[str(id)] = data[id].转换为数据()
	
	var json_string = JSON.stringify(json_data, "  ")
	var file = FileAccess.open(路径, FileAccess.ModeFlags.WRITE)
	if file:
		file.store_string(json_string)
		file.close()
		return true
	return false

func 導入JSON(路径: String) -> bool:
	if FileAccess.file_exists(路径):
		var file = FileAccess.open(路径, FileAccess.ModeFlags.READ)
		if file:
			var json_string = file.get_as_text()
			var json = JSON.new()
			var error = json.parse(json_string)
			if error == OK:
				var parsed_data = json.get_data()
				if parsed_data is Dictionary:
					data.clear()
					for id_str in parsed_data.keys():
						var member_data = parsed_data[id_str]
						var ry = RY.new("")
						ry.从数据加载(member_data)
						data[ry.id] = ry
					保存数据库()
					return true
			file.close()
	return false
func 保存書籍数据(a:Dictionary):
	var file = FileAccess.open(database_file, FileAccess.ModeFlags.WRITE)
	var save_data = {}
	for id in data.keys():
		if id != 0:
			save_data[id] = data[id].转换为数据()
		else:
			save_data[0] = a
	file.store_var(save_data)
	file.close()
