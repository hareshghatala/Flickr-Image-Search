//
//  PhotoDetails.swift
//  Flickr Image Search
//
//  Created by Haresh Ghatala on 2021/08/31.
//

public struct PhotoDetails: Codable {
    
    public let page: Int?
    public let pages: Int?
    public let perpage: Int?
    public let total: Int?
    public let photo: [PhotoItem]?
}

extension PhotoDetails: Equatable {
    
    public static func ==(lhs: PhotoDetails, rhs: PhotoDetails) -> Bool {
        return lhs.page == rhs.page &&
            lhs.pages == rhs.pages &&
            lhs.perpage == rhs.perpage &&
            lhs.total == rhs.total &&
            lhs.photo == rhs.photo
    }
    
}
