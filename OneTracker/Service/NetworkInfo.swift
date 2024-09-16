//
//  NetworkInfo.swift
//  OneTracker
//
//  Created by EnochLiang on 2024/9/16.
//

import Foundation
import SystemConfiguration.CaptiveNetwork
import Network

public class NetworkInfo {
    static let shared = NetworkInfo()

    private var previousUploadBytes: UInt64 = 0
    private var previousDownloadBytes: UInt64 = 0
    private var previousTimestamp: Date = Date()

    private init() {
    }

    func getIPAddress() -> String? {
        var address: String?
        var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil

        guard getifaddrs(&ifaddr) == 0 else {
            return nil
        }

        defer {
            freeifaddrs(ifaddr)
        }

        var ptr = ifaddr
        while ptr != nil {
            defer {
                ptr = ptr?.pointee.ifa_next
            }

            let interface = ptr?.pointee
            let addrFamily = interface?.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) { // Check for IPv4 address
                if let name = interface?.ifa_name, String(cString: name) == "en0" {
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(interface?.ifa_addr, socklen_t((interface?.ifa_addr.pointee.sa_len)!), &hostname, socklen_t(hostname.count), nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostname)
                }
            }
        }
        return address
    }

    func getUploadSpeed() -> String {
        let (uploadBytes, _) = getNetworkUsage()
        let uploadSpeed = calculateSpeed(previousBytes: previousUploadBytes, currentBytes: uploadBytes, previousTimestamp: previousTimestamp)
        previousUploadBytes = uploadBytes
        return uploadSpeed
    }

    func getDownloadSpeed() -> String {
        let (_, downloadBytes) = getNetworkUsage()
        let downloadSpeed = calculateSpeed(previousBytes: previousDownloadBytes, currentBytes: downloadBytes, previousTimestamp: previousTimestamp)
        previousDownloadBytes = downloadBytes
        return downloadSpeed
    }

    private func getNetworkUsage() -> (UInt64, UInt64) {
        var interfaceAddresses: UnsafeMutablePointer<ifaddrs>? = nil
        var uploadBytes: UInt64 = 0
        var downloadBytes: UInt64 = 0

        guard getifaddrs(&interfaceAddresses) == 0 else {
            return (0, 0)
        }

        defer {
            freeifaddrs(interfaceAddresses)
        }

        var ptr = interfaceAddresses
        while ptr != nil {
            defer {
                ptr = ptr?.pointee.ifa_next
            }

            let interface = ptr?.pointee
            let addrFamily = interface?.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_LINK) {
                var data: UnsafeMutablePointer<if_data>? = unsafeBitCast(interface?.ifa_data, to: UnsafeMutablePointer<if_data>?.self)
                if let data = data {
                    uploadBytes += UInt64(data.pointee.ifi_obytes)
                    downloadBytes += UInt64(data.pointee.ifi_ibytes)
                }
            }
        }

        previousTimestamp = Date()
        return (uploadBytes, downloadBytes)
    }

    private func calculateSpeed(previousBytes: UInt64, currentBytes: UInt64, previousTimestamp: Date) -> String {
        let elapsedTime = Date().timeIntervalSince(previousTimestamp)
        let bytesDifference = currentBytes - previousBytes
        let speedBytesPerSecond = Double(bytesDifference) / elapsedTime

        if speedBytesPerSecond >= 1_048_576 { // 1 MB/s
            let speedMBPerSecond = speedBytesPerSecond / 1_048_576
            return String(format: "%.2f MB/s", speedMBPerSecond)
        } else if speedBytesPerSecond >= 1_024 { // 1 KB/s
            let speedKBPerSecond = speedBytesPerSecond / 1_024
            return String(format: "%.2f KB/s", speedKBPerSecond)
        } else {
            return String(format: "%.2f B/s", speedBytesPerSecond)
        }
    }
}
