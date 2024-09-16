//
//  SettingView.swift
//  OneMonitor
//
//  Created by EnochLiang on 2024/9/16.
//
import SwiftUI

struct SettingsView: View {
    @State private var showMemoryPerformance = false
    @State private var showStorageCapacity = false
    @State private var showBatteryState = false
    @State private var showNetworkConnection = false
    @State private var showSystemInfoBarBeta = false
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("Monitoring")) {
                    Toggle(isOn: $showMemoryPerformance) {
                        Text("Memory Performance")
                    }
                    Toggle(isOn: $showStorageCapacity) {
                        Text("Storage Capacity")
                    }
                    Toggle(isOn: $showBatteryState) {
                        Text("Battery State")
                    }
                    Toggle(isOn: $showNetworkConnection) {
                        Text("Network Connection")
                    }
                }
                
                Section(header: Text("Experimental feature")) {
                    Toggle(isOn: $showSystemInfoBarBeta) {
                        Text("System Info Bar (β)")
                    }
                }
            }
            .sheet(isPresented: self.$showMemoryPerformance) {
                // Memory Performance details view here
            }
            .sheet(isPresented: self.$showStorageCapacity) {
                // Storage Capacity details view here
            }
            .sheet(isPresented: self.$showBatteryState) {
                // Battery State details view here
            }
            .sheet(isPresented: self.$showNetworkConnection) {
                // Network Connection details view here
            }
            .sheet(isPresented: self.$showSystemInfoBarBeta) {
                // System Info Bar details view here
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color(NSColor.systemGray)) // Use NSColor for macOS
            .cornerRadius(10)
            .padding(20)
        }
        .frame(width: 400, height: 400)
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
