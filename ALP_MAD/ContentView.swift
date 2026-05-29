//
//  ContentView.swift
//  ALP_MAD
//
//  Created by Nicholas Leroy Kurniawan on 27/5/26.
//

import SwiftUI

struct ContentView: View {
    @State private var authVM = AuthViewModel()
    
    var body: some View {
        ZStack {
            if authVM.isLoggedIn, let userId = authVM.currentUserId {
                MainTabView(userId: userId)
                    .environment(authVM)
            } else {
                LoginView()
                    .environment(authVM)
            }
        }
        .animation(.easeInOut, value: authVM.isLoggedIn)
    }
}

struct MainTabView: View {
    let userId: String
    @Environment(AuthViewModel.self) private var authVM
    
    // Customize tab bar appearance
    init(userId: String) {
        self.userId = userId
        
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(AppTheme.bgDark)
        
        let itemAppearance = UITabBarItemAppearance()
        itemAppearance.normal.iconColor = UIColor(AppTheme.textMuted)
        itemAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor(AppTheme.textMuted)]
        itemAppearance.selected.iconColor = UIColor(AppTheme.primaryColor)
        itemAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor(AppTheme.primaryColor)]
        
        appearance.stackedLayoutAppearance = itemAppearance
        
        UITabBar.appearance().standardAppearance = appearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
    
    var body: some View {
        TabView {
            // Tab 1: Home
            HomeView(userId: userId)
                .tabItem {
                    Label("Home", systemImage: "person.circle.fill")
                }
            
            // Tab 2: Daily Boss
            BossView(userId: userId)
                .tabItem {
                    Label("Boss", systemImage: "flame.fill")
                }
            
            // Tab 3: Activities
            ActivityListView(userId: userId)
                .tabItem {
                    Label("Activity", systemImage: "list.clipboard.fill")
                }
            
            // Tab 4: Profile
            ProfileView(userId: userId) {
                authVM.logout()
            }
            .tabItem {
                Label("Profile", systemImage: "gearshape.fill")
            }
        }
        .tint(AppTheme.primaryColor)
        .onAppear {
            WatchConnectivityService.shared.activate()
            WatchConnectivityService.shared.sendAuthStatus(isLoggedIn: true)
        }
    }
}

#Preview {
    ContentView()
}
