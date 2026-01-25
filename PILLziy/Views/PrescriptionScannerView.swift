//
//  PrescriptionScannerView.swift
//  PILLziy
//
//  Created by Arfhan Ahmad on 1/24/26.
//

import SwiftUI
import Vision
import AVFoundation

private let scanFormGray = Color(white: 0.94)
private let scanCellGray = Color(white: 0.97)

/// Redraws image with orientation applied so Vision receives correctly oriented pixels.
private func normalizedImageForOCR(_ image: UIImage) -> CGImage? {
    guard image.imageOrientation != .up else { return image.cgImage }
    let size = image.size
    let format = UIGraphicsImageRendererFormat()
    format.scale = image.scale
    let renderer = UIGraphicsImageRenderer(size: size, format: format)
    let normalized = renderer.image { _ in image.draw(at: .zero) }
    return normalized.cgImage
}

struct PrescriptionScannerView: View {
    @EnvironmentObject var medicationStore: MedicationStore
    @State private var showScanner = false
    @State private var scannedImage: UIImage?
    @State private var showMedicationForm = false
    @State private var extractedText: String = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer(minLength: 0)
            
            HStack(spacing: -4) {
                Image("Logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 100)
                    .offset(y: -18)
                Text("ILLziy")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(.black)
                    .padding(.leading, -4)
            }
            .frame(maxWidth: .infinity)

            Button(action: {
                showScanner = true
            }) {
                HStack {
                    Image(systemName: "camera.fill")
                    Text("Scan Prescription")
                }
                .font(.headline)
                .foregroundColor(.black.opacity(0.75))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .padding(.horizontal, 24)
                .background(Color(white: 0.92))
                .clipShape(Capsule())
                .shadow(color: .white, radius: 6, x: 0, y: 4)
                .shadow(color: Color.gray.opacity(0.15), radius: 8, x: 0, y: 4)
            }
            .padding(.horizontal)

            if let image = scannedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 300)
                    .cornerRadius(12)
                    .padding()
            }
            
            if !extractedText.isEmpty {
                // Extracted Text – morphism-style design
                VStack(alignment: .leading, spacing: 10) {
                    Text("Extracted Text")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.secondary)
                    Text(extractedText)
                        .font(.system(size: 14))
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                        .lineSpacing(4)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(16)
                .background(scanCellGray)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.black.opacity(0.07),
                                    Color.black.opacity(0.02),
                                    Color.clear
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .allowsHitTesting(false)
                )
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
                .padding(.horizontal, 20)
                .padding(.top, 4)
                
                // Add Medication – morphism table
                VStack(spacing: 0) {
                    Button(action: {
                        showMedicationForm = true
                    }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 18))
                            Text("Add Medication")
                                .font(.system(size: 16, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .padding(.horizontal, 24)
                        .background(Color(red: 0.35, green: 0.72, blue: 0.42))
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
                        .shadow(color: Color.green.opacity(0.35), radius: 8, x: 0, y: 4)
                    }
                }
                .padding(16)
                .background(scanFormGray)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
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
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
                .padding(.horizontal, 20)
                .padding(.top, 8)
            }
            
            Spacer(minLength: 0)
        }
        .sheet(isPresented: $showScanner) {
            ScannerSheetView(scannedImage: $scannedImage, extractedText: $extractedText)
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

private struct ScannerSheetView: View {
    @Binding var scannedImage: UIImage?
    @Binding var extractedText: String
    @State private var showCamera = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Group {
            if showCamera {
                CustomCameraScanView(
                    onCapture: { image, text in
                        scannedImage = image
                        extractedText = text
                        dismiss()
                    },
                    onCancel: {
                        dismiss()
                    }
                )
            } else {
                ZStack {
                    Color(white: 0.96)
                        .ignoresSafeArea()
                    VStack(spacing: 20) {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .scaleEffect(1.4)
                        Text("Loading camera…")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            showCamera = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation(.easeInOut(duration: 0.3)) {
                    showCamera = true
                }
            }
        }
    }
}

// MARK: - Custom camera with manual Capture button

private struct CustomCameraScanView: UIViewControllerRepresentable {
    let onCapture: (UIImage, String) -> Void
    let onCancel: () -> Void
    
    func makeUIViewController(context: Context) -> CameraScanViewController {
        CameraScanViewController(onCapture: onCapture, onCancel: onCancel)
    }
    
    func updateUIViewController(_ uiViewController: CameraScanViewController, context: Context) {}
}

private final class CameraScanViewController: UIViewController {
    private let onCapture: (UIImage, String) -> Void
    private let onCancel: () -> Void
    
    private var captureSession: AVCaptureSession?
    private var photoOutput: AVCapturePhotoOutput?
    private var previewLayer: AVCaptureVideoPreviewLayer?
    private var captureButton: UIButton?
    private var isCapturing = false
    
    init(onCapture: @escaping (UIImage, String) -> Void, onCancel: @escaping () -> Void) {
        self.onCapture = onCapture
        self.onCancel = onCancel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupCamera()
        setupButtons()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer?.frame = view.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.captureSession?.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        captureSession?.stopRunning()
    }
    
    private func setupCamera() {
        let session = AVCaptureSession()
        session.sessionPreset = .photo
        
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
              let input = try? AVCaptureDeviceInput(device: device),
              session.canAddInput(input) else { return }
        session.addInput(input)
        
        let output = AVCapturePhotoOutput()
        guard session.canAddOutput(output) else { return }
        session.addOutput(output)
        photoOutput = output
        
        let layer = AVCaptureVideoPreviewLayer(session: session)
        layer.videoGravity = .resizeAspectFill
        layer.frame = view.bounds
        view.layer.addSublayer(layer)
        previewLayer = layer
        captureSession = session
    }
    
    private func setupButtons() {
        let cancel = UIButton(type: .system)
        cancel.setTitle("Cancel", for: .normal)
        cancel.setTitleColor(.white, for: .normal)
        cancel.titleLabel?.font = .systemFont(ofSize: 17, weight: .medium)
        cancel.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        cancel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cancel)
        
        let capture = UIButton(type: .system)
        capture.setTitle("Capture", for: .normal)
        capture.setTitleColor(.white, for: .normal)
        capture.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        capture.backgroundColor = UIColor.systemBlue
        capture.layer.cornerRadius = 28
        capture.addTarget(self, action: #selector(captureTapped), for: .touchUpInside)
        capture.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(capture)
        captureButton = capture
        
        NSLayoutConstraint.activate([
            cancel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            cancel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            capture.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            capture.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32),
            capture.widthAnchor.constraint(equalToConstant: 160),
            capture.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
    
    @objc private func cancelTapped() {
        onCancel()
    }
    
    @objc private func captureTapped() {
        guard !isCapturing, let output = photoOutput else { return }
        isCapturing = true
        captureButton?.isEnabled = false
        let settings = AVCapturePhotoSettings()
        output.capturePhoto(with: settings, delegate: self)
    }
    
    private func extractText(from image: UIImage, completion: @escaping (String) -> Void) {
        let cgImage = normalizedImageForOCR(image) ?? image.cgImage
        guard let cg = cgImage else {
            DispatchQueue.main.async { completion("") }
            return
        }
        let request = VNRecognizeTextRequest { request, _ in
            let text: String
            if let observations = request.results as? [VNRecognizedTextObservation] {
                text = observations.compactMap { $0.topCandidates(1).first?.string }.joined(separator: "\n")
            } else {
                text = ""
            }
            DispatchQueue.main.async { completion(text) }
        }
        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true
        request.recognitionLanguages = ["en-US"]
        if #available(iOS 16.0, *) {
            request.automaticallyDetectsLanguage = false
        }
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let handler = VNImageRequestHandler(cgImage: cg, options: [:])
                try handler.perform([request])
            } catch {
                DispatchQueue.main.async { completion("") }
            }
        }
    }
}

extension CameraScanViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        defer {
            DispatchQueue.main.async { [weak self] in
                self?.isCapturing = false
                self?.captureButton?.isEnabled = true
            }
        }
        guard error == nil,
              let data = photo.fileDataRepresentation(),
              let image = UIImage(data: data) else {
            DispatchQueue.main.async { [weak self] in self?.onCancel() }
            return
        }
        extractText(from: image) { [weak self] text in
            self?.onCapture(image, text)
        }
    }
}
