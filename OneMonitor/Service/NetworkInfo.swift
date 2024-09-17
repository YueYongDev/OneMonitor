import Foundation
import SystemConfiguration

public class NetworkInfo {
    static let shared = NetworkInfo()
    private var previousUploadBytes: UInt64 = 0
    private var previousDownloadBytes: UInt64 = 0
    private var previousTimestamp: Date?
    
    private let interval: TimeInterval = 1.0 // 一秒的间隔

    private init() {
        previousTimestamp = Date()
    }
    
    // 获取 IP 地址
        func getIPAddress() -> String? {
            var address: String?
            var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil
            guard getifaddrs(&ifaddr) == 0 else {
                return nil
            }
            defer { freeifaddrs(ifaddr) }
            
            var ptr = ifaddr
            while ptr != nil {
                defer { ptr = ptr?.pointee.ifa_next }
                let interface = ptr?.pointee
                let addrFamily = interface?.ifa_addr.pointee.sa_family
                
                // 检查 IPv4 地址及 Wi-Fi 接口
                if addrFamily == UInt8(AF_INET), let name = interface?.ifa_name, String(cString: name) == "en0" {
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(interface?.ifa_addr, socklen_t(interface?.ifa_addr.pointee.sa_len ?? 0), &hostname, socklen_t(hostname.count), nil, 0, NI_NUMERICHOST)
                    address = String(cString: hostname)
                }
            }
            return address
        }

    func getUploadSpeed() -> String {
        return calculateSpeed(isUpload: true)
    }

    func getDownloadSpeed() -> String {
        return calculateSpeed(isUpload: false)
    }

    private func calculateSpeed(isUpload: Bool) -> String {
        let (currentUploadBytes, currentDownloadBytes) = getNetworkUsage(for: "en0")
        let currentBytes = isUpload ? currentUploadBytes : currentDownloadBytes
        let previousBytes = isUpload ? previousUploadBytes : previousDownloadBytes

        if previousTimestamp == nil {
            previousUploadBytes = currentUploadBytes
            previousDownloadBytes = currentDownloadBytes
            return "Calculating..."
        }

        // 计算字节差异
        let bytesDifference = currentBytes >= previousBytes ? currentBytes - previousBytes : 0
        // 以秒为单位计算速度
        let speedBytesPerSecond = Double(bytesDifference)

        // 更新保存的字节数
        if isUpload {
            previousUploadBytes = currentUploadBytes
        } else {
            previousDownloadBytes = currentDownloadBytes
        }

        // 格式化输出
        return formatSpeed(bytes: speedBytesPerSecond)
    }

    private func getNetworkUsage(for interfaceName: String) -> (UInt64, UInt64) {
        var uploadBytes: UInt64 = 0
        var downloadBytes: UInt64 = 0
        var interfaceAddresses: UnsafeMutablePointer<ifaddrs>? = nil

        guard getifaddrs(&interfaceAddresses) == 0 else {
            print("Error getting interface addresses")
            return (0, 0)
        }

        defer { freeifaddrs(interfaceAddresses) }

        var ptr = interfaceAddresses
        while ptr != nil {
            defer { ptr = ptr?.pointee.ifa_next }

            if let interface = ptr?.pointee,
               interface.ifa_addr.pointee.sa_family == UInt8(AF_LINK),
               let name = interface.ifa_name,
               String(cString: name) == interfaceName {

                if let dataPointer = interface.ifa_data {
                    let data = dataPointer.assumingMemoryBound(to: if_data.self)
                    uploadBytes = UInt64(data.pointee.ifi_obytes)
                    downloadBytes = UInt64(data.pointee.ifi_ibytes)
                }
            }
        }

        return (uploadBytes, downloadBytes)
    }

    private func formatSpeed(bytes: Double) -> String {
        if bytes >= 1_048_576 {
            return String(format: "%.2f MB/s", bytes / 1_048_576)
        } else if bytes >= 1_024 {
            return String(format: "%.2f KB/s", bytes / 1_024)
        } else {
            return String(format: "%.2f B/s", bytes)
        }
    }
}
