import Foundation

/// Fill in from Supabase → Project Settings → API. Until both values are set
/// the app falls back to `MockAccountService`, so every flow keeps working.
enum SupabaseConfig {
    static let url = URL(string: "https://pupctsauradrgjfjbyyz.supabase.co")!
    static let publishableKey = "sb_publishable_ejz7SLTYKX5izl64NB_GKg_eWes1rUC"

    static var isConfigured: Bool {
        !publishableKey.hasPrefix("YOUR-") && !url.absoluteString.contains("YOUR-PROJECT-REF")
    }
}
