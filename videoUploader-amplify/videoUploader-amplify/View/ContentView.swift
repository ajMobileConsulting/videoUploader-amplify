//
//  ContentView.swift
//  videoUploader-amplify
//
//  Created by Alexander Jackson on 10/8/25.
//

import AVKit
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
                            let userId = try await Amplify.Auth.getCurrentUser()
                                .userId
                            let key = "user-videos/\(userId)/sample.mov"

                            guard let url = url else { return }
                            let result = Amplify.Storage.uploadFile(
                                path: .fromString("waterfall"), local: url
                            )
                            print("✅ Uploaded: \(result)")
                        } catch {
                            print("❌ Upload failed: \(error)")
                        }
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

//#Preview {
//    ContentView()
//}
