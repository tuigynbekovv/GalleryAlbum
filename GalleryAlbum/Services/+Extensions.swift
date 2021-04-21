/*
 *  Extension.swift
 *  GalleryAlbum
 *
 *  Created by tuigynbekov on 2/26/21.
 */

import UIKit

extension UICollectionViewCell {
    
    static var cellIdentifier: String {
        return String(describing: self)
    }
    
}

extension UICollectionView {
    
    func register<Cell: UICollectionViewCell>(cellType: Cell.Type,
                                              nib: Bool = true) {
        
        let reuseIdentifier = String(describing: cellType)
        
        if nib {
            let nib = UINib(nibName: reuseIdentifier, bundle: nil)
            register(nib, forCellWithReuseIdentifier: reuseIdentifier)
        } else {
            register(cellType, forCellWithReuseIdentifier: reuseIdentifier)
        }
    }
    
    func register<View: UICollectionReusableView>(viewType: View.Type,
                                                  kind: String,
                                                  nib: Bool = true) {
        
        let reuseIdentifier = String(describing: viewType)
        
        if nib {
            let nib = UINib(nibName: reuseIdentifier, bundle: nil)
            register(nib,
                     forSupplementaryViewOfKind: kind,
                     withReuseIdentifier: reuseIdentifier)
        } else {
            register(viewType,
                     forSupplementaryViewOfKind: kind,
                     withReuseIdentifier: reuseIdentifier)
        }
    }
    
    func dequeueCell<Cell: UICollectionViewCell>(of cellType: Cell.Type,
                                                 for indexPath: IndexPath) -> Cell {
        
        return dequeueReusableCell(withReuseIdentifier: String(describing: cellType),
                                   for: indexPath) as! Cell
    }
    
    func dequeueSupplementaryView<View: UICollectionReusableView>(of viewType: View.Type, kind: String, for indexPath: IndexPath) -> View {
        
        return dequeueReusableSupplementaryView(ofKind: kind,
                                                withReuseIdentifier: String(describing: viewType),
                                                for: indexPath) as! View
    }
    
}
