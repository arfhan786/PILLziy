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
    @State private var hasStoppedVideo = false
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Color.white
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Top bar with name and bell icon
                HStack {
                    Text("William Davis")
                        .font(.custom("Poppins", size: 20).weight(.semibold))
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    Button(action: {
                        isPillVideoPlaying = false
                        // Notification action
                    }) {
                        ZStack {
                            Circle()
                                .fill(Color.white)
                                .overlay(
                                    Circle()
                                        .fill(
                                            LinearGradient(
                                                colors: [
                                                    Color.black.opacity(0.06),
                                                    Color.black.opacity(0.02),
                                                    Color.clear
                                                ],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .allowsHitTesting(false)
                                )
                                .shadow(color: Color.black.opacity(0.10), radius: 8, x: 0, y: 4)
                            
                            Image(systemName: "bell")
                                .font(.custom("Poppins", size: 16))
                                .foregroundColor(.black)
                        }
                        .frame(width: 36, height: 36)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                .padding(.bottom, 20)
                
                // Main content card slightly above center
                if let medication = selectedMedication ?? medicationStore.medications.first {
                    MedicationCardView(medication: medication, isPillVideoPlaying: $isPillVideoPlaying)
                        .padding(.horizontal, 20)
                        .padding(.top, 75)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                } else {
                    VStack(spacing: 20) {
                        Text("No medications added")
                            .font(.custom("Poppins", size: 17).weight(.semibold))
                            .foregroundColor(.gray)
                        
                        Text("Scan a prescription to get started")
                            .font(.custom("Poppins", size: 15))
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            
            // Bottom-right round + button with pharmacy hint
            HStack(alignment: .center, spacing: 0) {
                Button(action: {
                    isPillVideoPlaying = false
                    showPharmacyHint.toggle()
                }) {
                    Image(systemName: "plus")
                        .font(.custom("Poppins", size: 22).weight(.semibold))
                        .foregroundColor(.primary)
                        .frame(width: 56, height: 56)
                        .background(fabGray)
                        .overlay(InnerMorphismOverlay(strength: 0.15))
                        .clipShape(Circle())
                        .shadow(color: Color.black.opacity(0.12), radius: 8, x: 0, y: 4)
                }
                .buttonStyle(.plain)
                
                if showPharmacyHint {
                    NavigationLink(destination: BodyMapView()) {
                        Text("How does your body feel today?")
                            .font(.custom("Poppins", size: 14).weight(.medium))
                            .foregroundColor(.primary)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 10)
                            .background(fabGray)
                            .overlay(InnerMorphismOverlay())
                            .clipShape(Capsule())
                            .shadow(color: Color.black.opacity(0.08), radius: 6, x: 0, y: 3)
                            .padding(.leading, 10)
                    }
                    .buttonStyle(.plain)
                    .simultaneousGesture(TapGesture().onEnded {
                        hasStoppedVideo = true
                        isPillVideoPlaying = false
                    })
                    .transition(.opacity.combined(with: .move(edge: .trailing)))
                }
            }
            .animation(.easeOut(duration: 0.2), value: showPharmacyHint)
            .padding(.trailing, 20)
            .padding(.bottom, 24)
        }
        .onAppear {
            isPillVideoPlaying = !hasStoppedVideo
            if selectedMedication == nil && !medicationStore.medications.isEmpty {
                selectedMedication = medicationStore.medications.first
            }
        }
        .onDisappear {
            hasStoppedVideo = true
            isPillVideoPlaying = false
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
                    .font(.custom("Poppins", size: 24).weight(.bold))
                    .foregroundColor(.black)
                
                Text(medication.frequency)
                    .font(.custom("Poppins", size: 16))
                    .foregroundColor(.gray)
            }
            
            // Action buttons
            VStack(spacing: 12) {
                // Skip Dose and Take Dose buttons in one line
                HStack(spacing: 40) {
                    // Skip Dose button (red)
                    NavigationLink(destination: SkipDoseImpactView(medication: medication)) {
                        HStack(alignment: .center, spacing: 6) {
                            Image(systemName: "xmark")
                                .font(.custom("Poppins", size: 16).weight(.regular))
                            Text("Skip Dose")
                                .font(.custom("Poppins", size: 16).weight(.regular))
                                .lineLimit(1)
                                .minimumScaleFactor(0.9)
                                .layoutPriority(1)

                            Spacer(minLength: 0)
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity, minHeight: 60, maxHeight: 60, alignment: .center)
                        .background(
                            LinearGradient(
                                stops: [
                                    Gradient.Stop(color: Color(red: 1, green: 0.27, blue: 0.27), location: 0.00),
                                    Gradient.Stop(color: Color(red: 1, green: 0.3, blue: 0.3), location: 1.00),
                                ],
                                startPoint: UnitPoint(x: 0, y: 0.5),
                                endPoint: UnitPoint(x: 1, y: 0.5)
                            )
                        )
                        .cornerRadius(420.30264)
                        .shadow(color: Color(red: 1, green: 0.27, blue: 0.27).opacity(0.26), radius: 6.5, x: 8, y: 8)
                        .shadow(color: .white, radius: 6.5, x: -8, y: -8)
                    }
                    .buttonStyle(.plain)
                    .simultaneousGesture(TapGesture().onEnded {
                        isPillVideoPlaying = false
                    })
                    
                    // Take Dose button (blue gradient, morphism style)
                    NavigationLink(destination: TakeDoseView(medication: medication)) {
                        HStack(alignment: .center, spacing: 6) {
                            Image(systemName: "checkmark")
                                .font(.custom("Poppins", size: 16).weight(.regular))
                            Text("Take Dose")
                                .font(.custom("Poppins", size: 16).weight(.regular))
                                .lineLimit(1)
                                .minimumScaleFactor(0.9)
                                .layoutPriority(1)

                            Spacer(minLength: 0)
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity, minHeight: 60, maxHeight: 60, alignment: .center)
                        .background(
                            LinearGradient(
                                stops: [
                                    Gradient.Stop(color: Color(red: 0.36, green: 0.51, blue: 1), location: 0.00),
                                    Gradient.Stop(color: Color(red: 0.33, green: 0.49, blue: 1), location: 1.00),
                                ],
                                startPoint: UnitPoint(x: 0, y: 0.5),
                                endPoint: UnitPoint(x: 1, y: 0.5)
                            )
                        )
                        .cornerRadius(420.30264)
                        .shadow(color: Color(red: 0.26, green: 0.43, blue: 1).opacity(0.26), radius: 6.5, x: 8, y: 8)
                        .shadow(color: .white, radius: 6.5, x: -8, y: -8)
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
