protocol OptionsProtocol: RawRepresentable, Hashable, Equatable, CaseIterable where RawValue == String {

	var title: String { get }
}
