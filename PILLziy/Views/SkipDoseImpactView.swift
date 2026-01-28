//
//  SkipDoseImpactView.swift
//  PILLziy
//
//  Created by Arfhan Ahmad on 1/24/26.
//

import SwiftUI

private let impactMorphismGray = Color(white: 0.94)
private let skipDoseRed = Color.red

private struct ImpactMorphismOverlay: View {
    var body: some View {
        Capsule()
            .fill(
                LinearGradient(
                    colors: [
                        Color.black.opacity(0.1),
                        Color.black.opacity(0.03),
                        Color.clear
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .allowsHitTesting(false)
    }
}

private struct ArmImageWithGreenGlow: View {
    @State private var glowOpacity: Double = 0.3
    
    var body: some View {
        ZStack {
            // Thick blurry green outline - outer layer
            Image("SadArm")
                .resizable()
                .renderingMode(.template)
                .aspectRatio(contentMode: .fit)
                .foregroundColor(skipDoseRed)
                .frame(width: 680, height: 680)
                .blur(radius: 35)
                .opacity(glowOpacity * 0.6)
            
            // Thick blurry green outline - middle layer
            Image("SadArm")
                .resizable()
                .renderingMode(.template)
                .aspectRatio(contentMode: .fit)
                .foregroundColor(skipDoseRed)
                .frame(width: 660, height: 660)
                .blur(radius: 28)
                .opacity(glowOpacity * 0.7)
            
            // Thick blurry green outline - inner layer
            Image("SadArm")
                .resizable()
                .renderingMode(.template)
                .aspectRatio(contentMode: .fit)
                .foregroundColor(skipDoseRed)
                .frame(width: 650, height: 650)
                .blur(radius: 22)
                .opacity(glowOpacity * 0.8)
            
            // Thick green stroke outline layers for visibility
            Image("SadArm")
                .resizable()
                .renderingMode(.template)
                .aspectRatio(contentMode: .fit)
                .foregroundColor(skipDoseRed.opacity(glowOpacity))
                .frame(width: 648, height: 648)
                .blur(radius: 6)
            
            Image("SadArm")
                .resizable()
                .renderingMode(.template)
                .aspectRatio(contentMode: .fit)
                .foregroundColor(skipDoseRed.opacity(glowOpacity))
                .frame(width: 644, height: 644)
                .blur(radius: 4)
            
            Image("SadArm")
                .resizable()
                .renderingMode(.template)
                .aspectRatio(contentMode: .fit)
                .foregroundColor(skipDoseRed.opacity(glowOpacity))
                .frame(width: 642, height: 642)
                .blur(radius: 2)
            
            // Main image (5x bigger: 500x500) - always visible
            Image("SadArm")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 640, height: 640)

            // Top green glow halo that fades in/out
            Circle()
                .fill(skipDoseRed.opacity(glowOpacity))
                .frame(width: 190, height: 95)
                .blur(radius: 25)
                .offset(x: 10, y: -280)
        }
        .onAppear {
            // Continuously fade in and out only the green glow (from 0.3 to 0.9) - faster animation
            withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                glowOpacity = 0.9
            }
        }
    }
}

struct SkipDoseImpactView: View {
    let medication: Medication
    @Environment(\.dismiss) var dismiss
    @State private var isPillVideoPlaying = true
    @State private var hasStoppedVideo = false
    @State private var showSkippedPopup = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Spacer()
                    .frame(minHeight: 100)

                HStack(alignment: .bottom, spacing: 16) {
                    ZStack(alignment: .bottomLeading) {
                        Image("BodyDoseSkip")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: 260)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .scaleEffect(2.1, anchor: .bottomLeading)
                    }
                    .offset(x: -28)

                    Spacer(minLength: 8)

                    LoopingPillVideoView(videoName: "SkipADoseVideo", isPlaying: isPillVideoPlaying)
                        .frame(width: 150, height: 150)
                        .background(Color.clear)
                        // Keep the pill visible and in its intended spot (arm overlay is very large).
                        .offset(x: -128)
                        .zIndex(2)
                }
                .padding(.horizontal, 20)

                .onAppear { isPillVideoPlaying = !hasStoppedVideo }
                .onDisappear {
                    hasStoppedVideo = true
                    isPillVideoPlaying = false
                }

                Button(action: {
                    hasStoppedVideo = true
                    isPillVideoPlaying = false
                    showSkippedPopup = true
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .semibold))
                        Text("Dose Skipped")
                            .font(.system(size: 17, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 28)
                    .padding(.vertical, 16)
                    .background(Color.red)
                    .overlay(ImpactMorphismOverlay())
                    .clipShape(Capsule())
                    .shadow(color: Color.red.opacity(0.35), radius: 8, x: 0, y: 4)
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.horizontal, 20)
                .padding(.bottom, 24)
            }
            .background(Color.white)
            .navigationTitle("The Impact of Missing a Dose")
            .navigationBarTitleDisplayMode(.inline)
            
            // Arm image with thick blurry green outline overlay
            ArmImageWithGreenGlow()
                .offset(x: -70, y: -65)
                .allowsHitTesting(false)
                // Don't let the large overlay cover core UI elements (like the pill).
                .zIndex(0)

            if showSkippedPopup {
                Color.black.opacity(0.2)
                    .ignoresSafeArea()

                VStack {
                    ZStack(alignment: .topTrailing) {
                        VStack(spacing: 8) {
                            Image("Dose skipped popup")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxHeight: 140)

                            Text("Dose Skipped")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.primary)
                                .padding(.top, 4)
                        }
                        .padding(14)
                        .frame(width: 300, height: 300) // approx 30x30 "units"
                        .background(Color(white: 0.95))
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                        .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 6)

                        Button(action: {
                            showSkippedPopup = false
                            dismiss()
                        }) {
                            Image(systemName: "xmark")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.gray)
                                .padding(8)
                        }
                        .offset(x: -4, y: 4)
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        SkipDoseImpactView(medication: Medication(name: "Tylenol 500", dosage: "500mg", frequency: "1 Pill Daily"))
    }
}
