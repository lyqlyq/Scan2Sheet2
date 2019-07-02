////
////  UICollectionViewTemplate.swift
////  MusicRadio
////
////  Created by Admin on 10/18/18.
////  Copyright © 2018 HCM. All rights reserved.
////
//
//import UIKit
//
//class FeaturesViewController: UIViewController {
//
//    let spacingCells = CGFloat(10.0)
//    let widthCells = Utils.isIPad() ? (Device.SCREEN_WIDTH - 10 * 4) / 3 : (Device.SCREEN_WIDTH - 10 * 3) / 2
//    let heightCells = Utils.isIPad() ? (Device.SCREEN_WIDTH - 10 * 4) / 3 : (Device.SCREEN_WIDTH - 10 * 3) / 2
//
//    @IBOutlet weak var collectionView: UICollectionView!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        collectionView.register(UINib(nibName: HeaderGridView.className, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderGridView.className)
//        collectionView.register(UINib(nibName: FeaturesCell.className, bundle: nil), forCellWithReuseIdentifier: FeaturesCell.className)
//        collectionView.delegate = self
//        collectionView.dataSource = self
//    }
//}
//
//extension FeaturesViewController: UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeaturesCell.className, for: indexPath)  as! FeaturesCell
//
//        return cell
//    }
//    
//    // optional
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
//        
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
//        
//    }
//    
//    func indexTitles(for collectionView: UICollectionView) -> [String]? {
//        
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, indexPathForIndexTitle title: String, at index: Int) -> IndexPath {
//        
//    }
//}
//
//extension FeaturesViewController: UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        
//    }
//}
//
//extension FeaturesViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: widthCells, height: heightCells)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return spacingCells
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return spacingCells
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: spacingCells, left: spacingCells, bottom: spacingCells, right: spacingCells)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
//
//    }
//}
