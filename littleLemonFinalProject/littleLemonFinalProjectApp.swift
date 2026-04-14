//
//  littleLemonFinalProjectApp.swift
//  littleLemonFinalProject
//
//  Created by Mario Duarte on 14/04/26.
//

import SwiftUI
import CoreData

@main
struct littleLemonFinalProjectApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
