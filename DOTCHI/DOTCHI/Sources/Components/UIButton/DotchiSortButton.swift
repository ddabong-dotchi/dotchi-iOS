//
//  DotchiSortButton.swift
//  DOTCHI
//
//  Created by Jungbin Jung on 9/29/24.
//


import UIKit.UIButton

final class DotchiSortButton: UIButton {
    
    private enum Text {
        static let latest = "최신순"
        static let hot = "인기순"
    }
    
    // MARK: Initializer
    
    init(sortType: CardSortType) {
        super.init(frame: .zero)
        
        self.sortType = sortType
        self.setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Properties
    
    var sortType: CardSortType = .recent
    
    // MARK: Methods
    
    private func setUI() {
        switch self.sortType {
        case .recent:
            self.setTitle(Text.latest, for: .normal)
        case .popular:
            self.setTitle(Text.hot, for: .normal)
        }
        
        self.tintColor = .none
        self.setTitleColor(.dotchiGreen, for: .selected)
        self.setTitleColor(.dotchiWhite.withAlphaComponent(0.5), for: .normal)
        self.titleLabel?.font = .head2
    }
}
