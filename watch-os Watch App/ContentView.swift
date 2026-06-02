//
//  ContentView.swift
//  watch-os Watch App
//
//
//

import SwiftUI

struct ContentView: View {
    @State private var viewModel = WatchViewModel()
    
    var body: some View {
        if viewModel.isConnected && viewModel.isLoggedIn {
            TabView {
                WatchActivityView(viewModel: viewModel)
                    .tabItem {
                        Label("Quests", systemImage: "list.clipboard")
                    }
                
                WatchBossView(viewModel: viewModel)
                    .tabItem {
                        Label("Boss", systemImage: "flame.fill")
                    }
            }
        } else if !viewModel.isLoggedIn {
            VStack(spacing: 12) {
                Image(systemName: "person.crop.circle.badge.xmark")
                    .font(.largeTitle)
                    .foregroundStyle(.orange)
                Text("You must login first")
                    .font(.footnote)
                    .multilineTextAlignment(.center)
            }
        } else {
            VStack(spacing: 12) {
                Image(systemName: "iphone.slash")
                    .font(.largeTitle)
                    .foregroundStyle(.gray)
                Text("Open Quest Life\non your iPhone")
                    .font(.footnote)
                    .multilineTextAlignment(.center)
            }
        }
    }
}


#Preview {
    ContentView()
}
