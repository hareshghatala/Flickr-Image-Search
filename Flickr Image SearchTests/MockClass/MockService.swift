//
//  MockService.swift
//  Flickr Image SearchTests
//
//  Created by Haresh Ghatala on 2021/08/31.
//

import XCTest
@testable import Flickr_Image_Search

class MockService: Service {
    
    public static let mockShared = MockService()
    override init() {
        super.init()
    }
    
    var isfailur: Bool = false
    var mockServiceError: ServiceError?
    var mockResponse: SearchDetails?
    
    override func SearchImages(searchText: String, offset: Int = 0, result: @escaping (Result<SearchDetails, ServiceError>) -> Void) {
        if isfailur {
            result(.failure(mockServiceError!))
        } else {
            result(.success(mockResponse!))
        }
    }
    
}
