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
    
    var body: some View {
        VStack(spacing: 0) {
            Text("The Impact of Missing a Dose")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(.top, 8)
                .padding(.horizontal, 20)

            Spacer(minLength: 16)

            HStack(alignment: .bottom, spacing: 16) {
                Image("BodyDoseSkip")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 260)
                    .clipShape(RoundedRectangle(cornerRadius: 12))

                Spacer()

                LoopingPillVideoView()
                    .frame(width: 120, height: 120)
                    .background(Color.clear)
            }
            .padding(.horizontal, 20)

            Spacer()

            Button(action: {
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
        .navigationTitle(medication.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        SkipDoseImpactView(medication: Medication(name: "Tylenol 500", dosage: "500mg", frequency: "1 Pill Daily"))
    }
}
