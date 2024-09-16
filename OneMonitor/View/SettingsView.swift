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
        VStack {
            List {
                Text("Settings")
                    .font(.largeTitle)
                    .padding(.bottom, 20)
                
                Section(header: Text("General").font(.headline)) {
                    // 设置项
                }

                Section(header: Text("Runner").font(.headline)) {
                    Toggle(isOn: $invertSpeed) {
                        Text("Invert speed")
                        Text("Invert the speed of the runner.")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    Toggle(isOn: $flipHorizontally) {
                        Text("Flip horizontally")
                        Text("Flip the runner horizontally.")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    Toggle(isOn: $useSystemAccentColor) {
                        Text("Use the system accent color")
                        Text("Use the system accent color for the runner.")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    Toggle(isOn: $selectRandomlyPerTenMinutes) {
                        Text("Select randomly per 10 minutes automatically")
                        Text("Automatically select a new runner every 10 minutes.")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .onChange(of: selectRandomlyPerTenMinutes) { newValue in
                        if newValue {
                            self.selectFromAllRunners = true
                            self.selectFromOnlyMonochromeRunners = false
                        }
                    }
                    HStack {
                        Toggle(isOn: $selectFromAllRunners) {
                            Text("Select from all runners")
                            Text("Select runners from all available runners.")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        Toggle(isOn: $selectFromOnlyMonochromeRunners) {
                            Text("Select from only monochrome runners")
                            Text("Select runners from only monochrome runners.")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    Toggle(isOn: $stopTheRunner) {
                        Text("Stop the runner")
                        Text("Stop the runner from running.")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }

                Section(header: Text("Launch").font(.headline)) {
                    Toggle(isOn: $launchAtLogin) {
                        Text("Launch RunCat automatically at login")
                        Text("Automatically launch RunCat when the system starts.")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
            }
            .listStyle(SidebarListStyle())
            .background(Color.white) // 设置背景颜色为白色
        }
        .padding()
        .background(Color.white) // 设置 VStack 的背景颜色为白色
        .cornerRadius(10) // 添加圆角
        .shadow(radius: 5) // 添加阴影
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

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
