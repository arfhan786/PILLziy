//
//  TakeDoseView.swift
//  PILLziy
//
//  Created by Arfhan Ahmad on 1/24/26.
//

import SwiftUI

private let takeDoseMorphismGray = Color(white: 0.94)
private let takeDoseGreen = Color(red: 0.25, green: 0.75, blue: 0.35)

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

            // Top green glow halo that fades in/out
            Circle()
                .fill(takeDoseGreen.opacity(glowOpacity))
                .frame(width: 190, height: 95)
                .blur(radius: 25)
                .offset(x: -20, y: -300)
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
                    }
                    .offset(x: -85)

                    ZStack(alignment: .topTrailing) {
                        LoopingPillVideoView(videoName: "TakeADoseVideo", isPlaying: isPillVideoPlaying)
                            .frame(width: 150, height: 150)
                            .background(Color.clear)
                    }
                }
                .padding(.horizontal, 20)
                .onAppear { isPillVideoPlaying = !hasStoppedVideo }
                .onDisappear {
                    hasStoppedVideo = true
                    isPillVideoPlaying = false
                }

                HStack(spacing: 8) {
                    NavigationLink(destination: FoodDrinkSelectionView()) {
                        Text("How to take it?")
                            .font(.custom("Poppins", size: 16).weight(.regular))
                            .lineLimit(1)
                            .minimumScaleFactor(0.85)
                            .foregroundColor(.primary)
                            .padding(.horizontal, 28)
                            .padding(.vertical, 8)
                            .frame(minHeight: 56, maxHeight: 56, alignment: .center)
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
                        Text("Log Dose Taken")
                            .font(.custom("Poppins", size: 16).weight(.regular))
                            .lineLimit(1)
                            .minimumScaleFactor(0.85)
                            .foregroundColor(.white)
                            .padding(.horizontal, 28)
                            .padding(.vertical, 8)
                            .frame(minHeight: 56, maxHeight: 56, alignment: .center)
                            .background(
                                LinearGradient(
                                    stops: [
                                        Gradient.Stop(color: Color(red: 0.27, green: 0.77, blue: 0.37), location: 0.00),
                                        Gradient.Stop(color: Color(red: 0.23, green: 0.73, blue: 0.33), location: 1.00),
                                    ],
                                    startPoint: UnitPoint(x: 0, y: 0.5),
                                    endPoint: UnitPoint(x: 1, y: 0.5)
                                )
                            )
                            .overlay(TakeDoseMorphismOverlay())
                            .cornerRadius(420.30264)
                            .shadow(color: Color(red: 0.2, green: 0.65, blue: 0.3).opacity(0.26), radius: 6.5, x: 8, y: 8)
                            .shadow(color: .white, radius: 6.5, x: -8, y: -8)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 25)
                .padding(.bottom, 16)
            }
            .background(Color.white)
            .navigationTitle("How it Helps You")
            .navigationBarTitleDisplayMode(.inline)
            
            // Arm image with thick blurry green outline overlay
            ArmImageWithGreenGlow()
                .offset(x: -12, y: -57)
                .allowsHitTesting(false)

            // Blue bullet dots above the Arm image, positioned separately
            BlueWaveDot()
                .offset(x: -27, y: -360)
                .allowsHitTesting(false)
            
            BlueWaveDot()
                .offset(x: 55, y: -150)
                .allowsHitTesting(false)
            
            // Right-side morphism labels (overlay only; does not affect existing layout)
            VStack(alignment: .trailing, spacing: 10) {
                Text("Helps relieve headache")
                    .font(.custom("Poppins", size: 14).weight(.medium))
                    .foregroundColor(.primary)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(takeDoseMorphismGray)
                    .overlay(TakeDoseMorphismOverlay())
                    .clipShape(Capsule())
                    .shadow(color: Color.black.opacity(0.08), radius: 6, x: 0, y: 3)
                    .offset(x: -120)
                
                Text("Heals Pain")
                    .font(.custom("Poppins", size: 14).weight(.medium))
                    .foregroundColor(.primary)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(takeDoseMorphismGray)
                    .overlay(TakeDoseMorphismOverlay())
                    .clipShape(Capsule())
                    .shadow(color: Color.black.opacity(0.08), radius: 6, x: 0, y: 3)
                    .offset(x: -130, y: 100)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            .padding(.trailing, 18)
            .padding(.top, 20)
            .allowsHitTesting(false)
            .zIndex(10)

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

                            Text("Dose Taken Logged")
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
