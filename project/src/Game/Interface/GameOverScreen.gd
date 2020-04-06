extends Control

class Quote:
	var quote : String
	var author : String
	
	func _init(q:String, a:String):
		quote = q
		author = a

var quotes : Array = [
	Quote.new("No matter how hard the past, you can always begin again.", "Buddha"),
	Quote.new("Not until we are lost we begin to find ourselves.", "Henry David Thoreau"),
	Quote.new("Turn your wounds into wisdom.", "Oprah Winfrey"),
	Quote.new("You have to break down before you can break through.", "Marilyn Ferguson"),
	Quote.new("Fall seven times and stand up eight.", "Japanese proverb"),
	Quote.new("Each morning we are born again. What we do today is what matter most.", "Buddha"),
	Quote.new("Do not let the behaviour of others destroy your inner peace.", "Dalai Lama"),
	Quote.new("If the jungle is withered and you want to restore it to life, you must water each tree of that jungle.", "S. N. Goenka")
]

onready var quote_label : Label = $Quote
onready var author_label : Label = $Author

var _previous_quote_idx : int = -1


func show() -> void:
	_rand_quote()
	.show()


func _rand_quote() -> void:
	var random_idx = randi() % quotes.size()
	
	if random_idx == _previous_quote_idx:
		random_idx = (random_idx+1) % quotes.size()
	
	_previous_quote_idx = random_idx
	
	var random_quote : Quote = quotes[random_idx]
	_show_quote(random_quote)


func _show_quote(quote:Quote) -> void:
	quote_label.text = "\"" + quote.quote + "\""
	author_label.text = quote.author
