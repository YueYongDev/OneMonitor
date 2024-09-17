import Foundation

final class PopoverViewModel: ObservableObject {
    @Published var batteryTimeLeft: String?
    @Published var batteryProgress: Double = 0.0
    @Published var batteryCycles: String?
    @Published var batteryTemperature: String?

    @Published var memTotal: String?
    @Published var memWired: String?
    @Published var memCompressed: String?
    @Published var memProgress: Double = 0.0

    @Published var diskTotal: String?
    @Published var diskFree: String?
    @Published var diskUsed: String?
    @Published var diskProgress: Double = 0.0

    @Published var cpuSystem: String?
    @Published var cpuUser: String?
    @Published var cpuIdle: String?
    @Published var cpuProgress: Double = 0.0

    @Published var networkIP: String?
    @Published var uploadSpeed: String?
    @Published var downloadSpeed: String?

    private var lastCpuState: (system: String?, user: String?, idle: String?, progress: Double) = (nil, nil, nil, 0.0)
    
    private var infoUpdateTimer: Timer?
    private var batteryTimer: Timer?
    private var diskTimer: Timer?

    init() {
        startTimers()
    }

    deinit {
        infoUpdateTimer?.invalidate()
        batteryTimer?.invalidate()
        diskTimer?.invalidate()
    }

    private func startTimers() {
        // 每秒更新 CPU 和内存信息
        infoUpdateTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.fetchCpuAndMemoryInfo()
        }

        // 每分钟更新电池信息
        batteryTimer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
            self?.getBatteryInfo()
        }

        // 每5分钟更新磁盘信息
        diskTimer = Timer.scheduledTimer(withTimeInterval: 300, repeats: true) { [weak self] _ in
            self?.getDiskInfo()
        }

        // 一开始立即调用更新
        getBatteryInfo()
        getDiskInfo()
    }

    private func fetchCpuAndMemoryInfo() {
        DispatchQueue.main.async { [weak self] in
            self?.getCpuInfo()
            self?.getMemInfo()
            self?.getNetworkInfo()
        }
    }

    private func getBatteryInfo() {
        guard let battery = BatteryInfo.shared.getInternalBattery() else {
            setBatteryDefaultValues()
            return
        }

        batteryTimeLeft = battery.timeLeft
        batteryProgress = (battery.charge ?? 0.0) / 100.0 // 确保是小数值
        batteryCycles = "\(battery.cycleCount ?? 0)"
        batteryTemperature = "\(battery.temperature ?? 0.0)°C"
    }

    private func setBatteryDefaultValues() {
        batteryTimeLeft = "N/D"
        batteryProgress = 0.0
        batteryCycles = "N/D"
        batteryTemperature = "N/D"
    }

    private func getMemInfo() {
        MemoryInfo.shared.update()
        memTotal = "\(MemoryInfo.shared.app)"
        memWired = "\(MemoryInfo.shared.wired)"
        memCompressed = "\(MemoryInfo.shared.compressed)"
        memProgress = MemoryInfo.shared.percentage / 100
    }

    private func getCpuInfo() {
        CpuInfo.shared.update()
        
        let currentCpuValues = (
            system: "\(CpuInfo.shared.system)",
            user: "\(CpuInfo.shared.user)",
            idle: "\(CpuInfo.shared.idle)",
            progress: CpuInfo.shared.percentage / 100
        )

        if currentCpuValues == (system: "0.0 %", user: "0.0 %", idle: "0.0 %", progress: 0.0) {
            // 使用上次的值
            cpuSystem = lastCpuState.system
            cpuUser = lastCpuState.user
            cpuIdle = lastCpuState.idle
            cpuProgress = lastCpuState.progress
        } else {
            // 更新当前值并保存到lastCpuState中
            cpuSystem = currentCpuValues.system
            cpuUser = currentCpuValues.user
            cpuIdle = currentCpuValues.idle
            cpuProgress = currentCpuValues.progress
            
            lastCpuState = currentCpuValues
        }
    }
    
    private func getDiskInfo() {
        DiskInfo.shared.update()
        diskTotal = DiskInfo.shared.total
        diskUsed = DiskInfo.shared.used
        diskFree = DiskInfo.shared.free
        diskProgress = DiskInfo.shared.percentage / 100
    }

    private func getNetworkInfo() {
        networkIP = NetworkInfo.shared.getIPAddress() ?? "N/A"
        uploadSpeed = NetworkInfo.shared.getUploadSpeed()
        downloadSpeed = NetworkInfo.shared.getDownloadSpeed()
    }
}
