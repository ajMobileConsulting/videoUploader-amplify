//
//  PageViewModel.swift
//  videoUploader-amplify
//
//  Created by Alexander Jackson on 10/15/25.
//

import Amplify
import Combine
import Foundation

class PageViewModel: ObservableObject {
    @MainActor
    func fetchPage(id: String) async {
        let request = GraphQLRequest<String>(
            document: """
                query GetPage {
                  getPage(id: 5643) {
                    id
                    date
                    date_gmt
                    title
                    content
                  }
                }
                """,
//            variables: ["id": id],
            responseType: String.self
        )

        do {
            let result = try await Amplify.API.query(request: request)
            switch result {
            case .success(let jsonString):
                let data = Data(jsonString.utf8)
                let page = try JSONDecoder().decode(PageResponse.self, from: data)
//                print(jsonString, "jsonString <><")
//                print(data, "data <><")
//                print(page, "page <><")
                print(page.getPage.id, "<><")
                print(page.getPage.title, "<><")
                print(page.getPage.date, "<><")
            case .failure(let error):
                print(error)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
