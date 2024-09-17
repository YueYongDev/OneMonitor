import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    static var popover = NSPopover()
    var statusBar: StatusBarController?
    var cpuInfo: CpuInfo?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Create the CpuInfo instance
        cpuInfo = CpuInfo.shared
        
        // Create the status bar controller and pass the CpuInfo instance
        if let cpuInfo = cpuInfo {
            statusBar = StatusBarController(Self.popover, cpuInfo: cpuInfo)
        }
        
        // Set the popover content view controller and pass the statusBarController
        if let statusBar = statusBar {
            let popoverView = PopoverView(statusBarController: statusBar)
            Self.popover.contentViewController = NSHostingController(rootView: popoverView)
        }
        
        // Hide the main window
        NSApplication.shared.windows.first?.close()
    }
}
