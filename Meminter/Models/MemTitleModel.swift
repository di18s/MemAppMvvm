import Foundation

typealias Titles = [MemTitleModel]

struct MemTitleModel: Codable {
    var titleId: Int
    var titleName: String
    
    enum  CodingKeys: String, CodingKey {
        case titleId = "titleId"
        case titleName = "titleName"
    }
    
}
