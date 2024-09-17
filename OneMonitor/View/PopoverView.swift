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
    var statusBarController: StatusBarController?

    var body: some View {
        HStack(alignment: .center, spacing: 20) {
            // System information cards
            GeometryReader { geometry in
                VStack(alignment: .center, spacing: 10) {
                    ForEach(sections.indices, id: \.self) { index in
                        SectionView(section: $sections[index], viewModel: viewModel)
                        if index < sections.count - 1 {
                            Divider()
                        }
                    }
                }
                .padding(3)
                .background(Color.white)
                .cornerRadius(10)
                .frame(height: geometry.size.height)
            }
            .frame(width: 250)

            // Functional buttons
            GeometryReader { geometry in
                VStack(alignment: .center, spacing: 10) {
                    MenuItem(icon: "cat", title: "Runners") {
                        showFrameCategorySelectionAlert()
                    }
                    
                    MenuItem(icon: "gear", title: "Settings") {
                        print("Settings button clicked")
                        openSettingsWindow()
                    }
                    
                    MenuItem(icon: "cart", title: "Store") {
                        print("Store button clicked")
                    }
                    
                    MenuItem(icon: "chart.bar", title: "Activity") {
                        print("Activity button clicked")
                        openScreenTimeSettings()
                    }
                    
                    MenuItem(icon: "xmark.circle", title: "Exit") {
                        print("Exit button clicked")
                        NSApplication.shared.terminate(nil)
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .frame(height: geometry.size.height)
            }
            .frame(width: 120)
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
                contentRect: NSRect(x: 0, y: 0, width: 400, height: 600),
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

    private func showFrameCategorySelectionAlert() {
        let alert = NSAlert()
        alert.messageText = "Select Frame Category"
        alert.addButton(withTitle: "Monkey")
        alert.addButton(withTitle: "Cat")
        alert.addButton(withTitle: "Rabbit")
        alert.addButton(withTitle: "Cancel")

        let response = alert.runModal()
        switch response {
        case .alertFirstButtonReturn:
            statusBarController?.switchCategory(to: .monkey)
        case .alertSecondButtonReturn:
            statusBarController?.switchCategory(to: .cat)
        case .alertThirdButtonReturn:
            statusBarController?.switchCategory(to: .rabbit)
        default:
            break
        }
    }
}
