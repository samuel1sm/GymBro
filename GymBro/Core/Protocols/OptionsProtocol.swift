protocol OptionsProtocol: RawRepresentable, Equatable, CaseIterable where RawValue == String {

	var title: String { get }
}
