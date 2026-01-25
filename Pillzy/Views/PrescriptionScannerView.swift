//
//  PrescriptionScannerView.swift
//  Pillzy
//
//  Created by Arfhan Ahmad on 1/24/26.
//

import SwiftUI
import VisionKit
import Vision

struct PrescriptionScannerView: View {
    @EnvironmentObject var medicationStore: MedicationStore
    @State private var showScanner = false
    @State private var scannedImage: UIImage?
    @State private var showMedicationForm = false
    @State private var extractedText: String = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Scan Prescription")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            
            if let image = scannedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 300)
                    .cornerRadius(12)
                    .padding()
            }
            
            Button(action: {
                showScanner = true
            }) {
                HStack {
                    Image(systemName: "camera.fill")
                    Text("Scan Prescription")
                }
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .cornerRadius(12)
            }
            .padding(.horizontal)
            .sheet(isPresented: $showScanner) {
                DocumentScannerView(scannedImage: $scannedImage, extractedText: $extractedText)
            }
            
            if !extractedText.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Extracted Text:")
                        .font(.headline)
                    Text(extractedText)
                        .font(.body)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                }
                .padding()
                
                Button(action: {
                    showMedicationForm = true
                }) {
                    Text("Add Medication")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
            }
        }
        .sheet(isPresented: $showMedicationForm) {
            MedicationFormView(
                scannedImage: scannedImage,
                extractedText: extractedText,
                medicationStore: medicationStore
            )
        }
    }
}

struct DocumentScannerView: UIViewControllerRepresentable {
    @Binding var scannedImage: UIImage?
    @Binding var extractedText: String
    @Environment(\.dismiss) var dismiss
    
    func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
        let scanner = VNDocumentCameraViewController()
        scanner.delegate = context.coordinator
        return scanner
    }
    
    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        let parent: DocumentScannerView
        
        init(_ parent: DocumentScannerView) {
            self.parent = parent
        }
        
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            if scan.pageCount > 0 {
                let image = scan.imageOfPage(at: 0)
                parent.scannedImage = image
                extractText(from: image)
            }
            parent.dismiss()
        }
        
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
            parent.dismiss()
        }
        
        func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
            parent.dismiss()
        }
        
        private func extractText(from image: UIImage) {
            guard let cgImage = image.cgImage else { return }
            
            let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            let request = VNRecognizeTextRequest { request, error in
                guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
                
                let recognizedStrings = observations.compactMap { observation in
                    observation.topCandidates(1).first?.string
                }
                
                DispatchQueue.main.async {
                    self.parent.extractedText = recognizedStrings.joined(separator: "\n")
                }
            }
            
            request.recognitionLevel = .accurate
            try? requestHandler.perform([request])
        }
    }
}
