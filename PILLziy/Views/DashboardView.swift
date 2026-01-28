//
//  DashboardView.swift
//  PILLziy
//
//  Created by Arfhan Ahmad on 1/24/26.
//

import SwiftUI

private struct InnerMorphismOverlay: View {
    var strength: Double = 0.12
    
    var body: some View {
        Capsule()
            .fill(
                LinearGradient(
                    colors: [
                        Color.black.opacity(strength),
                        Color.black.opacity(strength * 0.25),
                        Color.clear
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .allowsHitTesting(false)
    }
}

private let fabGray = Color(white: 0.94)

struct DashboardView: View {
    @EnvironmentObject var medicationStore: MedicationStore
    @State private var selectedMedication: Medication?
    @State private var showPharmacyHint = false
    @State private var isPillVideoPlaying = true
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
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
                        isPillVideoPlaying = false
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
                    MedicationCardView(medication: medication, isPillVideoPlaying: $isPillVideoPlaying)
                        .padding(.horizontal, 20)
                        .padding(.top, 44)
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
            
            // Bottom-right round + button with pharmacy hint
            HStack(alignment: .center, spacing: 0) {
                Button(action: {
                    isPillVideoPlaying = false
                    showPharmacyHint.toggle()
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(.primary)
                        .frame(width: 56, height: 56)
                        .background(fabGray)
                        .overlay(InnerMorphismOverlay(strength: 0.15))
                        .clipShape(Circle())
                        .shadow(color: Color.black.opacity(0.12), radius: 8, x: 0, y: 4)
                }
                .buttonStyle(.plain)
                
                if showPharmacyHint {
                    Text("How does your body feel today?")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.primary)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                        .background(fabGray)
                        .overlay(InnerMorphismOverlay())
                        .clipShape(Capsule())
                        .shadow(color: Color.black.opacity(0.08), radius: 6, x: 0, y: 3)
                        .padding(.leading, 10)
                        .transition(.opacity.combined(with: .move(edge: .trailing)))
                }
            }
            .animation(.easeOut(duration: 0.2), value: showPharmacyHint)
            .padding(.trailing, 20)
            .padding(.bottom, 24)
        }
        .onAppear {
            isPillVideoPlaying = true
            if selectedMedication == nil && !medicationStore.medications.isEmpty {
                selectedMedication = medicationStore.medications.first
            }
        }
    }
}

struct MedicationCardView: View {
    let medication: Medication
    @Binding var isPillVideoPlaying: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            // Pill Video
            LoopingPillVideoView(isPlaying: isPillVideoPlaying)
                .frame(maxWidth: .infinity)
                .frame(height: 260)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            
            // Medication name and frequency
            HStack {
                Text(medication.name.uppercased())
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.black)
                
                Text(medication.frequency)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.gray)
            }
            
            // Action buttons
            VStack(spacing: 12) {
                // Skip Dose and Take Dose buttons
                HStack(spacing: 12) {
                    // Skip Dose button (red)
                    NavigationLink(destination: SkipDoseImpactView(medication: medication)) {
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
                        .overlay(InnerMorphismOverlay(strength: 0.2))
                        .clipShape(Capsule())
                        .shadow(color: Color.black.opacity(0.15), radius: 6, x: 0, y: 3)
                    }
                    .buttonStyle(.plain)
                    .simultaneousGesture(TapGesture().onEnded {
                        isPillVideoPlaying = false
                    })
                    
                    // Take Dose button (blue)
                    NavigationLink(destination: TakeDoseView(medication: medication)) {
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
                        .overlay(InnerMorphismOverlay(strength: 0.2))
                        .clipShape(Capsule())
                        .shadow(color: Color.black.opacity(0.15), radius: 6, x: 0, y: 3)
                    }
                    .buttonStyle(.plain)
                    .simultaneousGesture(TapGesture().onEnded {
                        isPillVideoPlaying = false
                    })
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
