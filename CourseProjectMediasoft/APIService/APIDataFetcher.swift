import Foundation
import UIKit

class APIDataFetcher {

    var apiService = APIService()

    func fetchImages(searchString: String, completion: @escaping (SearchResult?) -> Void) {
        apiService.requestForPhotos(searchString: searchString) { data, error in
            guard let data = data, error == nil else {
                print("Error recevied requasting data: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }

            let decode = self.decodeJSON(type: SearchResult.self, from: data)
            completion(decode)
        }
    }

    func fetchUserAccess(code: String, completion: @escaping (SearchResult?) -> Void) {
        apiService.requestUrlTokenAuth(code: code) { data, error in
            guard let data = data, error == nil else {
                print("Error recevied requasting data: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }

            let decode = self.decodeJSON(type: SearchResult.self, from: data)
            completion(decode)
        }
    }

    func decodeJSON<T: Decodable>(type: T.Type, from: Data?) -> T? {
        let decoder = JSONDecoder()
        guard let data = from else { return nil }

        do {
            let objects = try decoder.decode(type.self, from: data)
            return objects
        } catch let jsonError {
            print("Failed to decode JSON", jsonError)
            return nil
        }
    }
}
