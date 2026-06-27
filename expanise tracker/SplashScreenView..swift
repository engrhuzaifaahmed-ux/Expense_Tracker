
//  SplashScreenView..swift
//  expanise tracker
//
//  Created by Huzaifa Ahmed on 22/06/2026.

import SwiftUI

struct SplashScreen: View {
    
    var body: some View {

            ZStack {
                LinearGradient(colors: [.purple , .blue ,   .gray], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                
                VStack {
                    
                    Text("Expanise Tracker")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                }
            }
        
    }
}

#Preview {
    SplashScreen()
}

