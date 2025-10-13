//
//  VideoListViewModel.swift
//  videoUploader-amplify
//
//  Created by Alexander Jackson on 10/9/25.
//

import Amplify
import Combine
import Foundation

final class VideoListViewModel: ObservableObject {
    struct Model {
        let id = UUID()
        let name: String
        let path: URL
    }
    
    @Published var videos: [Model] = []

    func fetchVideos() async throws {
        guard let user = try? await Amplify.Auth.getCurrentUser() else {
            throw NSError(domain: "AmplifyAuth", code: 403, userInfo: [NSLocalizedDescriptionKey: "No authenticated user."])
        }
        let path = "user-videos/\(user.userId)/"
            
        let videoList = try await Amplify.Storage.list(
            path: .fromString(path),
            options: .init(accessLevel: .protected)
        )
        
        var array: [Model] = []
        videoList.items.forEach { video in
            print("Path:", video.path, URL(string: video.path)!.deletingPathExtension().lastPathComponent)
            if let videoPath = URL(string: video.path) {
               let videoTitle = videoPath.deletingPathExtension().lastPathComponent
                array.append(Model(name: videoTitle, path: videoPath))
            }
        }
        videos = array
    }
}
