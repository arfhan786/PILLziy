//
//  DashboardView.swift
//  PILLziy
//
//  Created by Arfhan Ahmad on 1/24/26.
//

import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var medicationStore: MedicationStore
    @State private var selectedMedication: Medication?
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Top bar with name and bell icon
                HStack {
                    Text("William Davis")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    Button(action: {
                        // Notification action
                    }) {
                        Image(systemName: "bell.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.black)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                .padding(.bottom, 20)
                
                // Main content card
                if let medication = selectedMedication ?? medicationStore.medications.first {
                    MedicationCardView(medication: medication)
                        .padding(.horizontal, 20)
                } else {
                    VStack(spacing: 20) {
                        Text("No medications added")
                            .font(.headline)
                            .foregroundColor(.gray)
                        
                        Text("Scan a prescription to get started")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                
                Spacer()
            }
        }
        .onAppear {
            if selectedMedication == nil && !medicationStore.medications.isEmpty {
                selectedMedication = medicationStore.medications.first
            }
        }
    }
}

struct MedicationCardView: View {
    let medication: Medication
    
    var body: some View {
        VStack(spacing: 20) {
            // Pill Video (PILLziyVideo) – autoplays and loops on appear
            LoopingPillVideoView()
                .frame(height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            
            // Medication name
            Text(medication.name.uppercased())
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.black)
            
            // Dosage frequency
            Text(medication.frequency)
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(.gray)
            
            // Action buttons
            VStack(spacing: 12) {
                // Take Dose and Skip Dose buttons
                HStack(spacing: 12) {
                    // Take Dose button (blue)
                    Button(action: {
                        // Take dose action
                    }) {
                        HStack {
                            Image(systemName: "checkmark")
                                .font(.system(size: 18, weight: .semibold))
                            Text("Take Dose")
                                .font(.system(size: 16, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.blue)
                        .cornerRadius(12)
                    }
                    
                    // Skip Dose button (red)
                    Button(action: {
                        // Skip dose action
                    }) {
                        HStack {
                            Image(systemName: "xmark")
                                .font(.system(size: 18, weight: .semibold))
                            Text("Skip Dose")
                                .font(.system(size: 16, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.red)
                        .cornerRadius(12)
                    }
                }
                
                // How to take it button (light blue/grey)
                Button(action: {
                    // How to take it action
                }) {
                    Text("How to take it?")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color(red: 0.9, green: 0.95, blue: 1.0))
                        .cornerRadius(12)
                }
            }
            .padding(.top, 10)
        }
        .padding(30)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
}

#Preview {
    DashboardView()
        .environmentObject(MedicationStore())
}
