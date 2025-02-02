extends Node

@export var n_timer: MolTimer
@export var n_label_money: Label
@export var n_label_income: Label

var money: float = 0
var tickspeed: float = 4000
var base_income: float = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	parse_tick(0)


func parse_tick(ticks: int) -> void:
	money += base_income*ticks
	update_labels()
	n_timer.start_timer(tickspeed, parse_tick.bind(1))
	
func update_labels() -> void:
	n_label_money.text = QuarkNumber.format_number(money)+"ᛜ"
	n_label_income.text = QuarkNumber.format_number(base_income)+"ᛜ/"+str(tickspeed/1000)+"s"
