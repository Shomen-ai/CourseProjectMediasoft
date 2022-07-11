import Foundation

class APIService {
    // MARK: - Search Photos
    func requestForPhotos(searchString: String, completion: @escaping (Data?, Error?) -> Void) {
        let parameters = self.prepareParametersForPhotos(searchString: searchString)
        let url = self.urlForPhotos(params: parameters)
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = prepareHeaders()
        request.httpMethod = "get"
        let task = createDataTask(from: request, completion: completion)
        task.resume()
    }

    private func prepareHeaders() -> [String: String]? {
        var headers = [String: String]()
        headers["Authorization"] = "Client-ID ku8gG_AOit1xEuti_CIMiPBN9CRUZx5rEnq4Fp_Qn1s" // запихнуть в KeyChain
        return headers
    }

    private func prepareParametersForPhotos(searchString: String?) -> [String: String] {
        var parameters  = [String: String]()
        parameters["query"] = searchString
        parameters["page"] = String(1)
        parameters["per_page"] = String(30)
        return parameters
    }

    private func urlForPhotos(params: [String: String]) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.unsplash.com"
        components.path = "/search/photos"
        components.queryItems = params.map { URLQueryItem(name: $0, value: $1) }
        return components.url!
    }
    // MARK: - PreAuth user
    private func prepareParametersForPreAuth() -> [String: String] {
        var parameters  = [String: String]()
        parameters["client_id"] = "ku8gG_AOit1xEuti_CIMiPBN9CRUZx5rEnq4Fp_Qn1s" // запихнуть в KeyChain
        parameters["redirect_uri"] = "urn:ietf:wg:oauth:2.0:oob"
        parameters["response_type"] = "code"
        parameters["scope"] = "public+read_user+write_user+write_likes"
        return parameters
    }

    private func urlForPreAuth(params: [String: String]) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "unsplash.com"
        components.path = "/oauth/authorize"
        components.queryItems = params.map { URLQueryItem(name: $0, value: $1) }
        return components.url!
    }

    func prepareUrlForAuth() -> URL {
        let parameters = self.prepareParametersForPreAuth()
        let url = self.urlForPreAuth(params: parameters)
        return url
    }

    // MARK: - AuthUser with token

    private func prepareParametersForTokenAuth(code: String) -> [String: String] {
        var parameters  = [String: String]()
        parameters["client_id"] = "ku8gG_AOit1xEuti_CIMiPBN9CRUZx5rEnq4Fp_Qn1s" // запихнуть в KeyChain
        parameters["client_secret"] = "j9XTjYoyxBv_J9djpeIZORMpuj23ZKTOirxRHSjjolg" // запихнуть в KeyChain
        parameters["redirect_uri"] = "urn:ietf:wg:oauth:2.0:oob"
        parameters["code"] = code
        parameters["grant_type"] = "authorization_code"
        return parameters
    }

    private func urlForTokenAuth(params: [String: String]) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "unsplash.com"
        components.path = "/oauth/token"
        components.queryItems = params.map { URLQueryItem(name: $0, value: $1) }
        return components.url!
    }

    func requestUrlTokenAuth(code: String, completion: @escaping (Data?, Error?) -> Void) -> URL {
        let parameters = self.prepareParametersForTokenAuth(code: code)
        let url = self.urlForTokenAuth(params: parameters)
        var request = URLRequest(url: url)
        request.httpMethod = "post"
        let task = createDataTask(from: request, completion: completion)
        task.resume()
        return url
    }

    private func createDataTask(from request: URLRequest,
                                completion: @escaping (Data?, Error?) -> Void) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: request) { data, _, error in
            DispatchQueue.main.async {
                completion(data, error)
            }
        }
    }
}
