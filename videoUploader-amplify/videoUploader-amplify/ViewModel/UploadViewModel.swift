//
//  VideoUploadViewModel.swift
//  videoUploader-amplify
//
//  Created by Alexander Jackson on 10/8/25.
//

import Amplify
import Combine
import Foundation

final class UploadViewModel: ObservableObject {
    enum UploadState {
        case idle
        case uploading(progress: Double)
        case success(key: String)
        case failed(error: StorageError)
        case cancelled
        case paused(progress: Double)
    }

    @Published var uploadState: UploadState = .idle
    @Published var currentProgress: Double = 0.0
    private var currentUpload: StorageUploadFileTask?
    private var fileName: String?
    private var path: URL?

    func resumeUpload() {
        print("Resume")
//        currentUpload?.resume()
//        Task {
//            if let fileName, let path {
//                await uploadMedia(fileName: fileName, path: path)
//            }
//        }
    }

    func pauseUpload() {
        print("Pause")
        if let currentUpload {
            currentUpload.pause()
        }
        uploadState = .paused(progress: currentProgress)
    }

    func cancelUpload() {
        print("Cancel")
        currentUpload?.cancel()
        uploadState = .cancelled
    }

    func uploadMedia(fileName: String, path: URL) async {
        self.fileName = fileName
        self.path = path
        do {
            guard try await Amplify.Auth.fetchAuthSession().isSignedIn else {
                uploadState = .failed(
                    error: StorageError.accessDenied(
                        "User not signed in.",
                        "Please sign in.",
                        NSError(domain: "AmplifyAuth", code: 401)
                    )
                )
                throw NSError(
                    domain: "AmplifyAuth",
                    code: 401,
                    userInfo: [NSLocalizedDescriptionKey: "User not signed in"]
                )
            }

            guard let user = try? await Amplify.Auth.getCurrentUser() else {
                uploadState = .failed(
                    error: StorageError.accessDenied(
                        "No authenticated user found.",
                        "Please sign in.",
                        NSError(domain: "AmplifyAuth", code: 403)
                    )
                )
                throw NSError(
                    domain: "AmplifyAuth",
                    code: 403,
                    userInfo: [
                        NSLocalizedDescriptionKey: "No authenticated user."
                    ]
                )
            }

            //        guard let url = Bundle.main.url(forResource: "sample", withExtension: "mov") else {
            //            uploadState = .failed(error: StorageError.accessDenied("Local file not found.", "Please try again or ensure file exist", NSError(domain: "AmplifyStorage", code: 404)))
            //            throw NSError(domain: "AmplifyStorage", code: 404, userInfo: [NSLocalizedDescriptionKey: "Local file not found."])
            //        }

            let key = "user-videos/\(user.userId)/\(fileName)"

            let upload = Amplify.Storage.uploadFile(
                path: .fromString(key),
                local: path,
                options: .init(
                    metadata: ["Content-Disposition": "inline"],
                    contentType: "video/quicktime-movie"
                )
            )

            currentUpload = upload
            uploadState = .uploading(progress: 0)

            // Monitor progress if desired
            for await progress in await upload.progress {
                print("Progress: \(progress.fractionCompleted * 100)%")
                currentProgress = progress.fractionCompleted * 100
                uploadState = .uploading(progress: currentProgress)
            }

            // Return the success result (throws automatically if failure)
            let result = try await upload.value
            uploadState = .success(key: result)
        } catch (let error) {
            if Task.isCancelled {
                uploadState = .cancelled
            }
            uploadState = .failed(error: .unknown(error.localizedDescription))
        }
    }
}
