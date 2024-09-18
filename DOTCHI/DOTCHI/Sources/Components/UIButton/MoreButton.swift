//
//  MoreButton.swift
//  DOTCHI
//
//  Created by Jungbin Jung on 9/18/24.
//

import UIKit
import SnapKit

final class MoreButton: UIButton {
    
    // MARK: Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    
    private func setUI() {
        var configuration = UIButton.Configuration.plain()
        
        let title = "전체보기"
        let font = UIFont.sub
        let color = UIColor.dotchiLgray
        
        let attributedString = NSAttributedString(
            string: title,
            attributes: [
                .font: font,
                .foregroundColor: color
            ]
        )
        
        configuration.attributedTitle = AttributedString(attributedString)
        
        configuration.image = .icnChevronRight
        configuration.imagePlacement = .trailing
        configuration.imagePadding = 4
        
        configuration.contentInsets = .zero
        
        self.configuration = configuration
    }
}
