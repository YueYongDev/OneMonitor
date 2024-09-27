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
//        case monkey = "monkey_frame"
        case cat = "cat_frame"
        case rabbit = "rabbit_frame"
    }

    private var currentCategory: FrameCategory = .cat {
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
            guard let button = statusItem.button else { return }

            // 获取屏幕的可用区域
            guard let screenFrame = NSScreen.main?.visibleFrame else { return }

            // 计算按钮的框架
            let buttonRect = button.convert(button.bounds, to: nil)

            // 定义弹出窗口的内容大小
            let popoverWidth: CGFloat = 400
            let popoverHeight: CGFloat = 450

            // 计算弹出窗口的起始位置
            var popoverPoint = NSPoint(x: buttonRect.midX - popoverWidth / 2, y: buttonRect.maxY) // 水平居中显示在按钮下方

            // 检查是否超出屏幕边界并调整位置
            if popoverPoint.x < screenFrame.minX {
                popoverPoint.x = screenFrame.minX
            } else if popoverPoint.x + popoverWidth > screenFrame.maxX {
                popoverPoint.x = screenFrame.maxX - popoverWidth
            }

            // 确保 Y 坐标在屏幕内
            if popoverPoint.y + popoverHeight > screenFrame.maxY {
                popoverPoint.y = screenFrame.maxY - popoverHeight
            }

            // 设置弹出窗口的大小
            popover.contentSize = NSSize(width: popoverWidth, height: popoverHeight)
            
            // 正确显示popover
            popover.show(relativeTo: buttonRect, of: button, preferredEdge: .maxY)
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
