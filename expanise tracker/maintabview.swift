//
//  maintabview.swift
//  expanise tracker
//
//  Created by Huzaifa Ahmed on 26/06/2026.
//
import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            Tab("Home", systemImage: "house") {
                HomeView()
            }
            
            Tab("History", systemImage: "list.number"){
                Historyview()
            }
            
            Tab("Report", systemImage: "chart.bar") {
                reportview()
            }
            Tab("setting ", systemImage: "gearshape"){
                SettingView()
            }
        }
    }
}

#Preview {
    MainTabView()
}
