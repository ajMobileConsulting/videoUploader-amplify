//
//  videoUploader_amplifyApp.swift
//  videoUploader-amplify
//
//  Created by Alexander Jackson on 10/8/25.
//

import Amplify
import Authenticator
import AWSCognitoAuthPlugin
import AWSS3StoragePlugin
import AWSDataStorePlugin
import AWSAPIPlugin
import SwiftUI

@main
struct videoUploader_amplifyApp: App {
    init() {
        do {
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.add(plugin: AWSAPIPlugin())
            try Amplify.add(plugin: AWSDataStorePlugin(modelRegistration: AmplifyModels()))
            try Amplify.add(plugin: AWSS3StoragePlugin())
            try Amplify.configure(with: .amplifyOutputs)
        } catch {
            print("Unable to configure Amplify \(error.localizedDescription)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
