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
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.url = try container.decode(forKey: .url)
        self.id = try container.decode(forKey: .id)
        self.title = try container.decode(forKey: .title)
        self.likeCount = try container.decode(forKey: .likeCount)
        self.dislikeCount = try container.decode(forKey: .dislikeCount)
    }
    
}
