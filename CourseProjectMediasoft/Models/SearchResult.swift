import Foundation

struct SearchResult: Decodable {
    let total: Int
    let results: [Pictures]
}

struct Pictures: Decodable {
    let width: Int
    let height: Int
    let urls: [URLType.RawValue: String]

    enum URLType: String {
        case raw
        case full
        case regular
        case small
        case thumb
    }
}

struct User: Decodable {
    let id: Int
    let description: String?
    let published_at: String
}

