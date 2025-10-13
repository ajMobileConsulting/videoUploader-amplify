//
//  ContentView.swift
//  videoUploader-amplify
//
//  Created by Alexander Jackson on 10/8/25.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 1
    private var url: URL?

    init() {
        url = Bundle.main.url(forResource: "sample", withExtension: "mov")
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                VideoList()
            }
                .tabItem {
                    Label("List", systemImage: "line.3.horizontal")
                }
                .tag(0)

            if let url {
                NavigationStack {
                    VideoUploader(url: url)
                }
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                    .tag(1)
            }

            NavigationStack {
                AccountView()
            }
                .tabItem {
                    Label("Account", systemImage: "person.crop.circle.fill")
                }
                .tag(2)
        }

    }
}
