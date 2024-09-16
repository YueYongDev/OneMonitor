import SwiftUI

struct PopoverView: View {
    @State private var sections = [
        SectionData(title: "CPU", image: "cpu", color: .red),
        SectionData(title: "MEM", image: "memorychip", color: .green),
        SectionData(title: "DISK", image: "opticaldiscdrive", color: .yellow),
        SectionData(title: "ACC", image: "battery.50", color: .blue),
        SectionData(title: "NET", image: "network", color: .purple)
    ]

    @StateObject var viewModel = PopoverViewModel()

    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            ForEach(sections.indices, id: \.self) { index in
                HStack(alignment: .top, spacing: 10) {
                    CircleProgressBar(
                            title: $sections[index].title,
                            color: sections[index].color,
                            progress: progressBinding(for: index),
                            imageString: $sections[index].image
                    ).frame(width: 50, height: 50)

                    VStack(alignment: .leading, spacing: 5) {
                        switch sections[index].title {
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
                    Spacer() // 确保内容在水平方向上两端对齐
                }
                if index < sections.count - 1 {
                    Divider()
                }
            }
        }
                .frame(width: 250, height: 450)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 5)
    }

    private func progressBinding(for index: Int) -> Binding<Double> {
        switch index {
        case 0: return $viewModel.cpuProgress
        case 1: return $viewModel.memProgress
        case 2: return $viewModel.diskProgress
        case 3: return $viewModel.batteryProgress
        default: return .constant(0.0)
        }
    }
}

struct SectionData {
    var title: String
    var image: String
    var color: Color
}

struct CircleProgressBar: View {
    @Binding var title: String
    var color: Color
    @Binding var progress: Double
    @Binding var imageString: String

    var body: some View {
        ZStack {
            Circle()
                    .stroke(Color.gray.opacity(0.3), lineWidth: 5)

            Circle()
                    .trim(from: 0.0, to: CGFloat(progress))
                    .stroke(color, lineWidth: 5)
                    .rotationEffect(Angle(degrees: -90))

            VStack(spacing: 0) {
                Image(systemName: imageString)
                Text("\(title)").font(.subheadline)
            }
        }
    }
}
