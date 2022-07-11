import Foundation

struct UserAccess: Decodable {
    var access_token: String = ""
    var token_type: String = ""
    var scope: String = ""
    var created_at: Int = 0
}
