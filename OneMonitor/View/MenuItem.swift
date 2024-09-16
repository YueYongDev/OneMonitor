//
//  MenuItem.swift
//  OneMonitor
//
//  Created by EnochLiang on 2024/9/16.
//

import SwiftUI

struct MenuItem: View {
    var icon: String
    var title: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 2) {
                Image(systemName: icon)
                    .font(.title)
                Text(title)
                    .font(.subheadline)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}
