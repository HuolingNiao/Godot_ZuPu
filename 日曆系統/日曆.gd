extends Node
class_name SJ

const HEAVENLY_STEMS = ["甲", "乙", "丙", "丁", "戊", "己", "庚", "辛", "壬", "癸"]
const EARTHLY_BRANCHES = ["子", "丑", "寅", "卯", "辰", "巳", "午", "未", "申", "酉", "戌", "亥"]
const CHINESE_NUMBERS = ["零", "一", "二", "三", "四", "五", "六", "七", "八", "九", "十", "百"]
const CHINESE_HOURS = ["子", "丑", "寅", "卯", "辰", "巳", "午", "未", "申", "酉", "戌", "亥"]
var 輸入為空 = true
var year: int
var month: int
var day: int
var hour: int

func _init(date_str: String = "", hour_val: int = 0):
	if date_str == "":
		self.輸入為空 = true
		return
	if date_str != "":
		if !檢查日期格式(date_str):
			push_error("錯誤日期格式. Use YYYY-MM-DD")
			return
		
		var date_parts = date_str.split("-")
		var y = int(date_parts[0])
		var m = int(date_parts[1])
		var d = int(date_parts[2])
		
		if !檢查日期值(y, m, d, hour_val):
			push_error("Invalid date values")
			return
			
		year = y
		month = m
		day = d
		hour = hour_val
		#self.is_empty = false

static func 檢查日期格式(date_str: String) -> bool:
	# Check format YYYY-MM-DD
	var regex = RegEx.new()
	regex.compile("^\\d{4}-(?:0[1-9]|1[0-2])-(?:0[1-9]|[12]\\d|3[01])$")
	return regex.search(date_str) != null

static func 檢查日期值(y: int, m: int, d: int, h: int) -> bool:
	# Basic range checks
	if y < 1 || y > 9999:
		return false
	if m < 1 || m > 12:
		return false
	if d < 1 || d > 31:
		return false
	if h < 0 || h > 23:
		return false
		
	# Check days in month
	var days_in_month = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
	
	# Leap year check
	if y % 4 == 0 && (y % 100 != 0 || y % 400 == 0):
		days_in_month[1] = 29
		
	if d > days_in_month[m - 1]:
		return false
		
	return true

# Create SJ instance from components with validation
func init(y: int, m: int, d: int, h: int):
	if !檢查日期值(y, m, d, h):
		push_error("Invalid date values in create()")
		return null
	year = y
	month = m
	day = d
	hour = h
	輸入為空 = false

# Get formatted string representation
func 獲取農曆文本() -> String:
	if 輸入為空:
		return "時間不詳"
	var stem_index = (year - 4) % 10
	var branch_index = (year - 4) % 12
	var year_str = HEAVENLY_STEMS[stem_index] + EARTHLY_BRANCHES[branch_index] + "年"
	
	var month_str = format_lunar_month(month)
	var day_str = format_lunar_day(day)
	var hour_str = CHINESE_HOURS[hour / 2] + "時"
	
	return year_str + month_str + day_str + hour_str

# Calculate difference with another SJ instance
func 年齡計算(other_sj: SJ) -> String:
	var diff = abs(other_sj.year - year)
	if diff == 0 and (other_sj.month != month or other_sj.day != day):
		diff = 1
	diff = max(1, diff)
	
	return number_to_chinese_age(diff)

# Get date string in YYYY-MM-DD format
func get_date_string() -> String:
	return "%04d-%02d-%02d+%02d" % [year, month, day,hour]

func format_lunar_month(a: int) -> String:
	var month_str = ""
	match a:
		1: month_str = "正月"
		11: month_str = "冬月"
		12: month_str = "臘月"
		_: month_str = CHINESE_NUMBERS[a] + "月"
	return month_str

func format_lunar_day(day: int) -> String:
	if day <= 10:
		return "初" + CHINESE_NUMBERS[day]
	elif day < 20:
		return "十" + CHINESE_NUMBERS[day % 10]
	elif day == 20:
		return "二十"
	elif day < 30:
		return "廿" + CHINESE_NUMBERS[day % 10]
	else:
		return "卅"

func number_to_chinese_age(num: int) -> String:
	if num <= 10:
		return CHINESE_NUMBERS[num] + "歲"
		
	var hundreds = num / 100
	var tens = num / 10
	var ones = num % 10
	
	var result = ""
	# Handle hundreds
	if hundreds > 0:
		result += CHINESE_NUMBERS[hundreds] + "百"
		if tens > 0:
			# Add 零 between hundred and tens if there are tens
			result += CHINESE_NUMBERS[0] if ones > 0 or tens > 1 else ""
	
	# Handle tens
	if tens > 1 or (hundreds > 0 and tens > 0):
		result += CHINESE_NUMBERS[tens]
	if tens > 0:
		result += "十"
	
	# Handle ones
	if ones > 0:
		result += CHINESE_NUMBERS[ones]
		
	return result + "歲"

static func 獲取當前時間() -> SJ:
	var datetime = Time.get_datetime_dict_from_system()
	#var date_str = "%04d-%02d-%02d" % [datetime.year, datetime.month, datetime.day]
	var a = SJ.new()
	a.year = datetime.year
	a.month = datetime.month
	a.day = datetime.day
	a.hour = datetime.hour
	a.輸入為空 = false
	return a
static func 轉換時間(a:String)-> SJ:
	var date_parts = a.split("+")
	var hour_val = int(date_parts[1]) * 2 if int(date_parts[1]) > 0 else 23
	if !檢查日期格式(date_parts[0]):
			print("Invalid date format. Use YYYY-MM-DD")
			return
	var date_parts2 = date_parts[0].split("-")
	var y = int(date_parts2[0])
	var m = int(date_parts2[1])
	var d = int(date_parts2[2])
		
	if !檢查日期值(y, m, d, hour_val):
		print("Invalid date values")
		return
	var b = SJ.new()
	b.year = y
	b.month = m
	b.day = d
	b.hour = hour_val
	b.輸入為空 = false
	return b
	
