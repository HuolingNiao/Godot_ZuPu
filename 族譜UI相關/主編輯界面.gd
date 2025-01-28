extends Node2D

var shuji = SJSD.new()

# 當節點進入場景樹時執行
func _ready() -> void:
	shuji.初始化("溫")

	# 創建 ScrollContainer
	var s = ScrollContainer.new()
	s.size = Vector2(1920, 1020)
	s.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	s.size_flags_vertical = Control.SIZE_EXPAND_FILL

	# 創建 VBoxContainer
	var v = TabContainer.new()
	#v.size_flags_vertical = Control.SIZE_EXPAND_FILL
	v.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	# 按照每兩頁一組進行分組
	var pairs = []
	for i in range(0, shuji.前言頁面.size(), 2):
		if i + 1 < shuji.前言頁面.size():
			pairs.append([shuji.前言頁面[i], shuji.前言頁面[i + 1]])
		else:
			# 如果是奇數頁，將最後一頁單獨加入
			pairs.append([shuji.前言頁面[i]])
	var fm = preload("res://族譜UI相關/排版/封面頁面.tscn").instantiate()
	fm.更新文本("溫氏族譜")
	v.add_child(fm)  # 將封面添加到 VBoxContainer

	# 創建並初始化每一組頁面
	for a in range(pairs.size()):
		# 每一組都應該創建新的頁面實例
		var 頁面1 = preload("res://族譜UI相關/排版/A3文本頁面.tscn").instantiate()
		# 初始化頁面內容
		頁面1.初始化(pairs[a], int(a))   # 設置頁碼索引
		# 設置頁面大小（使用 rect_size）
		

		# 添加頁面到 VBoxContainer
		v.add_child(頁面1)
		

	# 添加封面頁面
	var fz = preload("res://族譜UI相關/排版/分支頁面.tscn").instantiate()
	v.add_child(fz) 
	var 成員 = preload("res://族譜UI相關/排版/A3成員頁面.tscn").instantiate()
	var a = shuji.拆分成員(8)
	成員.初始化(a,0)
	v.add_child(成員) 
	# 設置 VBoxContainer 的最小高度，確保可以滾動
	#v.custom_minimum_size = Vector2(1920, pairs.size() * 1020 + 1080)  # 每頁1020 + 封面1080

	# 將 VBoxContainer 添加到 ScrollContainer
	s.add_child(v)
	s.queue_sort()

	# 將 ScrollContainer 添加到場景
	add_child(s)

# 每幀執行
func _process(delta: float) -> void:
	pass
