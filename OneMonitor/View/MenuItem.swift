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
            VStack {
                Image(systemName: icon) // 使用系统图标
                    .resizable() // 使图标可调整大小
                    .scaledToFit() // 保持比例
                    .frame(width: 20, height: 20) // 调整图标大小
                Text(title) // 文字在下
                    .font(.caption) // 小字体
                    .multilineTextAlignment(.center) // 居中对齐
            }
            .padding()
            .frame(maxWidth: .infinity) // 填满宽度
            .background(Color.gray.opacity(0.1))
            .cornerRadius(5)
        }
        .buttonStyle(PlainButtonStyle()) // 防止按钮默认样式影响
    }
}

