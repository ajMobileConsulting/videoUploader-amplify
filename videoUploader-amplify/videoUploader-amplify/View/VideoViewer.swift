//
//  VideoViewer.swift
//  videoUploader-amplify
//
//  Created by Alexander Jackson on 10/9/25.
//

import Amplify
import AVKit
import SwiftUI

struct VideoViewer: View {
    enum VideoViewerType {
        case aws
        case local
    }
    
    @Binding var url: URL
//    private var imageURL
    
    func imageURL() async throws {
        try await Amplify.Storage.getURL(
            path: .fromString(url.absoluteString)
        )
    }
    
    var body: some View {
        
        VideoPlayer(player: AVPlayer(url: url))
            .frame(
                maxWidth: 300,
                maxHeight: 400,
                alignment: .center
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
