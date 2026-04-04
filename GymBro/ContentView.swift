//
//  ContentView.swift
//  GymBro
//
//  Created by Samuel Martins on 04/04/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
			Text("Hello, world!").font(.heroLG()).foregroundStyle(.flame)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
