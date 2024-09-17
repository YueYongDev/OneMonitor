import SwiftUI

struct SectionView: View {
    @Binding var section: SectionData
    @StateObject var viewModel = PopoverViewModel()
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) { // 调整间距
            CircleProgressBar(
                title: $section.title,
                color: section.color,
                progress: progressBinding(for: section.title),
                imageString: $section.image
            )
            .frame(width: 60, height: 60)
            .background(Color.clear) // 确保背景透明

            VStack(alignment: .leading, spacing: 4) { // 调整文本间距
                switch section.title {
                case "MEM":
                    infoText("Usage: \(viewModel.memTotal ?? "N/D")")
                    infoText("Compressed: \(viewModel.memCompressed ?? "N/D")")
                    infoText("Wired: \(viewModel.memWired ?? "N/D")")
                case "CPU":
                    infoText("System: \(viewModel.cpuSystem ?? "N/D")")
                    infoText("User: \(viewModel.cpuUser ?? "N/D")")
                    infoText("Idle: \(viewModel.cpuIdle ?? "N/D")")
                case "DISK":
                    infoText("Total: \(viewModel.diskTotal ?? "N/D")")
                    infoText("Used: \(viewModel.diskUsed ?? "N/D")")
                    infoText("Free: \(viewModel.diskFree ?? "N/D")")
                case "BATTERY":
                    infoText("Battery: \(String(format: "%.0f", viewModel.batteryProgress * 100))%")
//                    infoText("Time left: \(viewModel.batteryTimeLeft ?? "N/D")")
                    infoText("Temperature: \(viewModel.batteryTemperature ?? "N/D")")
                    infoText("Cycle Count: \(viewModel.batteryCycles ?? "N/D")")
                case "NET":
                    infoText("Local IP: \(viewModel.networkIP ?? "N/D")")
                    infoText("Upload: \(viewModel.uploadSpeed ?? "N/D")")
                    infoText("Download: \(viewModel.downloadSpeed ?? "N/D")")
                default:
                    EmptyView()
                }
            }
            .foregroundColor(.black) // 文字颜色
            .frame(maxWidth: .infinity, alignment: .leading)

            Spacer()
        }
        .padding(2) // 边距设置
        .background(Color.white) // 统一的背景色
        .cornerRadius(10) // 圆角
//        .shadow(radius: 2) // 添加阴影让界面更有层次感
    }
    
    private func progressBinding(for title: String) -> Binding<Double> {
        switch title {
            case "CPU": return $viewModel.cpuProgress
            case "MEM": return $viewModel.memProgress
            case "DISK": return $viewModel.diskProgress
            case "BATTERY": return $viewModel.batteryProgress
            default: return .constant(1.0)
        }
    }
    
    private func infoText(_ text: String) -> some View {
        Text(text)
            .font(.subheadline) // 调整字体大小
            .multilineTextAlignment(.leading)
            .padding(.vertical, 2) // 每行上下填充
    }
}

struct SectionData {
    var title: String
    var image: String
    var color: Color
}
//
