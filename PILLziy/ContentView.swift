//
//  ContentView.swift
//  PILLziy
//
//  Created by Arfhan Ahmad on 1/24/26.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var medicationStore: MedicationStore
    @State private var showScanner = false
    @State private var navigateToDashboard = false
    
    var body: some View {
        NavigationStack {
            if medicationStore.medications.isEmpty {
                PrescriptionScannerView()
                    .environmentObject(medicationStore)
                    .onChange(of: medicationStore.medications.count) { oldValue, newValue in
                        if newValue > 0 {
                            navigateToDashboard = true
                        }
                    }
            } else {
                DashboardView()
                    .environmentObject(medicationStore)
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(MedicationStore())
}
