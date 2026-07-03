import Foundation

enum EquipmentOption: String, CaseIterable, Hashable {
    case bodyweightOnly  = "Bodyweight Only"
    case dumbbells       = "Dumbbells"
    case barbellPlates   = "Barbell & Plates"
    case kettlebells     = "Kettlebells"
    case resistanceBands = "Resistance Bands"
    case pullupBar       = "Pull-up Bar"
    case cableMachine    = "Cable Machine"
    case fullGym         = "Full Commercial Gym"
}
