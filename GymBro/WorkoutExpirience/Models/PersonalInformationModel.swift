struct PersonalInformationModel {

	var name: String
	var age: String
	var gender: String
	var weight: String
	var height: String

	init(
		name: String = "",
		age: String = "",
		gender: String = "",
		weight: String = "",
		height: String = ""
	) {
		self.name = name
		self.age = age
		self.gender = gender
		self.weight = weight
		self.height = height
	}
}
