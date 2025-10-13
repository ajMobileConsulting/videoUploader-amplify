//
//  VideoPlayer.swift
//  videoUploader-amplify
//
//  Created by Alexander Jackson on 10/9/25.
//

import AVKit
import PhotosUI
import SwiftUI
import UniformTypeIdentifiers

struct VideoUploader: View {
    @StateObject private var viewModel: UploadViewModel = .init()
    @State var isPaused = false
    @State private var mediaItem: PhotosPickerItem?
    @State private var selectedURL: URL
    let url: URL
    //    private var player: AVPlayer?
    init(url: URL) {
        self.url = url
        _selectedURL = State(wrappedValue: url)
    }

    var body: some View {
        VStack {

            if case .uploading(let progress) = viewModel.uploadState {
                ProgressView(value: progress, total: 100.0) {
                    VStack {
                        Text("Progress: \(Int(progress))")
                    }
                }
                .padding()

                HStack {
                    Button(isPaused ? "Resume" : "Pause") {
                        isPaused.toggle()
                        
                        if isPaused {
                            viewModel.pauseUpload()
                        } else {
                            viewModel.resumeUpload()
                        }
                        
                        if viewModel.currentProgress == 100.0 {
                            isPaused = false
                        }
                    }
                    .onDisappear {
                        isPaused = false
                    }
                    Button("Cancel") {
                        viewModel.cancelUpload()
                    }
                }
            }

            VideoViewer(url: $selectedURL)
                .frame(
                    maxWidth: 300,
                    maxHeight: 400,
                    alignment: .center
                )
                .clipShape(RoundedRectangle(cornerRadius: 12))

            Spacer()

            HStack(alignment: .center) {
                // 📸 Custom “Choose” Button (Picker)

                PhotosPicker(
                    selection: $mediaItem,
                    matching: .videos,  // ✅ videos only
                    preferredItemEncoding: .automatic,  // ✅ keeps original format
                    photoLibrary: .shared()
                ) {
                    Label("Choose Video", systemImage: "film")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .onChange(of: mediaItem) { _, newItem in
                    guard let newItem else { return }

                    Task {
                        do {
                            // ✅ 1. Load as Data (not URL)
                            guard
                                let data = try await newItem.loadTransferable(
                                    type: Data.self
                                )
                            else {
                                print("❌ Failed to load video data")
                                return
                            }

                            // ✅ 2. Always save as .mov for now
                            let tempURL = FileManager.default.temporaryDirectory
                                .appendingPathComponent(UUID().uuidString)
                                .appendingPathExtension("mov")

                            try data.write(to: tempURL)
                            print("✅ Saved video at:", tempURL.path)

                            // ✅ 3. Optional: confirm type
                            if let type = UTType(filenameExtension: "mov") {
                                print("🎞️ Type:", type.identifier)
                                print("🎬 Is video:", type.conforms(to: .movie))
                            }

                            // ✅ 4. Assign for playback or upload
                            selectedURL = tempURL

                        } catch {
                            print(
                                "❌ Error loading video:",
                                error.localizedDescription
                            )
                        }
                    }
                }

                Button("Upload") {
                    Task {
                        let fileName = selectedURL.lastPathComponent
                        await viewModel.uploadMedia(
                            fileName: fileName,
                            path: selectedURL
                        )
                    }

                }
                .frame(maxWidth: .infinity)
            }
            .padding()

            Spacer()
        }
        .navigationTitle("Upload")
    }
}
