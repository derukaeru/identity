class_name VisitorData extends Resource

enum Sex {
	MALE,
	FEMALE
}

enum Personality {
	NEUTRAL,
	CALM,
	AGGRESSIVE,
	NERVOUS,
	CONFUSED,
	EVASIVE
}

@export var first_name: String = "John"
@export var last_name: String = "Doe"

@export var sex: Sex = Sex.MALE
@export var age: int = 20

@export var answers: Array[String] = ["", "", ""]
@export var infected: bool = false
