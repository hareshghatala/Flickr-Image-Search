//
//  FlickrImageCollectionViewCell.swift
//  Flickr Image Search
//
//  Created by Haresh Ghatala on 2021/08/30.
//

import UIKit

class FlickrImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func prepareForReuse() {
        self.backgroundColor = .clear
        imageView.image = UIImage()
    }
    
    func setupBackgroundColor(index: Int) {
        switch (index % 4) {
        case 0, 3:
            self.backgroundColor = UIColor(named: "Flickr-Blue")!
        default:
            self.backgroundColor = UIColor(named: "Flickr-Pink")!
        }
    }
    
}
