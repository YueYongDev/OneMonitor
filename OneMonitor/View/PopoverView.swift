import SwiftUI
import AppKit

struct PopoverView: View {
    @State private var sections = [
        SectionData(title: "CPU", image: "cpu", color: .red),
        SectionData(title: "MEM", image: "memorychip", color: .green),
        SectionData(title: "DISK", image: "opticaldiscdrive", color: .yellow),
        SectionData(title: "ACC", image: "battery.50", color: .blue),
        SectionData(title: "NET", image: "network", color: .purple)
    ]

    @StateObject var viewModel = PopoverViewModel()
    @State private var settingsWindowController: NSWindowController?

    var body: some View {
        HStack(alignment: .center) {
            // 系统信息卡片
            GeometryReader { geometry in
                VStack(alignment: .center, spacing: 10) {
                    ForEach(sections.indices, id: \.self) { index in
                        HStack(alignment: .top, spacing: 15) {
                            CircleProgressBar(
                                    title: $sections[index].title,
                                    color: sections[index].color,
                                    progress: progressBinding(for: index),
                                    imageString: $sections[index].image
                            ).frame(width: 50, height: 50)

                            VStack(alignment: .leading, spacing: 5) {
                                switch sections[index].title {
                                case "MEM":
                                    Text("Usage: \(viewModel.memTotal ?? "N/D")")
                                    Text("Compressed: \(viewModel.memCompressed ?? "N/D")")
                                    Text("Wired: \(viewModel.memWired ?? "N/D")")
                                case "CPU":
                                    Text("System: \(viewModel.cpuSystem ?? "N/D")")
                                    Text("User: \(viewModel.cpuUser ?? "N/D")")
                                    Text("Idle: \(viewModel.cpuIdle ?? "N/D")")
                                case "DISK":
                                    Text("Total: \(viewModel.diskTotal ?? "N/D")")
                                    Text("Used: \(viewModel.diskUsed ?? "N/D")")
                                    Text("Free: \(viewModel.diskFree ?? "N/D")")
                                case "ACC":
                                    Text("Time left: \(viewModel.batteryTimeLeft ?? "N/D")")
                                    Text("Temperature: \(viewModel.batteryTemperature ?? "N/D")")
                                    Text("Cycle Count: \(viewModel.batteryCycles ?? "N/D")")
                                case "NET":
                                    Text("Local IP: \(viewModel.networkIP ?? "N/D")")
                                    Text("Upload: \(viewModel.uploadSpeed ?? "N/D")")
                                    Text("Download: \(viewModel.downloadSpeed ?? "N/D")")
                                default:
                                    EmptyView()
                                }
                            }
                            Spacer() // 确保内容在水平方向上两端对齐
                        }
                        if index < sections.count - 1 {
                            Divider()
                        }
                    }
                }
                .padding(3)
                .background(Color.white)
                .cornerRadius(10)
                .frame(height: geometry.size.height) // 设置高度与 GeometryReader 的高度一致
            }
            .frame(width: 250) // 设置系统信息卡片的宽度为 230

            // 功能列表卡片
            GeometryReader { geometry in
                VStack(alignment: .center, spacing: 10) {
                    MenuItem(icon: "cat", title: "Runners") {
                        // 处理 Runners 按钮点击事件
                        print("Runners button clicked")
                    }
                    

                    Button(action: {
                        openSettingsWindow()
                    }) {
                        MenuItem(icon: "gear", title: "Settings") {
                            // 处理 Settings 按钮点击事件
                            print("Settings button clicked")
                        }
                    }
                    

                    MenuItem(icon: "cart", title: "Store") {
                        // 处理 Store 按钮点击事件
                        print("Store button clicked")
                    }
                    

                    Button(action: {
                        openScreenTimeSettings()
                    }) {
                        MenuItem(icon: "chart.bar", title: "Activity") {
                            // 处理 Activity 按钮点击事件
                            print("Activity button clicked")
                        }
                    }
                    .frame(width: 80, height: 80)
                    

                    Button(action: {
                        NSApplication.shared.terminate(nil)
                    }) {
                        MenuItem(icon: "xmark.circle", title: "Exit") {
                            // 处理 Exit 按钮点击事件
                            print("Exit button clicked")
                        }
                    }
                    .frame(width: 80, height: 80)
                    
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .frame(height: geometry.size.height) // 设置高度与 GeometryReader 的高度一致
            }
            .frame(width: 120) // 设置功能列表卡片的宽度为 120
        }
        .frame(height: 450)
        .padding()
        .background(Color.white)
        .cornerRadius(10)
    }

    private func progressBinding(for index: Int) -> Binding<Double> {
        switch index {
        case 0: return $viewModel.cpuProgress
        case 1: return $viewModel.memProgress
        case 2: return $viewModel.diskProgress
        case 3: return $viewModel.batteryProgress
        default: return .constant(0.0)
        }
    }

    private func openSettingsWindow() {
        if settingsWindowController == nil {
            let settingsWindow = NSWindow(
                contentRect: NSRect(x: 0, y: 0, width: 400, height: 600), // 调整窗口高度
                styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
                backing: .buffered, defer: false)
            settingsWindow.center()
            settingsWindow.setFrameAutosaveName("Settings Window")
            settingsWindow.contentView = NSHostingView(rootView: SettingsView())
            settingsWindowController = NSWindowController(window: settingsWindow)
        }
        settingsWindowController?.showWindow(nil)
    }
    
    private func openScreenTimeSettings() {
            if let url = URL(string: "x-apple.systempreferences:com.apple.Screen-Time-Settings.extension") {
                NSWorkspace.shared.open(url)
            }
        }
}

struct SectionData {
    var title: String
    var image: String
    var color: Color
}

