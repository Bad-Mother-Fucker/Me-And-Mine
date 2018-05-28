//
//  Text View Extension.swift
//  ChinalFallenge
//
//  Created by Simone Fiorentino on 14/05/2018.
//  Copyright © 2018 Simone Fiorentino. All rights reserved.
//

import UIKit


// ############### HANDLE TEXT VIEW ###############

extension ReaderViewController: UITextViewDelegate {
    
    func moveTextView(textView: UITextView, moveDistance: Int, up: Bool) {
        let moveDuration = 0.3
        let movement: CGFloat = CGFloat(up ? moveDistance : -moveDistance)
        
        UIView.beginAnimations("animatedTextView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(moveDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        moveTextView(textView: textView, moveDistance: -250, up: true)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        moveTextView(textView: textView, moveDistance: -250, up: false)
    }
}
