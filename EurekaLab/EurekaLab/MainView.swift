//
//  MainView.swift
//  EurekaLab
//
//  Created by Pedro Valderrama on 28/09/2022.
//

import SwiftUI

struct MainView: View {
    
    @State var showSplash: Bool = true
    
    var body: some View {
        ZStack {
            Color.orange
            if showSplash {
                Text("Welcome")
                    .font(Font.largeTitle)
            } else {
                ContentView()
            }
        }
        .ignoresSafeArea()
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                withAnimation {
                    self.showSplash = false
                }
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

