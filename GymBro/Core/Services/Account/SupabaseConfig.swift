import Foundation

/// Values from Supabase → Project Settings → API. The publishable key is safe
/// to ship in the client; the secret key must never appear here.
enum SupabaseConfig {
    static let url = URL(string: "https://pupctsauradrgjfjbyyz.supabase.co")!
    static let publishableKey = "sb_publishable_ejz7SLTYKX5izl64NB_GKg_eWes1rUC"
}
