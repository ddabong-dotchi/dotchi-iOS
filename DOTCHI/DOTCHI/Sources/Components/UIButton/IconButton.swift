//
//  IconButton.swift
//  DOTCHI
//
//  Created by Jungbin on 7/31/24.
//

import UIKit

class IconButton: UIButton {
    
    // MARK: Initializer
    
    init(icon: UIImage) {
        super.init(frame: .zero)
        
        self.setIconImage(icon: icon)
    }
    
    init(normalIcon: UIImage, selectedIcon: UIImage) {
        super.init(frame: .zero)
        
        self.setSelectableIconImage(normalIcon: normalIcon, selectedIcon: selectedIcon)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    
    private func setIconImage(icon: UIImage) {
        self.setImage(icon, for: .normal)
    }
    
    private func setSelectableIconImage(normalIcon: UIImage, selectedIcon: UIImage) {
        self.setImage(normalIcon, for: .normal)
        self.setImage(selectedIcon, for: .selected)
    }
}
