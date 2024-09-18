//
//  HomeDiscoverView.swift
//  DOTCHI
//
//  Created by Jungbin Jung on 9/9/24.
//

import UIKit
import SnapKit

final class HomeDiscoverView: UIView {
    
    private enum Text {
        static let title = "따봉도치 둘러보기"
        static let discover = "다양한 따봉도치들을 만나 보세요"
    }
    
    // MARK: Properties
    
    private let titleLabel = {
        let label = UILabel()
        label.font = .head
        label.textColor = .dotchiWhite
        label.text = Text.title
        return label
    }()
    
    private let descriptionLabel = {
        let label = UILabel()
        label.font = .sub
        label.textColor = .dotchiLgray
        label.text = Text.discover
        return label
    }()
    
    private let allButton = MoreButton()
    
    // MARK: Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setUI()
        self.setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    
    private func setUI() {
        self.backgroundColor = .dotchiBlack
    }
}

// MARK: - Layout

extension HomeDiscoverView {
    private func setLayout() {
        self.addSubviews([
            titleLabel,
            descriptionLabel,
            allButton
        ])
        
        self.titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(47)
            make.left.equalToSuperview().inset(28)
        }
        
        self.descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(14)
            make.left.equalToSuperview().inset(28)
        }
        
        self.allButton.snp.makeConstraints { make in
            make.centerY.equalTo(self.titleLabel)
            make.right.equalToSuperview().inset(25)
            make.height.equalTo(14)
        }
    }
}
