// swiftlint:disable all
import Amplify
import Foundation

public struct Page: Embeddable {
  var id: Int?
  var date: String?
  var date_gmt: String?
  var title: String?
  var content: String?
}