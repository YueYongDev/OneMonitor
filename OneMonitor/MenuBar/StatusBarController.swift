import AppKit

class StatusBarController {
    private var statusBar: NSStatusBar
    private(set) var statusItem: NSStatusItem
    private(set) var popover: NSPopover

    private var animationTimer: Timer?
    private var currentFrameIndex: Int = 0
    private var animationFrames: [NSImage] = []

    private var cpuInfo: CpuInfo

    init(_ popover: NSPopover, cpuInfo: CpuInfo) {
        self.popover = popover
        self.popover.behavior = .transient
        self.cpuInfo = cpuInfo

        statusBar = .init()
        statusItem = statusBar.statusItem(withLength: NSStatusItem.variableLength)

        // 加载动画帧
        for i in 1...3 { // 假设有 3 个动画帧
            if let frame = NSImage(named: "cat_frame_\(i)") {
                animationFrames.append(frame)
            }
        }

        if let button = statusItem.button {
            // 设置初始图标
            button.image = animationFrames.first

            button.action = #selector(showApp)
            button.target = self
        }

        startAnimation()
    }

    func startAnimation() {
        // 初始化动画计时器
        updateAnimationTimer()
    }

    private func updateAnimationTimer() {
        // 停止当前计时器
        animationTimer?.invalidate()

        // 根据 CPU 利用率调整动画速度
        let cpuPercentage = cpuInfo.percentage
        let baseInterval = 0.2 // 初始时间间隔
        let maxAdjustment = 0.15 // 最大调整量

        // 计算调整后的时间间隔
        let adjustment = min(maxAdjustment, max(0.0, (cpuPercentage / 100.0) * maxAdjustment))
        let timeInterval = max(0.05, baseInterval - adjustment)

        animationTimer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(updateAnimation), userInfo: nil, repeats: true)
    }

    @objc func updateAnimation() {
        if let button = statusItem.button {
            // 更新动画帧
            currentFrameIndex = (currentFrameIndex + 1) % animationFrames.count
            button.image = animationFrames[currentFrameIndex]
        }

        // 更新 CPU 信息并调整动画速度
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
}
