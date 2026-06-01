//
//  ContentView.swift
//  ALP_MAD
//
//
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
            HomeView(userId: userId)
                .tabItem {
                    Label("Home", systemImage: "person.circle.fill")
                }
            
            BossView(userId: userId)
                .tabItem {
                    Label("Boss", systemImage: "flame.fill")
                }
            
            ActivityListView(userId: userId)
                .tabItem {
                    Label("Activity", systemImage: "list.clipboard.fill")
                }
            
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
