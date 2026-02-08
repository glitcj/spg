extends Node
class_name _MushMash_CatFacts

static var cat_facts := [
	"Cats like cat nips.",
	"Cats can see only 3 colours. They can't see the colours blue or pink.",
	]
	
static func sample_cat_fact():
	return cat_facts[randi() % len(cat_facts)]
