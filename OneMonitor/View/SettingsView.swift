import SwiftUI

struct SettingsView: View {
    @AppStorage("invertSpeed") private var invertSpeed = false
    @AppStorage("flipHorizontally") private var flipHorizontally = false
    @AppStorage("useSystemAccentColor") private var useSystemAccentColor = false
    @AppStorage("selectRandomlyPerTenMinutes") private var selectRandomlyPerTenMinutes = true
    @AppStorage("selectFromAllRunners") private var selectFromAllRunners = true
    @AppStorage("selectFromOnlyMonochromeRunners") private var selectFromOnlyMonochromeRunners = false
    @AppStorage("stopTheRunner") private var stopTheRunner = false
    @AppStorage("launchAtLogin") private var launchAtLogin = false

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // 个人信息部分
                settingsSection(header: "Launch") {
                    ToggleView(title: "Launch RunCat automatically at login",
                               description: "Automatically launch RunCat when the system starts.",
                               isOn: $launchAtLogin)
                }

                Divider()

                // 通知设置部分
                settingsSection(header: "Runner Settings") {
                    
                    ToggleView(title: "Invert speed",
                               description: "Invert the speed of the runner.",
                               isOn: $invertSpeed)

                    ToggleView(title: "Flip horizontally",
                               description: "Flip the runner horizontally.",
                               isOn: $flipHorizontally)

                    ToggleView(title: "Use the system accent color",
                               description: "Use the system accent color for the runner.",
                               isOn: $useSystemAccentColor)

                    ToggleView(title: "Stop the runner",
                               description: "Stop the runner from running.",
                               isOn: $stopTheRunner)
                }
            }
            .padding()
            .background(Color(NSColor.windowBackgroundColor))
            .frame(maxWidth: 800)
        }
        .padding()
        .background(Color(NSColor.windowBackgroundColor))
    }

    private func settingsSection<Content: View>(header: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(header)
                .font(.title2)
                .fontWeight(.bold)
                .padding(.bottom, 5)

            content()
                .padding()
                .background(Color(NSColor.controlBackgroundColor))
                .cornerRadius(10)
                .frame(maxWidth: .infinity)
        }
    }
}

struct ToggleView: View {
    var title: String
    var description: String
    @Binding var isOn: Bool

    var body: some View {
        VStack(alignment: .leading) {
            Toggle(isOn: $isOn) {
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.headline)
                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .toggleStyle(CustomToggleStyle())
        }
    }
}

struct CustomToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
                .foregroundColor(.primary) // 标签颜色
            Spacer()
            Button(action: {
                configuration.isOn.toggle()
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(configuration.isOn ? Color.green : Color.gray.opacity(0.5))
                        .frame(width: 50, height: 30)
                    Circle()
                        .fill(Color.white)
                        .frame(width: 26, height: 26)
                        .padding(.horizontal, configuration.isOn ? 0 : 4)
                        .offset(x: configuration.isOn ? 10 : -10) // 开关的位置
                        .animation(.easeInOut(duration: 0.2), value: configuration.isOn)
                }
            }.buttonStyle(PlainButtonStyle()) // 去掉按钮样式的默认边框
        }
        .padding(.vertical, 5) // 减少上下间距
    }
}

struct RadioButton: View {
    var label: String
    @Binding var isSelected: Bool

    var body: some View {
        Button(action: {
            isSelected.toggle()
        }) {
            HStack {
                Image(systemName: isSelected ? "largecircle.fill.circle" : "circle") // 选择状态
                    .foregroundColor(isSelected ? .blue : .gray)
                Text(label)
                    .font(.subheadline)
                    .foregroundColor(.primary)
            }
            .padding(.vertical, 5)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
