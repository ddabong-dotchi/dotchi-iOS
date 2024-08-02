//
//  UITapGestureRecognizer+.swift
//  DOTCHI
//
//  Created by Jungbin on 7/31/24.
//

import UIKit

extension UITapGestureRecognizer {
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        guard let attributedText = label.attributedText else { return false }
        
        // Create instances for the layout manager and text container
        let textStorage = NSTextStorage(attributedString: attributedText)
        let layoutManager = NSLayoutManager()
        textStorage.addLayoutManager(layoutManager)
        
        // Adjust text container to match the label's bounds
        let textContainer = NSTextContainer(size: label.bounds.size)
        textContainer.lineFragmentPadding = 0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        layoutManager.addTextContainer(textContainer)
        
        // Get the location of the touch in the label's coordinates
        let locationOfTouchInLabel = self.location(in: label)
        
        // Find the character index of the tapped character
        let indexOfCharacter = layoutManager.characterIndex(
            for: locationOfTouchInLabel,
            in: textContainer,
            fractionOfDistanceBetweenInsertionPoints: nil
        )
        
        // Make sure the tapped character index is within the specified range
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
}
