//
//  PILLziyAPP.swift
//  PILLziy
//
//  Created by Arfhan Ahmad on 1/24/26.
//

import SwiftUI
import UIKit

@main
struct PILLziyApp: App {
    @StateObject private var medicationStore = MedicationStore()
    
    init() {
        // Use the custom back button image globally
        if let backImage = UIImage(named: "Newback") {
            let navBarAppearance = UINavigationBar.appearance()
            navBarAppearance.backIndicatorImage = backImage
            navBarAppearance.backIndicatorTransitionMaskImage = backImage
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(medicationStore)
        }
    }
}
