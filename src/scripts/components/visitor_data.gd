class_name VisitorData extends Resource

enum Sex {
	MALE,
	FEMALE
}

enum Personalities {
	NEUTRAL,
	CALM,
	AGGRESSIVE,
	NERVOUS,
	CONFUSED,
	EVASIVE
}

enum Places_Of_Origin {
	Kantric
}

enum Blood_Types {
	O,
	A,
	B,
	AB
}

@export var first_name: String = "John"
@export var last_name: String = "Doe"

@export var sex: Sex = Sex.MALE
@export var age: int = 20

@export var answers: Array[String] = ["", "", ""]
@export var infected: bool = false

@export var symptoms: Array[SymptomData]
@export var blood_type: Blood_Types
@export var place_of_origin: Places_Of_Origin
