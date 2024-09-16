import SwiftUI

@main
struct OneMonitorApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            PopoverView()
        }
    }
}
