//
//  expanise_trackerApp.swift
//  expanise tracker
//
//  Created by Huzaifa Ahmed on 22/06/2026.
//

import SwiftUI
import SwiftData

@main
struct expanise_trackerApp: App {
    var body: some Scene {
        WindowGroup {
        Rootview()
        }
        .modelContainer(for : Expense.self)
    }
}
