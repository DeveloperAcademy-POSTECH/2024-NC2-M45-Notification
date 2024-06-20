//
//  NorouApp.swift
//  Norou
//
//  Created by 김도현 on 6/17/24.
//

import SwiftUI
import SwiftData

@main
struct NorouApp: App {
    var body: some Scene {
        WindowGroup {
            NotificationListView()
                .modelContainer(for: [Routine.self])

        }
    }
}

