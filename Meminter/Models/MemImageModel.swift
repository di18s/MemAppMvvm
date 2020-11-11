import Foundation

typealias Images = [MemImageModel]

struct MemImageModel: Codable {
    var url: String
    var picId: Int
    
    enum  CodingKeys: String, CodingKey {
        case url = "url"
        case picId = "picId"
    }
}
