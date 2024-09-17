//
//  SectionView.swift
//  OneMonitor
//
//  Created by EnochLiang on 2024/9/17.
//

import SwiftUI

struct SectionView: View {
    @Binding var section: SectionData
    @StateObject var viewModel = PopoverViewModel()

    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            CircleProgressBar(
                title: $section.title,
                color: section.color,
                progress: progressBinding(for: section.title),
                imageString: $section.image
            ).frame(width: 50, height: 50)

            VStack(alignment: .leading, spacing: 5) {
                switch section.title {
                case "MEM":
                    Text("Usage: \(viewModel.memTotal ?? "N/D")")
                    Text("Compressed: \(viewModel.memCompressed ?? "N/D")")
                    Text("Wired: \(viewModel.memWired ?? "N/D")")
                case "CPU":
                    Text("System: \(viewModel.cpuSystem ?? "N/D")")
                    Text("User: \(viewModel.cpuUser ?? "N/D")")
                    Text("Idle: \(viewModel.cpuIdle ?? "N/D")")
                case "DISK":
                    Text("Total: \(viewModel.diskTotal ?? "N/D")")
                    Text("Used: \(viewModel.diskUsed ?? "N/D")")
                    Text("Free: \(viewModel.diskFree ?? "N/D")")
                case "ACC":
                    Text("Time left: \(viewModel.batteryTimeLeft ?? "N/D")")
                    Text("Temperature: \(viewModel.batteryTemperature ?? "N/D")")
                    Text("Cycle Count: \(viewModel.batteryCycles ?? "N/D")")
                case "NET":
                    Text("Local IP: \(viewModel.networkIP ?? "N/D")")
                    Text("Upload: \(viewModel.uploadSpeed ?? "N/D")")
                    Text("Download: \(viewModel.downloadSpeed ?? "N/D")")
                default:
                    EmptyView()
                }
            }
            Spacer()
        }
    }

    private func progressBinding(for title: String) -> Binding<Double> {
        switch title {
        case "CPU": return $viewModel.cpuProgress
        case "MEM": return $viewModel.memProgress
        case "DISK": return $viewModel.diskProgress
        case "ACC": return $viewModel.batteryProgress
        default: return .constant(0.0)
        }
    }
}

struct SectionData {
    var title: String
    var image: String
    var color: Color
}
