//
//  SkipDoseImpactView.swift
//  PILLziy
//
//  Created by Arfhan Ahmad on 1/24/26.
//

import SwiftUI

private let impactMorphismGray = Color(white: 0.94)

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

struct SkipDoseImpactView: View {
    let medication: Medication
    @Environment(\.dismiss) var dismiss
    @State private var isPillVideoPlaying = true
    @State private var hasStoppedVideo = false
    
    var body: some View {
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
                dismiss()
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "xmark")
                        .font(.system(size: 16, weight: .semibold))
                    Text("Dose Skipped")
                        .font(.system(size: 17, weight: .semibold))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.red)
                .overlay(ImpactMorphismOverlay())
                .clipShape(Capsule())
                .shadow(color: Color.red.opacity(0.35), radius: 8, x: 0, y: 4)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 24)
        }
        .background(Color.white)
        .navigationTitle("The Impact of Missing a Dose")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        SkipDoseImpactView(medication: Medication(name: "Tylenol 500", dosage: "500mg", frequency: "1 Pill Daily"))
    }
}
