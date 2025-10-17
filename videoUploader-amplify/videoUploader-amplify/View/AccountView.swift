//
//  AccountView.swift
//  videoUploader-amplify
//
//  Created by Alexander Jackson on 10/9/25.
//

import AWSCognitoAuthPlugin
import Amplify
import Authenticator
import SwiftUI
internal import AWSPluginsCore

struct AccountView: View {
    var body: some View {
        Authenticator { state in
            VStack {
                Button("Get Token Hopefully") {
                    Task {
                        await jwtToken()
                    }
                }
                
                Button("Sign out") {
                    Task {
                        await state.signOut()
                    }
                }
            }
            .onAppear {
                Task {
                    await PageViewModel().fetchPage(id: "5643")
                }
            }
        }
        .navigationTitle("Account")
    }

    private func jwtToken() async {
        do {
            let session = try await Amplify.Auth.fetchAuthSession()

            if let cognitoSession = session as? AWSAuthCognitoSession {
                let tokens = cognitoSession.getCognitoTokens()
                switch tokens {
                case .success(let token):
                    print("Access:", token.accessToken)
                    print("ID:", token.idToken)
                    print("Refresh:", token.refreshToken)
                case .failure(let error): print(error.localizedDescription)
                }
                print(tokens)
            }
        } catch {
            print("Error fetching jwtToken. \(error.localizedDescription)")
        }
    }
}
