//
//  Service.swift
//  Flickr Image Search
//
//  Created by Haresh Ghatala on 2021/08/30.
//

import Foundation

public enum ServiceError: Error {
    case apiError
    case invalidEndpoint
    case invalidResponse
    case noData
    case decodeError
}

class Service {
    
    public static let shared = Service()
    init() {}
    
    private let urlSession = URLSession.shared
    
    private let baseURL = URL(string: flickrBaseURLString)!
    private let apiKey = flickrApiKey
    private let limit = apiDataLimit
    
    private let jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        jsonDecoder.dateDecodingStrategy = .iso8601
        return jsonDecoder
    }()
    
    /// Enum endpoints
    enum Endpoint: String {
        case rest
    }
    
    /// Query parameters
    enum QueryParams: String {
        case method = "method"
        case apiKey = "api_key"
        case format = "format"
        case noJsonCallBack = "nojsoncallback"
        case searchText = "text"
        case perPageLimit = "per_page"
        case pageOffset = "page"
    }
    
    /// Query parameters fix values
    enum QueryParamValues: String {
        case method = "flickr.photos.search"
        case format = "json"
        case noJsonCallBack = "1"
    }
    
    private func fetchResources<T: Decodable>(url: URL, queryParams: [String: String]? = nil, completion: @escaping (Result<T, ServiceError>) -> Void) {
        
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            completion(.failure(.invalidEndpoint))
            return
        }
        if let queryParams = queryParams?.map({ URLQueryItem(name: $0.key, value: $0.value) }) {
            urlComponents.queryItems = queryParams
        }
        guard let url = urlComponents.url else {
            completion(.failure(.invalidEndpoint))
            return
        }
        
        print("Request Url: \(url.absoluteString)")
        urlSession.dataTask(with: url) { result in
            switch result {
                case .success(let (response, data)):
                    guard let statusCode = (response as? HTTPURLResponse)?.statusCode, 200..<299 ~= statusCode else {
                        completion(.failure(.invalidResponse))
                        return
                    }
                    
                    do {
                        let values = try self.jsonDecoder.decode(T.self, from: data)
                        completion(.success(values))
                    } catch {
                        print(error)
                        completion(.failure(.decodeError))
                    }
                
                case .failure( _):
                    completion(.failure(.apiError))
            }
        }.resume()
    }
    
    
    public func SearchImages(searchText: String, offset: Int = 0, result: @escaping (Result<SearchDetails, ServiceError>) -> Void) {
        let params: [String: String] = [ QueryParams.method.rawValue: QueryParamValues.method.rawValue,
                                         QueryParams.apiKey.rawValue: apiKey,
                                         QueryParams.searchText.rawValue: searchText,
                                         QueryParams.perPageLimit.rawValue: "\(limit)",
                                         QueryParams.pageOffset.rawValue: "\(offset)",
                                         QueryParams.format.rawValue: QueryParamValues.format.rawValue,
                                         QueryParams.noJsonCallBack.rawValue: QueryParamValues.noJsonCallBack.rawValue]
        
        let infoURL = baseURL.appendingPathComponent(Endpoint.rest.rawValue)
        
        fetchResources(url: infoURL, queryParams: params, completion: result)
    }
    
}
