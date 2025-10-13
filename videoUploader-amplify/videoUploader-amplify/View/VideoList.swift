//
//  VideoList.swift
//  videoUploader-amplify
//
//  Created by Alexander Jackson on 10/9/25.
//

import SwiftUI

struct VideoList: View {
    @StateObject var viewModel: VideoListViewModel = .init()
    var body: some View {
        List(viewModel.videos, id: \.id) { videoModel in
            NavigationLink(destination: {
                VideoViewer(url: .constant(videoModel.path))
            }, label: {
                Text(videoModel.name)
            })
        }
        .navigationTitle("Videos")
            .task{
                do {
                    try await viewModel.fetchVideos()
                } catch {
                    print(error.localizedDescription)
                }
            }
    }
}

struct VideoListPreview: PreviewProvider {
    static var previews: some View {
        VideoList()
    }
}
