//
//  StatusBarController.swift
//  OneTracker
//
//  Created by Max Kuznetsov on 16.03.2023.
//

import AppKit

class StatusBarController {
    private var statusBar: NSStatusBar
    private(set) var statusItem: NSStatusItem
    private(set) var popover: NSPopover

    init(_ popover: NSPopover) {
        self.popover = popover
        self.popover.behavior = .transient

        statusBar = .init()
        statusItem = statusBar.statusItem(withLength: NSStatusItem.variableLength)

        if let button = statusItem.button {
            button.image = NSImage(named: NSImage.Name("radar-white"))
            button.action = #selector(showApp)
            button.target = self
        }
    }

    @objc func showApp(sender: AnyObject) {
        if popover.isShown {
            popover.performClose(nil)
        } else {
            popover.show(relativeTo: statusItem.button!.bounds, of: statusItem.button!, preferredEdge: .maxY)
        }
    }


}


//import AppKit
//
//class StatusBarController {
//    private var statusBar: NSStatusBar
//    private(set) var statusItem: NSStatusItem
//    private(set) var popover: NSPopover
//    private var imageView: NSImageView
//    private var animationFrames: [NSImage] = []
//    private var currentFrameIndex: Int = 0
//    private var animationTimer: Timer?
//
//    init(_ popover: NSPopover) {
//        self.popover = popover
//        self.popover.behavior = .transient
//
//        statusBar = .init()
//        statusItem = statusBar.statusItem(withLength: NSStatusItem.variableLength)
//
//        // Initialize the image view
//        imageView = NSImageView(frame: NSRect(x: 0, y: 0, width: 20, height: 20))
//
//        // Load animation frames
//        for i in 1...3 { // Assuming you have 3 frames
//            if let frame = NSImage(named: "frame\(i)") {
//                animationFrames.append(frame)
//            }
//        }
//
//        if let button = statusItem.button {
//            button.addSubview(imageView)
//            button.action = #selector(showApp)
//            button.target = self
//
//            // Start the animation
//            startAnimation()
//        }
//    }
//
//    @objc func showApp(sender: AnyObject) {
//        if popover.isShown {
//            popover.performClose(nil)
//        } else {
//            popover.show(relativeTo: statusItem.button!.bounds, of: statusItem.button!, preferredEdge: .maxY)
//        }
//    }
//
//    private func startAnimation() {
//        animationTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateAnimation), userInfo: nil, repeats: true)
//    }
//
//    @objc private func updateAnimation() {
//        if currentFrameIndex >= animationFrames.count {
//            currentFrameIndex = 0
//        }
//        imageView.image = animationFrames[currentFrameIndex]
//        currentFrameIndex += 1
//    }
//
//    deinit {
//        animationTimer?.invalidate()
//    }
//}
