//
//  watch_osApp.swift
//  watch-os Watch App
//
//  Created by Nicholas Leroy Kurniawan on 27/5/26.
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
