//
//  EurekaLabApp.swift
//  EurekaLab
//
//  Created by Pedro Valderrama on 28/09/2022.
//

import SwiftUI

@main
struct EurekaLabApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
