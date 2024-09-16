import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    static var popover = NSPopover()
    var statusBar: StatusBarController?
    var cpuInfo: CpuInfo?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Create the CpuInfo instance
        cpuInfo = CpuInfo.shared
        
        // Set the popover content view controller
        Self.popover.contentViewController = NSHostingController(rootView: PopoverView())
        
        // Create the status bar controller and pass the CpuInfo instance
        if let cpuInfo = cpuInfo {
            statusBar = StatusBarController(Self.popover, cpuInfo: cpuInfo)
        }
        
        // Hide the main window
        NSApplication.shared.windows.first?.close()
    }
}
