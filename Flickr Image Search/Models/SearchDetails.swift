//
//  SearchDetails.swift
//  Flickr Image Search
//
//  Created by Haresh Ghatala on 2021/08/31.
//

public struct SearchDetails: Codable {
    
    public let photos: PhotoDetails?
    public let stat: String?
    
}

extension SearchDetails: Equatable {
    
    public static func ==(lhs: SearchDetails, rhs: SearchDetails) -> Bool {
        return lhs.photos == rhs.photos &&
            lhs.stat == rhs.stat
    }
    
}
