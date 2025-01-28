extends Node
class_name RY

var 姓名
var 輩份 = -1
var 排行 = -1
var 性别:String = "男"
var 是否健在 = true
var 關係 = ""
var 父親排行 = -1
var 出生時間 = ""
var 死亡時間 = ""
var 個人簡介 = ""
var 配偶 = []
var 子女 = []
var id:int = -1
func _init(名字:String) -> void:
	姓名 = 名字
func 初始化(data: Dictionary):
	姓名 = data["姓名"]
	性别 = data["性别"]
	是否健在 = data["是否健在"]
	出生時間 = data["出生時間"]
	死亡時間 = data["死亡時間"]
	個人簡介 = data["個人簡介"]
	id = 生成id()
	
func 更新(data: Dictionary):
	姓名 = data["姓名"]
	性别 = data["性别"]
	是否健在 = data["是否健在"]
	出生時間 = data["出生時間"]
	死亡時間 = data["死亡時間"]
	個人簡介 = data["個人簡介"]

func 創建始祖(data: Dictionary):
	輩份 = 1
	排行 = 1
	父親排行 = 1
	初始化(data)

func 添加配偶(data: Dictionary):
	var 配偶 = RY.new("")
	if data["性別"] == "女":
		self.關係 += "娶"+data["姓名"]+"為妻"
		配偶.關係 = "配"+self.姓名
	else:
		self.關係 += "嫁"+data["姓名"]
		配偶.關係 = "娶"+self.姓名
	配偶.輩份 = 輩份
	配偶.排行 = 排行
	配偶.父親排行 = 父親排行
	配偶.初始化(data)
	配偶.append(配偶.id)
	return 配偶
	
func 添加兄妹(data: Dictionary):
	var 兄妹 = RY.new("")
	兄妹.輩份 = 輩份
	兄妹.排行 = 排行+1
	兄妹.關係 = self.關係
	兄妹.父親排行 = 父親排行
	兄妹.初始化(data)
	return 兄妹
	
	
func 添加子女(data: Dictionary):
	var  長幼 = ["長","次","三","四","五","六","七","八","九","十"]
	if data["性別"] == "女":
		長幼 = 長幼.map(func(x): return x + "女")
	else:
		長幼 = 長幼.map(func(x): return x + "子")
	
	var 子女2 = RY.new("")
	子女2.輩份 = 輩份+1
	子女2.排行 = self.子女.size()+1
	子女2.關係 = self.姓名+"之"+長幼[排行]
	子女2.父親排行 = 父親排行
	子女2.初始化(data)
	return 子女2
	
	
func 生成id():
	var gender_map = {
	"男": 1,
	"女": 0
}
	var 世代碼 = str(輩份).pad_zeros(3)
	var 父代碼 = str(父親排行).pad_zeros(2)
	var 性別 = str(gender_map[性别])
	var 自排行 = str(排行).pad_zeros(2)
	var 隨機碼 = str(randi()%1000).pad_zeros(3)
	var a = "%s-%s-%s-%s-%s" %[世代碼,父代碼,性別,自排行,隨機碼]
	return int(a)
func 转换为数据() -> Dictionary:
	return {
		"id": id,
		"姓名": 姓名,
		"輩份": 輩份,
		"排行": 排行,
		"父親排行": 父親排行,
		"性别": 性别,
		"出生時間": 出生時間,
		"死亡時間": 死亡時間,
		"個人簡介": 個人簡介,
		"配偶": 配偶,
		"子女": 子女
	}

# 从数据中恢复RY对象
func 从数据加载(data: Dictionary):
	assert(typeof(data) == TYPE_DICTIONARY, "Expected Dictionary, got " + str(typeof(data)))
	self.id = data["id"]
	self.姓名 = data["姓名"]
	self.輩份 = data["輩份"]
	self.排行 = data["排行"]
	self.父親排行 = data["父親排行"]
	self.性别 = data["性别"]
	self.出生時間 = data["出生時間"]
	self.死亡時間 = data["死亡時間"]
	self.個人簡介 = data["個人簡介"]
	self.配偶 = data["配偶"]
	self.子女 = data["子女"]

func 生成簡介():
	var 出生文本 = ""
	var 逝世文本 = ""
	var 年齡文本 = ""
	if 是否健在:
		if 出生時間=="":
			出生文本 = "出生時間不詳"
		else:
			var s = SJ.new().獲取當前時間()
			var a = SJ.new().轉換時間(出生時間)
			出生文本 = "生於"+a.獲取農曆文本()
			年齡文本 = "現年"+a.年齡計算(s)
	else:
		if 出生時間=="" and 死亡時間=="" :
			出生文本 = "生"
			逝世文本 = "歿時間不詳"
		else:
			if 出生時間=="" or 死亡時間=="" :
				出生文本 = "生於"+SJ.轉換時間(出生時間).獲取農曆文本()
				逝世文本 = "歿於"+SJ.轉換時間(死亡時間).獲取農曆文本()
			else:
				出生文本 = "生於"+SJ.轉換時間(出生時間).獲取農曆文本()
				逝世文本 = "歿於"+SJ.轉換時間(死亡時間).獲取農曆文本()
				年齡文本 = "享年"+SJ.轉換時間(出生時間).年齡計算(SJ.new().轉換時間(死亡時間))
	個人簡介 = 姓名 + 出生文本 + 逝世文本 + 年齡文本 + 關係
	
