//
//  BodyMapView.swift
//  PILLziy
//
//  Created by Arfhan Ahmad on 1/24/26.
//

import SwiftUI

private let bodyMapMorphismGray = Color(white: 0.97)

private struct BodyMapMorphismOverlay: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 18)
            .fill(
                LinearGradient(
                    colors: [
                        Color.black.opacity(0.10),
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

private struct SymptomTapStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(white: 0.9))
                    .opacity(configuration.isPressed ? 1 : 0)
            )
    }
}

private struct GradientPainSlider: View {
    @Binding var value: Double // 0...1

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let thumbSize: CGFloat = 26
            let trackHeight: CGFloat = 10
            let x = CGFloat(value) * (w - thumbSize)

            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color(white: 0.90))
                    .frame(height: trackHeight)

                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [Color.yellow, Color.orange, Color.red],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: max(thumbSize, x + thumbSize / 2), height: trackHeight)

                Circle()
                    .fill(Color.blue)
                    .frame(width: thumbSize, height: thumbSize)
                    .shadow(color: Color.black.opacity(0.18), radius: 6, x: 0, y: 3)
                    .offset(x: x)
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { g in
                                let clamped = min(max(0, g.location.x - thumbSize / 2), w - thumbSize)
                                value = Double(clamped / (w - thumbSize))
                            }
                    )
            }
        }
        .frame(height: 30)
    }
}

struct BodyMapView: View {
    @State private var painLevel: Double = 0.25
    @State private var isVideoPlaying = true
    @State private var hasStoppedVideo = false

    private let symptoms: [(image: String, title: String)] = [
        ("Pain", "Pain"),
        ("Vomit", "Vomit"),
        ("Dizzy", "Dizzy"),
        ("Diarrhea", "Diarrhea")
    ]

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Tap where it hurts.")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 10)

                    GradientPainSlider(value: $painLevel)

                    HStack {
                        Text("Mild")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.primary)
                        Spacer()
                        Text("Moderate")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.primary)
                        Spacer()
                        Text("Severe")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.primary)
                    }
                    .padding(.top, -6)

                    HStack(alignment: .bottom, spacing: 14) {
                        // Body image (same styling as Take Dose flow)
                        ZStack(alignment: .bottomLeading) {
                            Image("Take dose")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: 260)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .scaleEffect(2.1, anchor: .bottomLeading)
                        }
                        .offset(x: -10)

                        Spacer(minLength: 8)

                        LoopingPillVideoView(videoName: "SideEffectVideo", isPlaying: isVideoPlaying)
                            .frame(width: 150, height: 150)
                            .background(Color.clear)
                    }
                    .padding(.top, 8)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 0)
            }

            // Bottom symptom buttons
            HStack(spacing: 18) {
                ForEach(Array(symptoms.enumerated()), id: \.offset) { _, item in
                    Button(action: {
                        hasStoppedVideo = true
                        isVideoPlaying = false
                    }) {
                        VStack(spacing: 8) {
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
                                    .shadow(color: Color.black.opacity(0.10), radius: 10, x: 0, y: 6)

                                Image(item.image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: item.title == "Vomit" ? 22 : 34,
                                           height: item.title == "Vomit" ? 22 : 34)
                            }
                            .frame(width: 72, height: 72)

                            Text(item.title)
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(.primary)
                        }
                    }
                    .buttonStyle(SymptomTapStyle())
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 24)
        }
        .background(Color.white)
        .navigationTitle("Body Map")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { isVideoPlaying = !hasStoppedVideo }
        .onDisappear {
            hasStoppedVideo = true
            isVideoPlaying = false
        }
    }
}

#Preview {
    NavigationStack {
        BodyMapView()
    }
}

