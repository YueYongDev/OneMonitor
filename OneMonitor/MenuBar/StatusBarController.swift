import AppKit

class StatusBarController {
    private let statusBar: NSStatusBar
    private let statusItem: NSStatusItem
    private let popover: NSPopover
    private let cpuInfo: CpuInfo

    private var animationTimer: Timer?
    private var currentFrameIndex: Int = 0
    private var animationFrames: [NSImage] = []

    enum FrameCategory: String {
        case monkey = "monkey_frame"
        case cat = "cat_frame"
        case rabbit = "rabbit_frame"
    }

    private var currentCategory: FrameCategory = .monkey {
        didSet {
            updateFrames(for: currentCategory)
        }
    }

    init(_ popover: NSPopover, cpuInfo: CpuInfo) {
        self.popover = popover
        self.popover.behavior = .transient
        self.cpuInfo = cpuInfo

        statusBar = .init()
        statusItem = statusBar.statusItem(withLength: NSStatusItem.variableLength)

        // Initialize with the default category
        updateFrames(for: currentCategory)

        if let button = statusItem.button {
            button.action = #selector(showApp)
            button.target = self
        }

        startAnimation()
    }

    func startAnimation() {
        updateAnimationTimer()
    }

    private func updateAnimationTimer() {
        animationTimer?.invalidate()

        let cpuPercentage = cpuInfo.percentage
        let baseInterval = 0.2
        let maxAdjustment = 0.15

        let adjustment = min(maxAdjustment, max(0.0, (cpuPercentage / 100.0) * maxAdjustment))
        let timeInterval = max(0.05, baseInterval - adjustment)

        animationTimer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(updateAnimation), userInfo: nil, repeats: true)
    }

    @objc func updateAnimation() {
        guard let button = statusItem.button else { return }

        // Ensure that animationFrames is not empty
        guard !animationFrames.isEmpty else {
            print("Animation frames are empty. Stopping animation.")
            animationTimer?.invalidate()
            return
        }

        currentFrameIndex = (currentFrameIndex + 1) % animationFrames.count
        button.image = animationFrames[currentFrameIndex]

        cpuInfo.update()
        updateAnimationTimer()
    }

    @objc func showApp(sender: AnyObject) {
        if popover.isShown {
            popover.performClose(nil)
        } else {
            popover.show(relativeTo: statusItem.button!.bounds, of: statusItem.button!, preferredEdge: .maxY)
        }
    }

    deinit {
        animationTimer?.invalidate()
    }

    func switchCategory(to category: FrameCategory) {
        currentCategory = category
    }

    private func updateFrames(for category: FrameCategory) {
        animationFrames.removeAll()

        var frameNumber = 1
        while true {
            if let frame = NSImage(named: "\(category.rawValue)/\(category.rawValue)_\(frameNumber)") {
                animationFrames.append(frame)
                frameNumber += 1
            } else {
                break
            }
        }

        if let button = statusItem.button {
            button.image = animationFrames.first
        }
    }
}
