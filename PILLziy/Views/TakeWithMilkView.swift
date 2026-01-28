//
//  TakeWithMilkView.swift
//  PILLziy
//
//  Created by Arfhan Ahmad on 1/24/26.
//

import SwiftUI

private let milkMorphismGray = Color(white: 0.97)

private struct MilkMorphismOverlay: View {
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

struct TakeWithMilkView: View {
    @State private var isVideoPlaying = true
    @State private var hasStoppedVideo = false

    private let steps: [String] = [
        "Take Pill",
        "Sip Milk",
        "Swallow Pill",
        "Drink Slowly"
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 18) {
                // Outer container (wraps everything)
                VStack(spacing: 0) {
                    HStack(alignment: .bottom, spacing: 14) {
                        // Milk card
                        ZStack(alignment: .topTrailing) {
                            VStack(spacing: 0) {
                                Image("Milk")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: 255) // 1.5x larger
                                    .padding(.top, 14)
                                    .padding(.bottom, 10)
                            }
                            .frame(maxWidth: .infinity)
                            .background(milkMorphismGray)
                            .overlay(MilkMorphismOverlay())
                            .clipShape(RoundedRectangle(cornerRadius: 18))
                            .shadow(color: Color.black.opacity(0.16), radius: 16, x: 0, y: 9)

                            Image("Check")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 78, height: 78) // 3x larger
                                .padding(10)
                        }

                        // Video (right)
                        LoopingPillVideoView(videoName: "TakeWithMilkVideo", isPlaying: isVideoPlaying)
                            .frame(width: 150, height: 210)
                            .background(Color.clear)
                    }

                    // bring the table down a bit
                    Spacer()
                        .frame(height: 12)

                    // Steps heading
                    HStack {
                        Text("How to take")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.primary)
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 6)

                    // Steps table
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(Array(steps.enumerated()), id: \.offset) { idx, step in
                            HStack(spacing: 14) {
                                Image("Bullet")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 72, height: 72) // 4x larger

                                Text(step)
                                    .font(.system(size: 17, weight: .semibold))
                                    .foregroundColor(.primary)

                                Spacer()
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)

                            if idx != steps.count - 1 {
                                Divider()
                                    .padding(.leading, 90)
                            }
                        }
                    }
                    .background(milkMorphismGray)
                    .overlay(MilkMorphismOverlay())
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                    .shadow(color: Color.black.opacity(0.12), radius: 14, x: 0, y: 8)
                }
                .padding(16)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 22))
                .shadow(color: Color.black.opacity(0.14), radius: 18, x: 0, y: 10)
            }
            .padding(.horizontal, 20)
            .padding(.top, 18)
            .padding(.bottom, 24)
        }
        .background(Color.white)
        .navigationTitle("Take it With Milk")
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
        TakeWithMilkView()
    }
}

