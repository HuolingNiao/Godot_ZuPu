extends Node
class_name SJSD
var 成員 = SJK.new()
var 姓氏 = "軒轅"
var 族譜名稱 = ""
var 書芯名稱 = ""
var 字輩 = ""
var 前言 = ""
var 後記 = ""
var 前言頁面 = []
var 後記頁面 = []
# 通用族譜序言和後記生成腳本
# 使用方法：調用generate_intro或generate_epilogue函數，傳入姓氏作為參數

func 生成前言() -> String:
	var intro = ""

	# 姓氏起源
	intro += "前言\n"+\
			 姓氏 + "氏之源，肇自上古，滄海桑田，世代綿延。" + \
			 "據史籍所載，" + 姓氏 + "姓或因部族之名，或因地望而興，抑或因官職、功績而得。" + \
			 "或傳某上古聖人，其功昭於天地，遂以" + 姓氏 + "為氏，此實為" + 姓氏 + "姓之濫觴。\n\n"

	# 姓氏發展
	intro += "歷朝歷代，" + 姓氏 + "氏之繁衍有跡可循。" + \
			 "漢唐之際，族中多官宦與學士，其貢獻可謂彪炳史冊。" + \
			 "至於宋元明清，文武兼備，名垂青史者不勝枚舉。" + \
			 "其族裔更因時代變遷，或遷徙四方，或播遷海外，成為文化交融之橋樑。\n\n"

	# 姓氏分佈
	intro += "今觀" + 姓氏 + "氏，遍布九州四海，尤以江南與中原為最盛。" + \
			 "隨移民之風潮，其後裔早已遷徙五洲，於異邦立足，光耀先祖之德。" + \
			 "無論故土或異鄉，" + 姓氏 + "氏族皆以忠義孝悌、勤謹篤實為世所稱道。\n\n"

	# 姓氏文化
	intro += "" + 姓氏 + "氏之家風，涵養深厚，綿延千載。" + \
			 "家訓育人，族譜紀史，春秋祭祖，無不彰顯家族之傳統與精神。" + \
			 "每逢佳節，族人聚首，溯源敬祖，亦延續家族之凝聚力。" + \
			 "此等傳統，不僅乃宗族之寶，亦為民族文化之瑰寶。\n\n"

	# 收尾
	intro += "族譜之編纂，旨在承先啟後，啟迪後人。願" + 姓氏 + "氏族能繼承祖德，光大其業，" + \
			 "於未來創造更加輝煌之篇章。"

	return intro

func 生成後記() -> String:
	var epilogue = ""

	# 感謝與總結
	epilogue += "後記\n"+\
	"族譜一書，字字斟酌，乃族中長幼合力之成果。" + \
				"感謝諸位宗親，不辭勞苦，搜集史料，編撰成冊。此乃家族之盛事，當為永誌。\n\n"

	# 家族未來
	epilogue += "《" + 姓氏 + "》氏族千年流轉，代代相傳，其精神融於血脈，其文化植於心田。" + \
				"吾輩當謹守祖訓，敬宗收族，延續家風，使後世子孫不忘根本，砥礪前行。\n\n"

	# 展望
	epilogue += "余祈《" + 姓氏 + "》氏之後裔，興於德，成於業，不負先祖厚望。" + \
				"願此譜為明燈，照亮未來之路，使吾族子孫於百代之後，仍能承德報本，榮光長存。"

	return epilogue

static func 拆分文本(文本:String, 字數:int) -> Array:
	var 文本2 = []
	var 段落列表 = 文本.split("\n")
	
	for 段落 in 段落列表:
		if 段落.length() <= 字數:
			文本2.append(段落)
			continue
			
		var length = 段落.length()
		var index = 0
		
		while index < length:
			var end = min(index + 字數, length)
			文本2.append(段落.substr(index, 字數))
			index += 字數
			
		## 在每個段落後添加換行
		#if 段落 != 段落列表[-1]:
			#文本2.append("")
			
	return 文本2
func 拆分頁面(文本: String, 每行字數: int, 每頁行數: int) -> Array:
	var 結果 = []
	var 已拆分文本 = 拆分文本(文本, 每行字數)
	var 當前頁 = []

	for 行 in 已拆分文本:
		當前頁.append(行)

		if 當前頁.size() == 每頁行數:
			結果.append(當前頁)
			當前頁 = []

	if 當前頁.size() > 0:
		結果.append(當前頁)

	return 結果

func 初始化(a:String):
	姓氏 = a
	前言 = 生成前言()
	後記 = 生成後記()

	var 每行字數 = 17
	var 每頁行數 = 9

	前言頁面 = 拆分頁面(前言, 每行字數, 每頁行數)
	後記頁面 = 拆分頁面(後記, 每行字數, 每頁行數)

static func 數字轉中文(a: int) -> String:
	const CHINESE_NUMBERS = ["零", "一", "二", "三", "四", "五", "六", "七", "八", "九"]
	const UNITS = ["", "十", "百", "千"]
	const LARGE_UNITS = ["", "萬", "億", "兆"]

	if a == 0:
		return CHINESE_NUMBERS[0]

	var result = ""
	var unit_index = 0
	var large_unit_index = 0
	var is_prev_zero = false

	while a > 0:
		var segment = a % 10000  # 取出每四位數作為一組 (萬進位)
		if segment > 0:
			var segment_str = ""
			var segment_unit_index = 0
			while segment > 0:
				var digit = segment % 10
				if digit > 0:
					if is_prev_zero:
						segment_str = CHINESE_NUMBERS[0] + segment_str
						is_prev_zero = false
					segment_str = CHINESE_NUMBERS[digit] + UNITS[segment_unit_index] + segment_str
				else:
					is_prev_zero = true
				segment = segment / 10
				segment_unit_index += 1
			result = segment_str + LARGE_UNITS[large_unit_index] + result
		else:
			is_prev_zero = true

		a = a / 10000
		large_unit_index += 1

	# 處理「一十」的簡化情況，例如將「一十二」簡化為「十二」
	if result.begins_with("一十"):
		result = result.substr(1)

	return result

static func 拆分成員(a:int) -> Array:
	var cy = []
	var dq = []
	var sj = SJK.new()
	sj.加载数据库()
	for i in sj.data.keys():
		var ry1 = sj.按ID查找(i)
		dq.append(ry1)
		if dq.size() == a:
			cy.append(dq)
			dq = []
	if dq.size() > 0:
		cy.append(dq)
	return cy
