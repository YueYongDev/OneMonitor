import Foundation

final class PopoverViewModel: ObservableObject {
    @Published var batteryTimeLeft: String?
    @Published var batteryUsage: String?
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

    private var lastCpuSystem: String?
    private var lastCpuUser: String?
    private var lastCpuIdle: String?
    private var lastCpuProgress: Double = 0.0

    init() {
        updateSystemInfo()
    }

    func updateSystemInfo() {
        DispatchQueue.global().async {
            let timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.getBatteryInfo()
                    self.getMemInfo()
                    self.getCpuInfo()
                    self.getDiskInfo()
                    self.getNetworkInfo()
                }
            }
            RunLoop.current.add(timer, forMode: .common)
            RunLoop.current.run()
        }
    }

    private func getBatteryInfo() {
        guard let battery = BatteryInfo.shared.getInternalBattery() else {
            batteryTimeLeft = "N/D"
            batteryProgress = 0.0
            batteryCycles = "N/D"
            batteryTemperature = "N/D"
            return
        }
        batteryTimeLeft = battery.timeLeft
        batteryProgress = battery.charge ?? 0.0
        batteryCycles = "\(battery.cycleCount ?? 0)"
        batteryTemperature = "\(battery.temperature ?? 0.0)°C"
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
        let cpuSystemValue = "\(CpuInfo.shared.system)"
        let cpuUserValue = "\(CpuInfo.shared.user)"
        let cpuIdleValue = "\(CpuInfo.shared.idle)"
        let cpuProgressValue = CpuInfo.shared.percentage / 100

        if cpuSystemValue == "0.0 %" || cpuUserValue == "0.0 %" || cpuIdleValue == "0.0 %" || cpuProgressValue == 0.0 {
            cpuSystem = lastCpuSystem
            cpuUser = lastCpuUser
            cpuIdle = lastCpuIdle
            cpuProgress = lastCpuProgress
        } else {
            cpuSystem = cpuSystemValue
            cpuUser = cpuUserValue
            cpuIdle = cpuIdleValue
            cpuProgress = cpuProgressValue

            lastCpuSystem = cpuSystemValue
            lastCpuUser = cpuUserValue
            lastCpuIdle = cpuIdleValue
            lastCpuProgress = cpuProgressValue
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
        if let ipAddress = NetworkInfo.shared.getIPAddress() {
            networkIP = ipAddress
        } else {
            networkIP = "N/A"
        }
        uploadSpeed = NetworkInfo.shared.getUploadSpeed()
        downloadSpeed = NetworkInfo.shared.getDownloadSpeed()
    }
}
