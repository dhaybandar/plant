//
//  HeaderView.swift
//  MyApp
//
//  Created by Dhay Bandar on 01/06/1448 AH.
//

import SwiftUI

// MARK: - Header "My Plants 🌱"

struct Header: View {
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("My Plants \(Image(systemName: "leaf.fill"))")
                    .font(.title2.bold())
                    .foregroundStyle(.white)
                Spacer()
            }
            .padding(.horizontal, 20)

            Divider()
                .overlay(Color(white: 0.2))
        }
        .padding(.top, 8)
        .padding(.bottom, 8)
    }
}

#Preview {
    ZStack {
        Theme.background.ignoresSafeArea()
        Header()
    }
    .preferredColorScheme(.dark)
}
