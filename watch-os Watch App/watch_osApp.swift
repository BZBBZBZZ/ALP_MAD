//
//  watch_osApp.swift
//  watch-os Watch App
//
//
//

import SwiftUI

@main
struct watch_os_Watch_AppApp: App {
    
    init() {
        WatchSessionService.shared.activate()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
