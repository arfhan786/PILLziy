//
//  MedicationFormView.swift
//  Pillzy
//
//  Created by Arfhan Ahmad on 1/24/26.
//

import SwiftUI

struct MedicationFormView: View {
    let scannedImage: UIImage?
    let extractedText: String
    @ObservedObject var medicationStore: MedicationStore
    @Environment(\.dismiss) var dismiss
    
    @State private var medicationName: String = ""
    @State private var dosage: String = ""
    @State private var frequency: String = "1 Pill Daily"
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Medication Information")) {
                    TextField("Medication Name", text: $medicationName)
                    TextField("Dosage", text: $dosage)
                    Picker("Frequency", selection: $frequency) {
                        Text("1 Pill Daily").tag("1 Pill Daily")
                        Text("2 Pills Daily").tag("2 Pills Daily")
                        Text("3 Pills Daily").tag("3 Pills Daily")
                        Text("As Needed").tag("As Needed")
                    }
                }
                
                if !extractedText.isEmpty {
                    Section(header: Text("Extracted Text")) {
                        Text(extractedText)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Add Medication")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveMedication()
                    }
                    .disabled(medicationName.isEmpty)
                }
            }
        }
        .onAppear {
            // Try to extract medication name from scanned text
            if medicationName.isEmpty && !extractedText.isEmpty {
                let lines = extractedText.components(separatedBy: .newlines)
                for line in lines {
                    if line.count > 3 && line.count < 50 {
                        medicationName = line.trimmingCharacters(in: .whitespaces)
                        break
                    }
                }
            }
        }
    }
    
    private func saveMedication() {
        var imageData: Data? = nil
        if let image = scannedImage {
            imageData = image.jpegData(compressionQuality: 0.8)
        }
        
        let medication = Medication(
            name: medicationName.isEmpty ? "TYLENOL 500" : medicationName,
            dosage: dosage.isEmpty ? "500mg" : dosage,
            frequency: frequency,
            labelImageData: imageData
        )
        
        medicationStore.addMedication(medication)
        dismiss()
    }
}
