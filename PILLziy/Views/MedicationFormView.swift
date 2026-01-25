//
//  MedicationFormView.swift
//  PILLziy
//
//  Created by Arfhan Ahmad on 1/24/26.
//

import SwiftUI
import UIKit

private let formGray = Color(white: 0.94)
private let cellGray = Color(white: 0.97)
private let confirmGreen = Color(red: 0.45, green: 0.82, blue: 0.52)

private func extractDominantColor(from image: UIImage) -> Color {
    guard let cgImage = image.cgImage else { return .gray }
    let w = 40
    let h = 40
    let size = CGSize(width: w, height: h)
    let colorSpace = CGColorSpaceCreateDeviceRGB()
    let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
    guard let ctx = CGContext(
        data: nil,
        width: w,
        height: h,
        bitsPerComponent: 8,
        bytesPerRow: w * 4,
        space: colorSpace,
        bitmapInfo: bitmapInfo.rawValue
    ) else { return .gray }
    ctx.draw(cgImage, in: CGRect(origin: .zero, size: size))
    guard let data = ctx.data else { return .gray }
    let buf = data.bindMemory(to: UInt8.self, capacity: w * h * 4)
    var r: Double = 0, g: Double = 0, b: Double = 0
    var n = 0
    for y in 0..<h {
        for x in 0..<w {
            let i = (y * w + x) * 4
            let red = Double(buf[i]) / 255
            let green = Double(buf[i + 1]) / 255
            let blue = Double(buf[i + 2]) / 255
            let brightness = (red + green + blue) / 3
            if brightness > 0.85 || brightness < 0.15 { continue }
            if red > 0.9 && green > 0.9 && blue > 0.9 { continue }
            r += red
            g += green
            b += blue
            n += 1
        }
    }
    if n == 0 { return .gray }
    r /= Double(n)
    g /= Double(n)
    b /= Double(n)
    return Color(red: r, green: g, blue: b)
}

private struct FormMorphismCell<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(cellGray)
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.black.opacity(0.08),
                                Color.black.opacity(0.02),
                                Color.clear
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .allowsHitTesting(false)
            )
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .shadow(color: Color.black.opacity(0.06), radius: 6, x: 0, y: 3)
    }
}

struct MedicationFormView: View {
    let scannedImage: UIImage?
    let extractedText: String
    @ObservedObject var medicationStore: MedicationStore
    @Environment(\.dismiss) var dismiss
    
    @State private var medicationName: String = ""
    @State private var dosage: String = ""
    @State private var frequency: String = "1 Pill Daily"
    @State private var pillColor: Color = .gray
    
    var body: some View {
        VStack(spacing: 0) {
            // Morphism table – half-screen content
            VStack(spacing: 12) {
                FormMorphismCell {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Medication Name")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        TextField("e.g. Tylenol 500", text: $medicationName)
                            .font(.body)
                            .foregroundColor(.primary)
                    }
                }
                
                FormMorphismCell {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Pill Color")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text("From scanner")
                                .font(.caption2)
                                .foregroundColor(.secondary.opacity(0.8))
                        }
                        Spacer()
                        Circle()
                            .fill(pillColor)
                            .frame(width: 40, height: 40)
                            .overlay(Circle().stroke(Color.gray.opacity(0.3), lineWidth: 1))
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 24)
            .padding(.bottom, 20)
            .frame(maxWidth: .infinity)
            .background(formGray)
            .overlay(
                RoundedRectangle(cornerRadius: 28)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.black.opacity(0.08),
                                Color.black.opacity(0.02),
                                Color.clear
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .allowsHitTesting(false)
            )
            .clipShape(RoundedRectangle(cornerRadius: 28))
            .shadow(color: Color.black.opacity(0.1), radius: 12, x: 0, y: 4)
            .padding(.horizontal, 20)
            
            Spacer(minLength: 0)
            
            // Buttons – VStack
            VStack(spacing: 12) {
                Button(action: { saveMedication() }) {
                    Text("Confirm Medication")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .padding(.horizontal, 24)
                        .background(confirmGreen)
                        .overlay(
                            Capsule()
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            Color.black.opacity(0.15),
                                            Color.black.opacity(0.03),
                                            Color.clear
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .allowsHitTesting(false)
                        )
                        .clipShape(Capsule())
                        .shadow(color: confirmGreen.opacity(0.4), radius: 8, x: 0, y: 4)
                }
                .disabled(medicationName.isEmpty)
                .opacity(medicationName.isEmpty ? 0.6 : 1)
                
                Button(action: { dismiss() }) {
                    Text("Cancel")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .padding(.horizontal, 24)
                        .background(cellGray)
                        .overlay(
                            Capsule()
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            Color.black.opacity(0.1),
                                            Color.black.opacity(0.02),
                                            Color.clear
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .allowsHitTesting(false)
                        )
                        .clipShape(Capsule())
                        .shadow(color: Color.black.opacity(0.08), radius: 6, x: 0, y: 3)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 32)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(white: 0.97))
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
        .onAppear {
            if medicationName.isEmpty && !extractedText.isEmpty {
                let lines = extractedText.components(separatedBy: .newlines)
                for line in lines {
                    if line.count > 3 && line.count < 50 {
                        medicationName = line.trimmingCharacters(in: .whitespaces)
                        break
                    }
                }
            }
            if let img = scannedImage {
                pillColor = extractDominantColor(from: img)
            }
        }
    }
    
    private func saveMedication() {
        var imageData: Data? = nil
        if let image = scannedImage {
            imageData = image.jpegData(compressionQuality: 0.8)
        }
        
        let medication = Medication(
            name: medicationName.isEmpty ? "TYLENOL 500" : medicationName,
            dosage: dosage.isEmpty ? "500mg" : dosage,
            frequency: frequency,
            labelImageData: imageData
        )
        
        medicationStore.addMedication(medication)
        dismiss()
    }
}
