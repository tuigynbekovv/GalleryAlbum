/*
 *  PhotoCollectionViewCell.swift
 *  GalleryAlbum
 *
 *  Created by tuigynbekov on 2/26/21.
 */

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var photoImageView: UIImageView!
    
    
    // MARK:- UICollectionViewCell
    override func layoutSubviews() {
        super.layoutSubviews()
        
        photoImageView.frame = bounds
    }

    
    // MARK:- Configure
    func setPhoto(_ photo: Photo) {
        photoImageView.image = photo.image
    }
}
