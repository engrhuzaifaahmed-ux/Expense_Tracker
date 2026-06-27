//
//  Rootview.swift
//  expanise tracker
//
//  Created by Huzaifa Ahmed on 22/06/2026.
//

import SwiftUI

struct Rootview : View {
    @State private var showsplash = true
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding =  false
    var body : some View {
        ZStack{
            if showsplash {
                SplashScreen()
            }else {
                if hasSeenOnboarding {
                    MainTabView()
                }else {
                    OnboardingView {
                        hasSeenOnboarding = true
                    }
                }
            }
        }
        .onAppear{
            DispatchQueue.main.asyncAfter(deadline: .now()+2){
                withAnimation{
                    showsplash = false
                }
            }
        }
    }
}

#Preview {
    Rootview()
}
