extends Node2D
class_name FamilyTree

var 数据 = SJK.new()

# 用于绘制简单家庭族谱
func _ready():
	数据.加载数据库()

	# 查找族谱的根节点（假设根节点是某个特定 ID 或条件的节点）
	for id in 数据.data.keys():
		var member = 数据.data[id]
		if member.輩份 == 1:  # 假设根节点的輩份为 0
			創建分支樹(member, Vector2(800, 150))
			break

# 创建整个家庭树
func 創建分支樹(member: RY, position: Vector2):
	# 创建当前成员节点
	var node = 創建單個成員(member, position)
	add_child(node)

	# 获取配偶并创建节点
	var spouse_node = null
	for 配偶_id in member.配偶:
		if 数据.data.has(配偶_id):
			var spouse = 数据.data[配偶_id]

	# 获取子女并创建节点
	var child_y_offset = 120
	var child_x_offset = 0
	var child_start_x = position.x - ((member.子女.size() - 1) * child_y_offset / 2)
	var children_nodes = []

	for child_id in member.子女:
		if 数据.data.has(child_id):
			var child = 数据.data[child_id]
			var child_position = position + Vector2(-child_x_offset, child_y_offset)
			child_x_offset += 70  # 子女节点水平间距
			var child_node = 創建分支樹(child, child_position)
			children_nodes.append(child_node)


	# 计算子节点的水平中心点并调整父节点位置
	if children_nodes.size() > 0:
		# 计算所有子节点的水平范围
		var min_x = children_nodes[0].position.x
		var max_x = children_nodes[0].position.x
		for child_node in children_nodes:
			min_x = min(min_x, child_node.position.x)
			max_x = max(max_x, child_node.position.x)

		# 调整父节点位置到子节点中心
		var parent_center_x = (min_x + max_x+60) / 2
		node.position.x = parent_center_x - node.size.x / 2 # 居中对齐
	# 如果有子节点，绘制从父节点到底部锚点的线，再从锚点连接到所有子节点
	if children_nodes.size() > 0:
		var anchor_pos = node.position + Vector2(node.size.x / 2, node.size.y + 10) # 父节点底部锚点
		for child_node in children_nodes:
			連接線(anchor_pos, child_node)

	return node

# 创建族谱节点
func 創建單個成員(member: RY, position: Vector2) -> Control:
	var node = HBoxContainer.new()
	node.position = position
	#node.alignment = BoxContainer.ALIGNMENT_
	var id = member.id
	var 主成員 = LabelSettings.new()
	主成員.font_size = 24
	主成員.font_color = Color.BLACK
	主成員.font = load("res://族譜UI相關/素材/TypeLand.com 康熙字典體完整版.ttf")
	var 主 = LabelSettings.new()
	主.font_size = 18
	主.font_color = Color.BLACK
	主.font = load("res://族譜UI相關/素材/TypeLand.com 康熙字典體完整版.ttf")

	# Create all labels first
	var name_label = Label.new()
	name_label.text = member.姓名
	name_label.custom_minimum_size.x = 20
	name_label.custom_minimum_size.y = 50
	name_label.autowrap_mode = true
	name_label.label_settings = 主成員
	name_label.vertical_alignment = VERTICAL_ALIGNMENT_TOP
	if member.配偶.is_empty():
		# If no spouse, just add name and return
		node.add_child(name_label)
		return node
		
	var relationship_label = Label.new()
	relationship_label.text = "娶" if member.性别 == "男" else "嫁"
	relationship_label.label_settings = 主
	relationship_label.custom_minimum_size.y = 50
	
	var spouse_label = Label.new()
	spouse_label.custom_minimum_size.x = 16
	spouse_label.label_settings = 主
	spouse_label.autowrap_mode = true
	spouse_label.custom_minimum_size.y = 50
	var spouse_names = ""
	for spouse_id in member.配偶:
		if 数据.data.has(spouse_id):
			var spouse = 数据.data[spouse_id]
			spouse_names += spouse.姓名 + " "
	spouse_label.text = spouse_names.strip_edges()
	
	# Add children in reverse order
	node.add_child(spouse_label)
	node.add_child(relationship_label)
	node.add_child(name_label)
	
	return node


# 绘制从锚点到子节点的连线
func 連接線(anchor_pos: Vector2, child: Control):
	if child == null:
		return

	var line = Line2D.new()
	line.width = 2
	line.default_color = Color(0, 0, 0)

	var end_pos = child.position + Vector2(child.size.x / 2, -10) 
	var mid_y = (anchor_pos.y + end_pos.y) / 2
	
	# Add points to create Z-shaped path
	line.add_point(anchor_pos)  # Starting point
	line.add_point(Vector2(anchor_pos.x,mid_y))  # Vertical line from start
	line.add_point(Vector2(end_pos.x,mid_y))    # Horizontal connection
	line.add_point(end_pos)  # 子节点上方中心点

	#line.add_point(anchor_pos)
	#line.add_point(end_pos)

	add_child(line)

# 根据位置查找节点
func 獲取座標(position: Vector2) -> Control:
	for child in get_children():
		if child is Control and child.position == position:
			return child
	return null
