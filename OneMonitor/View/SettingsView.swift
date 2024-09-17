import SwiftUI

struct SettingsView: View {
    @State private var invertSpeed = false
    @State private var flipHorizontally = false
    @State private var useSystemAccentColor = false
    @State private var selectRandomlyPerTenMinutes = true
    @State private var selectFromAllRunners = true
    @State private var selectFromOnlyMonochromeRunners = false
    @State private var stopTheRunner = false
    @State private var launchAtLogin = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 15) {
                Group {
                    SettingsSectionView(header: "General") {
                        // 设置项（如有）
                    }

                    SettingsSectionView(header: "Runner") {
                        ToggleView(title: "Invert speed", description: "Invert the speed of the runner.", isOn: $invertSpeed)

                        ToggleView(title: "Flip horizontally", description: "Flip the runner horizontally.", isOn: $flipHorizontally)

                        ToggleView(title: "Use the system accent color", description: "Use the system accent color for the runner.", isOn: $useSystemAccentColor)

                        ToggleView(title: "Select randomly per 10 minutes automatically", description: "Automatically select a new runner every 10 minutes.", isOn: $selectRandomlyPerTenMinutes, onChange: { newValue in
                            if newValue {
                                self.selectFromAllRunners = true
                                self.selectFromOnlyMonochromeRunners = false
                            }
                        })

                        HStack {
                            ToggleView(title: "Select from all runners", description: "Select runners from all available runners.", isOn: $selectFromAllRunners)
                            ToggleView(title: "Select from only monochrome runners", description: "Select runners from only monochrome runners.", isOn: $selectFromOnlyMonochromeRunners)
                        }
                        
                        ToggleView(title: "Stop the runner", description: "Stop the runner from running.", isOn: $stopTheRunner)
                    }
                    
                    SettingsSectionView(header: "Launch") {
                        ToggleView(title: "Launch RunCat automatically at login", description: "Automatically launch RunCat when the system starts.", isOn: $launchAtLogin)
                    }
                }
            }
            .padding()
            .background(Color(NSColor.windowBackgroundColor)) // 设置背景为系统窗口背景颜色
        }
        .padding()
        .background(Color(NSColor.windowBackgroundColor)) // 用您需要的背景色替换
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: {
                    print("Open System Info page")
                }) {
                    Image(systemName: "info.circle.fill")
                        .imageScale(.large)
                        .foregroundColor(.blue)
                }
            }
        }
    }
}

struct SettingsSectionView<Content: View>: View {
    var header: String
    @ViewBuilder var content: () -> Content

    var body: some View {
        VStack(alignment: .leading) {
            Text(header)
                .font(.headline)
                .padding(.bottom, 5)
            content()
                .padding(.vertical, 10)
                .background(Color.clear)
                .padding(.horizontal)

            Divider()
        }
    }
}

struct ToggleView: View {
    var title: String
    var description: String
    @Binding var isOn: Bool
    var onChange: ((Bool) -> Void)? = nil
    
    var body: some View {
        HStack {
            Toggle(isOn: $isOn.onChange(onChange)) {
                Text(title)
                    .font(.headline)
                Text(description)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding(.horizontal)
        .background(Color.clear)
        .cornerRadius(5)
    }
}

extension Binding {
    func onChange(_ onChange: ((Value) -> Void)?) -> Binding<Value> {
        return Binding<Value>(
            get: { self.wrappedValue },
            set: { newValue in
                self.wrappedValue = newValue
                onChange?(newValue)
            }
        )
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
