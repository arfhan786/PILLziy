//
//  PILLziyAPP.swift
//  PILLziy
//
//  Created by Arfhan Ahmad on 1/24/26.
//

import SwiftUI

@main
struct PILLziyApp: App {
    @StateObject private var medicationStore = MedicationStore()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(medicationStore)
        }
    }
}
