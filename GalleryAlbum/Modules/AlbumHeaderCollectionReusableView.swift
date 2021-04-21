/*
 *  AlbumHeaderCollectionReusableView.swift
 *  GalleryAlbum
 *
 *  Created by tuigynbekov on 2/26/21.
 */

import UIKit

class AlbumHeaderCollectionReusableView: UICollectionReusableView {

    @IBOutlet weak var titleLabel: UILabel!

    
    // MARK:- UICollectionReusableView
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let titleLabelY = bounds.midY - titleLabel.frame.height / 2
        titleLabel.frame.origin = CGPoint(x: 16.0, y: titleLabelY)
    }
    
    
    // MARK: - Configure
    func setAlbum(_ album: Album) {
        titleLabel.text = album.name
        titleLabel.sizeToFit()
    }
}
