//
//  GymBroApp.swift
//  GymBro
//
//  Created by Samuel Martins on 04/04/26.
//

import SwiftUI

@main
struct GymBroApp: App {
    
    init() {
        FontRegistrar.registerAll()
    }
    
    var body: some Scene {
        WindowGroup {
			FirstOnboardingView()
        }
    }
}
