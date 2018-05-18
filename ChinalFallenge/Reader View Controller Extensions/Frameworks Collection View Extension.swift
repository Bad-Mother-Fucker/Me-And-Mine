//
//  Frameworks Collection View Extension.swift
//  ChinalFallenge
//
//  Created by Simone Fiorentino on 17/05/2018.
//  Copyright © 2018 Simone Fiorentino. All rights reserved.
//

import UIKit

extension ReaderViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.nameFrameworks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCell", for: indexPath) as! frameworksCell
        
        cell.frameworksNameButton.setTitleColor(UIColor.white, for: .normal)
        cell.frameworksNameButton.setTitle(self.nameFrameworks[indexPath.row], for: .normal)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
        switch indexPath.row {
        case 0:
            break
        case 1:
            break
        case 2:
            //self.flagOnSpeech = !self.flagOnSpeech ??????????????????????????????? TIAGO EXPLAIN ME PLEASE
            //I have to use Tiago' code instead mine.. 😭😭😭 I need to understand
            self.photoButton.setBackgroundImage(#imageLiteral(resourceName: "cameraWithMicrophoneButton"), for: .normal)
            self.photoButton.isHidden = false
        case 3:
            break
        default:
            break
        }
    }
    
    var collectionViewMargin: UIEdgeInsets{
        
        let left: CGFloat = self.cameraView.frame.width/2 - 64
        let right: CGFloat = self.cameraView.frame.width/2 - 64
        
        return UIEdgeInsets(top: 8, left: left, bottom: 16, right: right)
    }

    var collectionViewSpacing: (betweenRows: CGFloat, betweenSections: CGFloat) {
        return (CGFloat(5), CGFloat(0))
    }

    //  Size of itens
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 128, height: 44)
    }

    //  Margins to apply to content in the specified section
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return collectionViewMargin
    }

    // Space between seccessive rows or columns of a section
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return collectionViewSpacing.betweenRows
    }
    
}





