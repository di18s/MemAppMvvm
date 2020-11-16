import Foundation

typealias Mems = [MemModel]

struct MemModel: Codable {
    var id: Int
    var url: String
    var title: String
    var likeCount: Int
    var dislikeCount: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "memId"
        case url = "url"
        case title = "titleName"
        case likeCount = "likeCount"
        case dislikeCount = "dislikeCount"
    }
}
