//
//  ProgressViewSection.swift
//  videoUploader-amplify
//
//  Created by Alexander Jackson on 10/9/25.
//

import Combine
import SwiftUI

struct ProgressSection: View {
    @ObservedObject var viewModel: UploadViewModel
    @State var currentProgress: Double = 0.0
    @Binding var isUploading: Bool
    let onPause: () -> Void
    let onCancel: () -> Void

    var body: some View {
        Group {
            switch viewModel.uploadState {
            case .uploading(let progress):
                ProgressView(value: progress, total: 100) {
                    Text("Uploading \(Int(progress))%")
                }
                .task {
                    currentProgress = progress
                }
            case .success(let key):
                Text("✅ Success uploading to S3 Bucket check Amplify dashboard. Key \(key)")
            case .failed(let error):
                RoundedRectangle(cornerRadius: 8)
                    .foregroundStyle(Color.red)
                    .overlay {
                        Text("Failed with error: \(error.localizedDescription)")
                            .foregroundStyle(Color.white)
                            .font(.caption)
                    }
                    .frame(maxHeight: 50)
                    .padding()
           
            case .cancelled:
                Text("User Cancelled operation.")
            case .paused:
                Text("⏸️ Pased. Please press resume to continue.")
            default:
                EmptyView()
            }
//            HStack {
//                Button(isPaused ? "Resume" : "Pause") {
//                    isPaused.toggle()
//                    isPaused
//                        ? viewModel.resumeUpload()
//                        : viewModel.pauseUpload()
//                    if currentProgress == 100.0 {
//                        isPaused = false
//                    }
//                }
//                Button("Cancel") {
//                    viewModel.cancelUpload()
//                }
//            }
            HStack(spacing: 20) {
                Button(isUploading ? "⏸ Pause" : "▶ Resume", action: onPause)
                Button("✖️ Cancel", action: onCancel)
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(12)
        // ✅ Hide without removing from layout
        .opacity(isUploading ? 1 : 0)
        .frame(height: isUploading ? nil : 0)
        .animation(.easeInOut(duration: 0.25), value: isUploading)
    }
}

