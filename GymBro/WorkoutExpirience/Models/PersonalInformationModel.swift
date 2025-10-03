struct PersonalInformationModel {

	var name: String
	var age: String
	var gender: SexOptions?
	var weight: String
	var height: String

	init(
		name: String = "",
		age: String = "",
		gender: SexOptions? = nil,
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
