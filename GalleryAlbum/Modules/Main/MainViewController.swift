/*
 *  MainViewController.swift
 *  GalleryAlbum
 *
 *  Created by tuigynbekov on 2/26/21.
 */

import UIKit

class MainViewController: UIViewController {
    // MARK:- Properties
    var albums: [Album] = []
    lazy var changeLayoutButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("change", for: .normal)
        btn.addTarget(self, action: #selector(changeLayoutButtonPressed(_:)), for: .touchUpInside)
        btn.backgroundColor = .orange
        return btn
    }()
    lazy var galleryCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        view.register(cellType: PhotoCollectionViewCell.self)
        view.register(viewType: AlbumHeaderCollectionReusableView.self,
                                       kind: UICollectionView.elementKindSectionHeader)
    
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = .white
        return view
    }()
    
    
    // MARK:- View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        albums = AlbumProvider().albums()
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture(gesture:)))
        galleryCollectionView.addGestureRecognizer(longPressGesture)
        
        setupViews()
    }
    
    
    // MARK:- Autolayout
    func setupViews() -> Void {
        view.addSubview(galleryCollectionView)
        view.addSubview(changeLayoutButton)
        
        galleryCollectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        changeLayoutButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(100)
            make.right.equalToSuperview().offset(-10)
            make.width.equalTo(100)
            make.height.equalTo(50)
        }
    }
    
    
    // MARK: - Actions
    @objc func changeLayoutButtonPressed(_ sender: UIButton) {
        let newLayout: UICollectionViewLayout
        
        if galleryCollectionView.collectionViewLayout is UICollectionViewFlowLayout {
            newLayout = SFFocusViewLayout()
        } else {
            newLayout = UICollectionViewFlowLayout()
        }
        
        galleryCollectionView.setCollectionViewLayout(newLayout, animated: true)
    }
    @objc func handleLongPressGesture(gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            guard let selectedIndexPath = galleryCollectionView.indexPathForItem(at: gesture.location(in: galleryCollectionView)) else {
                break
            }
            galleryCollectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
        case .changed:
            if let view = gesture.view {
                galleryCollectionView.updateInteractiveMovementTargetPosition(gesture.location(in: view))
            }
        case .ended:
            galleryCollectionView.endInteractiveMovement()
        default:
            galleryCollectionView.cancelInteractiveMovement()
        }
    }
}


// MARK: - UICollectionViewDataSource
extension MainViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return albums.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albums[section].photos.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = galleryCollectionView.dequeueCell(of: PhotoCollectionViewCell.self, for: indexPath)
        cell.setPhoto(albums[indexPath.section].photos[indexPath.item])
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView,viewForSupplementaryElementOfKind kind: String,at indexPath: IndexPath) -> UICollectionReusableView {
        
        let view = galleryCollectionView.dequeueSupplementaryView(of: AlbumHeaderCollectionReusableView.self, kind: kind, for: indexPath)
        
        view.setAlbum(albums[indexPath.section])
        
        return view
    }
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    func collectionView(_ collectionView: UICollectionView,moveItemAt sourceIndexPath: IndexPath,to destinationIndexPath: IndexPath) {
        let movedPhoto = albums[sourceIndexPath.section].photos.remove(at: sourceIndexPath.item)
        albums[destinationIndexPath.section].photos.insert(movedPhoto, at: destinationIndexPath.item)
    }
}


// MARK: - UICollectionViewDelegate
extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        galleryCollectionView.deselectItem(at: indexPath, animated: true)
    }
}


// MARK: - UICollectionViewDelegateFlowLayout
extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let itemWidth = (UIScreen.main.bounds.width - 3 * Const.itemSpacing) / 2
        
        if indexPath.item % 3 == 0 {
            return CGSize(width: itemWidth * 2 + Const.itemSpacing, height: itemWidth)
        } else {
            return CGSize(width: itemWidth, height: itemWidth)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: Const.itemSpacing,
                            left: Const.itemSpacing,
                            bottom: Const.itemSpacing * 2,
                            right: Const.itemSpacing)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Const.itemSpacing
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Const.itemSpacing
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: UIScreen.main.bounds.width, height: Const.headerHeight)
    }
}
