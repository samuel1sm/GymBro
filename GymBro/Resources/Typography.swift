
import SwiftUI
import CoreText

// MARK: - Font Registration

/// Call `FontRegistrar.registerAll()` once at app launch (already wired in GymBroApp).
enum FontRegistrar {

    private static var registered = false

    static func registerAll() {
        guard !registered else { return }
        registered = true

        let fontNames: [String] = [
            // Barlow Condensed — 700, 800, 900
            "BarlowCondensed-Bold",
            "BarlowCondensed-BoldItalic",
            "BarlowCondensed-ExtraBold",
            "BarlowCondensed-ExtraBoldItalic",
            "BarlowCondensed-Black",
            "BarlowCondensed-BlackItalic",
            // Plus Jakarta Sans — 400, 500, 600, 700
            "PlusJakartaSans-Regular",
            "PlusJakartaSans-Italic",
            "PlusJakartaSans-Medium",
            "PlusJakartaSans-MediumItalic",
            "PlusJakartaSans-SemiBold",
            "PlusJakartaSans-SemiBoldItalic",
            "PlusJakartaSans-Bold",
            "PlusJakartaSans-BoldItalic",
        ]

        for name in fontNames {
            guard let url = Bundle.main.url(forResource: name, withExtension: "ttf") else {
                print("❌ Font not found in bundle: \(name).ttf")
                assertionFailure("⚠️ Font not found in bundle: \(name).ttf")
                continue
            }
            
            var error: Unmanaged<CFError>?
            let success = CTFontManagerRegisterFontsForURL(url as CFURL, .process, &error)
            
            if success {
                print("✅ Successfully registered font: \(name)")
            } else {
                print("❌ Failed to register font: \(name)")
                if let error = error?.takeRetainedValue() {
                    print("   Error: \(error)")
                }
            }
        }
    }
}

// MARK: - Barlow Condensed

extension Font {

    // MARK: Weight tokens

    enum BarlowCondensedWeight {
        /// 700 — workout names, section labels
        case bold
        /// 800 — hero sub-headings
        case extraBold
        /// 900 — hero numbers, screen titles
        case black

        fileprivate var postscriptName: String {
            switch self {
            case .bold:      return "BarlowCondensed-Bold"
            case .extraBold: return "BarlowCondensed-ExtraBold"
            case .black:     return "BarlowCondensed-Black"
            }
        }

        fileprivate var italicPostscriptName: String {
            switch self {
            case .bold:      return "BarlowCondensed-BoldItalic"
            case .extraBold: return "BarlowCondensed-ExtraBoldItalic"
            case .black:     return "BarlowCondensed-BlackItalic"
            }
        }
    }

    /// Barlow Condensed — used for hero numbers, workout names, and heavy condensed typography.
    static func barlowCondensed(_ weight: BarlowCondensedWeight, size: CGFloat, italic: Bool = false) -> Font {
        let name = italic ? weight.italicPostscriptName : weight.postscriptName
        return .custom(name, size: size)
    }

    // MARK: Named scale — Barlow Condensed

    /// 56 pt Black — hero numbers (scores, weights, PR values)
    static func heroXL(_ italic: Bool = false) -> Font { .barlowCondensed(.black, size: 56, italic: italic) }
    /// 40 pt Black — screen titles, session names
    static func heroLG(_ italic: Bool = false) -> Font { .barlowCondensed(.black, size: 40, italic: italic) }
    /// 32 pt ExtraBold — card headings, exercise names in detail view
    static func displayMD(_ italic: Bool = false) -> Font { .barlowCondensed(.extraBold, size: 32, italic: italic) }
    /// 24 pt Bold — section headers, set group labels
    static func headingSM(_ italic: Bool = false) -> Font { .barlowCondensed(.bold, size: 24, italic: italic) }
}

// MARK: - Plus Jakarta Sans

extension Font {

    // MARK: Weight tokens

    enum PlusJakartaSansWeight {
        /// 400 — body text, descriptions
        case regular
        /// 500 — metadata, secondary labels
        case medium
        /// 600 — sub-headings, chip labels, nav items
        case semiBold
        /// 700 — CTA labels, emphasis
        case bold

        fileprivate var postscriptName: String {
            switch self {
            case .regular:  return "PlusJakartaSans-Regular"
            case .medium:   return "PlusJakartaSans-Medium"
            case .semiBold: return "PlusJakartaSans-SemiBold"
            case .bold:     return "PlusJakartaSans-Bold"
            }
        }

        fileprivate var italicPostscriptName: String {
            switch self {
            case .regular:  return "PlusJakartaSans-Italic"
            case .medium:   return "PlusJakartaSans-MediumItalic"
            case .semiBold: return "PlusJakartaSans-SemiBoldItalic"
            case .bold:     return "PlusJakartaSans-BoldItalic"
            }
        }
    }

    /// Plus Jakarta Sans — body text and all standard UI elements.
    static func plusJakartaSans(_ weight: PlusJakartaSansWeight, size: CGFloat, italic: Bool = false) -> Font {
        let name = italic ? weight.italicPostscriptName : weight.postscriptName
        return .custom(name, size: size)
    }

    // MARK: Named scale — Plus Jakarta Sans

	/// 17 pt SemiBold — Buttons titles
	static func buttonTitle() -> Font { .plusJakartaSans(.bold, size: 18) }
    /// 17 pt SemiBold — navigation bar titles
    static func navTitle() -> Font { .plusJakartaSans(.semiBold, size: 18) }
    /// 15 pt SemiBold — button labels, chip labels, active tab labels
    static func labelMD() -> Font { .plusJakartaSans(.semiBold, size: 16) }
    /// 15 pt Regular — body text, exercise descriptions
    static func bodyMD() -> Font { .plusJakartaSans(.regular, size: 16) }
    /// 13 pt Medium — metadata (sets · reps · rest), suggested dates
    static func bodySM() -> Font { .plusJakartaSans(.medium, size: 14) }
    /// 12 pt Regular — captions, chart axis labels, section headers
    static func caption() -> Font { .plusJakartaSans(.regular, size: 12) }
    /// 11 pt Medium — tab bar labels, badges, inline tags
    static func micro() -> Font { .plusJakartaSans(.medium, size: 10) }
}

// MARK: - UIFont convenience (UIKit / UIAppearance)

extension UIFont {

    static func barlowCondensed(_ weight: Font.BarlowCondensedWeight, size: CGFloat) -> UIFont {
        UIFont(name: weight.postscriptName, size: size) ?? .systemFont(ofSize: size, weight: .black)
    }

    static func plusJakartaSans(_ weight: Font.PlusJakartaSansWeight, size: CGFloat) -> UIFont {
        UIFont(name: weight.postscriptName, size: size) ?? .systemFont(ofSize: size)
    }
}
