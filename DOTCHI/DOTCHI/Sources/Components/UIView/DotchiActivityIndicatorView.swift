//
//  DotchiActivityIndicatorView.swift
//  DOTCHI
//
//  Created by Jungbin Jung on 10/20/24.
//

import UIKit

final class DotchiActivityIndicatorView: UIActivityIndicatorView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        self.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        
        self.color = .dotchiLgray
        self.hidesWhenStopped = true
        self.style = .medium
        self.stopAnimating()
    }
}
