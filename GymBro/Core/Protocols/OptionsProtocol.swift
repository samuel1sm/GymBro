protocol OptionsProtocol: RawRepresentable, CaseIterable where RawValue == String {

	var title: String { get }
}
