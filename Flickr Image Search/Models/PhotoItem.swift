//
//  PhotoItem.swift
//  Flickr Image Search
//
//  Created by Haresh Ghatala on 2021/08/31.
//

public struct PhotoItem: Codable {
    
    public let id: String?
    public let owner: String?
    public let secret: String?
    public let server: String?
    public let farm: Int?
    public let title: String?
    public let ispublic: Int?
    public let isfriend: Int?
    public let isfamily: Int?
    
    func generateImageURL() -> String? {
        guard let farm = farm,
              let server = server,
              let id = id,
              let secret = secret else {
            return nil
        }
        
        return "https://farm\(farm).static.flickr.com/\(server)/\(id)_\(secret).jpg"
    }
}

extension PhotoItem: Equatable {
    
    public static func ==(lhs: PhotoItem, rhs: PhotoItem) -> Bool {
        return lhs.id == rhs.id &&
            lhs.owner == rhs.owner &&
            lhs.secret == rhs.secret &&
            lhs.server == rhs.server &&
            lhs.farm == rhs.farm &&
            lhs.title == rhs.title &&
            lhs.ispublic == rhs.ispublic &&
            lhs.isfriend == rhs.isfriend &&
            lhs.isfamily == rhs.isfamily
    }
    
}
