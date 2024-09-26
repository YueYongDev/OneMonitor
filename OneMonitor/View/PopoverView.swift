import SwiftUI
import AppKit

struct PopoverView: View {
    // Define constants for layout
    private let sectionWidth: CGFloat = 250
    private let buttonWidth: CGFloat = 120
    private let popoverHeight: CGFloat = 450
    
    
    @State private var sections = [
        SectionData(title: "CPU", image: "cpu", color: .red),
        SectionData(title: "MEM", image: "memorychip", color: .green),
        SectionData(title: "DISK", image: "opticaldiscdrive", color: .yellow),
        SectionData(title: "BATTERY", image: "battery.50", color: .blue),
        SectionData(title: "NET", image: "network", color: .purple)
    ]
    
    @StateObject var viewModel = PopoverViewModel()
    @State private var settingsWindowController: NSWindowController?
    // 定义一个用于持久存储窗口的字典
    @State private var storeWindow: NSWindow?
    @State private var coffeeWindow: NSWindow?
    var statusBarController: StatusBarController?

    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            // System information cards
            sectionView
            // Functional buttons
            buttonView
        }
        .frame(height: popoverHeight)
        .padding(EdgeInsets(top: 2, leading: 20, bottom: 2, trailing: 5))
        .background(Color.white)
        .cornerRadius(10)
    }

    private var sectionView: some View {
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
        .frame(width: sectionWidth)
    }

    private var buttonView: some View {
        GeometryReader { geometry in
            VStack(alignment: .center, spacing: 5) { // 设置间距
                MenuItem(icon: "cat", title: "Runners") {
                    showFrameCategorySelectionAlert()
                }
                MenuItem(icon: "gear", title: "Settings") {
                    openSettingsWindow()
                }
                MenuItem(icon: "cart", title: "Store") {
                    openStoreWindow() // 打开 Store 窗口
                }
                MenuItem(icon: "cup.and.saucer.fill", title: "Coffee") {
                    openCoffeeWindow() // 打开 Coffee 窗口
                }
                MenuItem(icon: "chart.bar", title: "Activity") {
                    openScreenTimeSettings()
                }
                MenuItem(icon: "xmark.circle", title: "Exit") {
                    NSApplication.shared.terminate(nil)
                }
            }
            .padding(3)
            .background(Color.white)
            .cornerRadius(10)
            .frame(maxWidth: geometry.size.width, maxHeight: geometry.size.height)
        }
        .frame(width: buttonWidth)
        .frame(maxHeight: .infinity) // 确保高度填满
    }
    
    // 打开 Store 窗口的方法
    private func openStoreWindow() {
        if storeWindow == nil {
            storeWindow = NSWindow(
                contentRect: NSRect(x: 0, y: 0, width: 300, height: 150),
                styleMask: [.titled, .closable],
                backing: .buffered, defer: false)
            storeWindow?.center()
            storeWindow?.title = "Store"

            let storeContent = ComingSoonView()
            storeWindow?.contentView = NSHostingView(rootView: storeContent)
        }
        
        storeWindow?.makeKeyAndOrderFront(nil) // 显示窗口
    }

    // 打开 Coffee 窗口的方法
    private func openCoffeeWindow() {
        if coffeeWindow == nil {
            coffeeWindow = NSWindow(
                contentRect: NSRect(x: 0, y: 0, width: 300, height: 150),
                styleMask: [.titled, .closable],
                backing: .buffered, defer: false)
            coffeeWindow?.center()
            coffeeWindow?.title = "Thank You!"

            let coffeeContent = ThankYouView()
            coffeeWindow?.contentView = NSHostingView(rootView: coffeeContent)
        }

        coffeeWindow?.makeKeyAndOrderFront(nil) // 显示窗口
    }

    // Store 窗口的内容视图
    struct ComingSoonView: View {
        var body: some View {
            VStack {
                Text("敬请期待！")
                    .font(.largeTitle)
                    .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(NSColor.windowBackgroundColor))
        }
    }

    // Coffee 窗口的内容视图
    struct ThankYouView: View {
        var body: some View {
            VStack {
                Text("Thank you for your coffee!")
                    .font(.largeTitle)
                    .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(NSColor.windowBackgroundColor))
        }
    }

    // Remaining methods: openSettingsWindow, openScreenTimeSettings, showFrameCategorySelectionAlert...
    
    private func openSettingsWindow() {
        // 如果不存在设置窗口控制器，则创建一个新的
        if settingsWindowController == nil {
            // 创建新的窗口
            let settingsWindow = NSWindow(
                contentRect: NSRect(x: 0, y: 0, width: 400, height: 600),
                styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
                backing: .buffered, defer: false)
            
            // 确保窗口在屏幕中居中
            settingsWindow.title = "Settings"
            settingsWindow.center()
            settingsWindow.setFrameAutosaveName("Settings Window") // 自动保存窗口位置与大小
            
            // 将 SwiftUI 视图嵌入窗口中
            settingsWindow.contentView = NSHostingView(rootView: SettingsView())
            
            // 创建窗口控制器
            settingsWindowController = NSWindowController(window: settingsWindow)
        }
        
        // 显示窗口
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
//        alert.addButton(withTitle: "Monkey")
        alert.addButton(withTitle: "Cat")
        alert.addButton(withTitle: "Rabbit")
        alert.addButton(withTitle: "Cancel")
        let response = alert.runModal()
        switch response {
        case .alertFirstButtonReturn:
            statusBarController?.switchCategory(to: .cat)
        case .alertSecondButtonReturn:
            statusBarController?.switchCategory(to: .rabbit)
//        case .alertThirdButtonReturn:
//            statusBarController?.switchCategory(to: .rabbit)
        default:
            break
        }
    }
}
