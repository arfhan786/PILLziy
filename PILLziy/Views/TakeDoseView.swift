//
//  TakeDoseView.swift
//  PILLziy
//
//  Created by Arfhan Ahmad on 1/24/26.
//

import SwiftUI

private let takeDoseMorphismGray = Color(white: 0.94)
private let takeDoseGreen = Color(red: 0.35, green: 0.95, blue: 0.45)

private struct TakeDoseMorphismOverlay: View {
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

private struct BlueWaveDot: View {
    @State private var animate = false

    var body: some View {
        ZStack {
            Circle()
                .fill(Color.blue.opacity(0.35))
                .scaleEffect(animate ? 1.15 : 0.9)
                .opacity(animate ? 0 : 1)

            Circle()
                .fill(Color.blue.opacity(0.25))
                .scaleEffect(animate ? 1.0 : 0.9)
                .opacity(animate ? 0.5 : 0.9)

            Circle()
                .fill(Color.blue)
                .frame(width: 14, height: 14)
        }
        .frame(width: 40, height: 40)
        .onAppear {
            withAnimation(.easeOut(duration: 1.6).repeatForever(autoreverses: false)) {
                animate = true
            }
        }
    }
}

private struct ArmImageWithGreenGlow: View {
    @State private var glowOpacity: Double = 0.3
    
    var body: some View {
        ZStack {
            // Thick blurry green outline - outer layer
            Image("Arm")
                .resizable()
                .renderingMode(.template)
                .aspectRatio(contentMode: .fit)
                .foregroundColor(takeDoseGreen)
                .frame(width: 680, height: 680)
                .blur(radius: 35)
                .opacity(glowOpacity * 0.6)
            
            // Thick blurry green outline - middle layer
            Image("Arm")
                .resizable()
                .renderingMode(.template)
                .aspectRatio(contentMode: .fit)
                .foregroundColor(takeDoseGreen)
                .frame(width: 660, height: 660)
                .blur(radius: 28)
                .opacity(glowOpacity * 0.7)
            
            // Thick blurry green outline - inner layer
            Image("Arm")
                .resizable()
                .renderingMode(.template)
                .aspectRatio(contentMode: .fit)
                .foregroundColor(takeDoseGreen)
                .frame(width: 650, height: 650)
                .blur(radius: 22)
                .opacity(glowOpacity * 0.8)
            
            // Thick green stroke outline layers for visibility
            Image("Arm")
                .resizable()
                .renderingMode(.template)
                .aspectRatio(contentMode: .fit)
                .foregroundColor(takeDoseGreen.opacity(glowOpacity))
                .frame(width: 648, height: 648)
                .blur(radius: 6)
            
            Image("Arm")
                .resizable()
                .renderingMode(.template)
                .aspectRatio(contentMode: .fit)
                .foregroundColor(takeDoseGreen.opacity(glowOpacity))
                .frame(width: 644, height: 644)
                .blur(radius: 4)
            
            Image("Arm")
                .resizable()
                .renderingMode(.template)
                .aspectRatio(contentMode: .fit)
                .foregroundColor(takeDoseGreen.opacity(glowOpacity))
                .frame(width: 642, height: 642)
                .blur(radius: 2)
            
            // Main image (5x bigger: 500x500) - always visible
            Image("Arm")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 640, height: 640)
        }
        .onAppear {
            // Continuously fade in and out only the green glow (from 0.3 to 0.9) - faster animation
            withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                glowOpacity = 0.9
            }
        }
    }
}

struct TakeDoseView: View {
    let medication: Medication
    @Environment(\.dismiss) var dismiss
    @State private var isPillVideoPlaying = true
    @State private var hasStoppedVideo = false
    @State private var showFoodDrinkSelection = false
    @State private var showTakenPopup = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Spacer()
                    .frame(minHeight: 100)

                HStack(alignment: .bottom, spacing: 5) {
                    ZStack(alignment: .bottomLeading) {
                        Image("Take dose")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: 260)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .scaleEffect(2.1, anchor: .bottomLeading)

                        // Blue wave dot near body
                        BlueWaveDot()
                            .offset(x: 40, y: -40)
                    }
                    .offset(x: -85)

                    ZStack(alignment: .topTrailing) {
                        LoopingPillVideoView(videoName: "TakeADoseVideo", isPlaying: isPillVideoPlaying)
                            .frame(width: 150, height: 150)
                            .background(Color.clear)

                        // Second blue wave dot near pill
                        BlueWaveDot()
                            .offset(x: 12, y: -12)
                    }
                }
                .padding(.horizontal, 20)
                .onAppear { isPillVideoPlaying = !hasStoppedVideo }
                .onDisappear {
                    hasStoppedVideo = true
                    isPillVideoPlaying = false
                }

                HStack(spacing: 12) {
                    NavigationLink(destination: FoodDrinkSelectionView()) {
                        Text("How to take it?")
                            .font(.system(size: 16, weight: .medium))
                            .lineLimit(1)
                            .minimumScaleFactor(0.85)
                            .foregroundColor(.primary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .padding(.horizontal, 20)
                            .background(takeDoseMorphismGray)
                            .overlay(TakeDoseMorphismOverlay())
                            .clipShape(Capsule())
                            .shadow(color: Color.black.opacity(0.08), radius: 6, x: 0, y: 3)
                    }
                    .buttonStyle(.plain)
                    .simultaneousGesture(TapGesture().onEnded {
                        hasStoppedVideo = true
                        isPillVideoPlaying = false
                    })
                    
                    Button(action: {
                        hasStoppedVideo = true
                        isPillVideoPlaying = false
                        showTakenPopup = true
                    }) {
                        Text("I have taken")
                            .font(.system(size: 16, weight: .semibold))
                            .lineLimit(1)
                            .minimumScaleFactor(0.85)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .padding(.horizontal, 20)
                            .background(takeDoseGreen)
                            .overlay(TakeDoseMorphismOverlay())
                            .clipShape(Capsule())
                            .shadow(color: takeDoseGreen.opacity(0.4), radius: 8, x: 0, y: 4)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 24)
            }
            .background(Color.white)
            .navigationTitle("How it Helps You")
            .navigationBarTitleDisplayMode(.inline)
            
            // Arm image with thick blurry green outline overlay
            ArmImageWithGreenGlow()
                .offset(x: -12, y: -57)
                .allowsHitTesting(false)

            if showTakenPopup {
                Color.black.opacity(0.2)
                    .ignoresSafeArea()

                VStack {
                    ZStack(alignment: .topTrailing) {
                        VStack(spacing: 8) {
                            Image("Dose Logged popup")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxHeight: 140)

                            Text("Dose Logged")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.primary)
                                .padding(.top, 4)
                        }
                        .padding(14)
                        .frame(width: 300, height: 300)
                        .background(Color(white: 0.95))
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                        .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 6)

                        Button(action: {
                            showTakenPopup = false
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
        TakeDoseView(medication: Medication(name: "Tylenol 500", dosage: "500mg", frequency: "1 Pill Daily"))
    }
}
