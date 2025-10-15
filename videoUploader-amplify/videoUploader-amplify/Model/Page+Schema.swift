// swiftlint:disable all
import Amplify
import Foundation

extension Page {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case date
    case date_gmt
    case title
    case content
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let page = Page.keys
    
    model.listPluralName = "Pages"
    model.syncPluralName = "Pages"
    
    model.fields(
      .field(page.id, is: .optional, ofType: .int),
      .field(page.date, is: .optional, ofType: .string),
      .field(page.date_gmt, is: .optional, ofType: .string),
      .field(page.title, is: .optional, ofType: .string),
      .field(page.content, is: .optional, ofType: .string)
    )
    }
}