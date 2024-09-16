//
//  CircleProgressBar.swift
//  OneMonitor
//
//  Created by EnochLiang on 2024/9/16.
//

import SwiftUI

struct CircleProgressBar: View {
    @Binding var title: String
    var color: Color
    @Binding var progress: Double
    @Binding var imageString: String

    var body: some View {
        ZStack {
            Circle()
                    .stroke(Color.gray.opacity(0.3), lineWidth: 5)

            Circle()
                    .trim(from: 0.0, to: CGFloat(progress))
                    .stroke(color, lineWidth: 5)
                    .rotationEffect(Angle(degrees: -90))

            VStack(spacing: 0) {
                Image(systemName: imageString)
                Text("\(title)").font(.subheadline)
            }
        }
    }
}


