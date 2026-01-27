//
//  MedicationStore.swift
//  PILLziy
//
//  Created by Arfhan Ahmad on 1/24/26.
//

import Combine
import SwiftUI

class MedicationStore: ObservableObject {
    @Published var medications: [Medication] = []
    
    private let medicationsKey = "SavedMedications"
    
    init() {
        loadMedications()
    }
    
    private func loadMedications() {
        if let data = UserDefaults.standard.data(forKey: medicationsKey),
           let decoded = try? JSONDecoder().decode([Medication].self, from: data) {
            medications = decoded
        }
    }
    
    func addMedication(_ medication: Medication) {
        medications.append(medication)
        saveMedications()
    }
    
    func removeMedication(_ medication: Medication) {
        medications.removeAll { $0.id == medication.id }
        saveMedications()
    }
    
    func updateMedication(_ medication: Medication) {
        if let index = medications.firstIndex(where: { $0.id == medication.id }) {
            medications[index] = medication
            saveMedications()
        }
    }
    
    private func saveMedications() {
        if let encoded = try? JSONEncoder().encode(medications) {
            UserDefaults.standard.set(encoded, forKey: medicationsKey)
        }
    }
    
}


//1. create a scanner that can scan a prescription
//2. Store all the medications and labels locally.
//3. then take the user to the Dashboard image attached
//4. create exact buttons and items.
//5. for the 3d pill you see in the Dashboard.png
//
//
//
//1. user DashboardVideo attached
