//
//  ContentView.swift
//  videoUploader-amplify
//
//  Created by Alexander Jackson on 10/8/25.
//

import AVKit
import AWSPluginsCore
import Amplify
import Authenticator
import PhotosUI
import SwiftUI

struct ContentView: View {
    //    @State private var selectedVideo: PhotosPickerItem?
    //    @State private var image: Image?
    private var url: URL?

    init() {
        url = Bundle.main.url(forResource: "waterfall", withExtension: "mov")
    }

    var body: some View {
        Authenticator { state in
            VStack {
                if let url {
                    VideoPlayer(player: AVPlayer(url: url))
                        .frame(
                            maxWidth: 300,
                            maxHeight: 400,
                            alignment: .center
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }

                Button("Upload Media") {
                    Task {
                        do {
                            guard
                                let user = try? await Amplify.Auth
                                    .getCurrentUser()
                            else {
                                print("❌ No authenticated user.")
                                return
                            }

                            guard
                                let url = Bundle.main.url(
                                    forResource: "waterfall",
                                    withExtension: "mov"
                                )
                            else {
                                print("❌ Local file not found.")
                                return
                            }

                            // Use correct path based on your Storage definition
                            let key = "user-videos/\(user.userId)/sample.mov"

                            let result = Amplify.Storage.uploadFile(
                                path: .fromString(key),
                                local: url,
                            )
                            for await progress in await result.progress {
                                print("Progress: \(progress)")
                            }
                            
                            let uploadSuccess = try await result.value

                            print("✅ Uploaded successfully with key: \(uploadSuccess)")
                        } catch {
                            print("❌ Upload failed: \(error)")
                        }
                    }
                }

                Button("Sign out") {
                    Task {
                        await state.signOut()
                    }
                }
            }
        }
    }
}

//#Preview {
//    ContentView()
//}
