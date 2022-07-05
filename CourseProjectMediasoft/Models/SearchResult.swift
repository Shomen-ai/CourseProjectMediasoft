import Foundation

struct SearchResult: Decodable {
    let total: Int
    let results: [Pictures]
}

struct Pictures: Decodable {
    let width: Int
    let height: Int
    let urls: [URLType.RawValue: String]
    let likes: Int
    let created_at: String
    let description: String?

    struct User: Decodable {
        let id: String
        let username: String
        let name: String
        let profile_image: [ProfileImageURL.RawValue: String]

        enum ProfileImageURL: String {
            case small
            case medium
            case large
        }
    }

    let user: User
    enum URLType: String {
        case raw
        case full
        case regular
        case small
        case thumb
    }
}

