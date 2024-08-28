//
//  HomeTodayView.swift
//  DOTCHI
//
//  Created by Jungbin Jung on 8/29/24.
//

import UIKit
import SnapKit

final class HomeTodayView: UIView {
    
    private enum Text {
        static let title = "가장 많은 행운을 나눠준\n따봉도치"
    }
    
    // MARK: UIComponents
    
    private let logoView = {
        let imageView = UIImageView(image: .imgLogo)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel = {
        let label = UILabel()
        label.text = Text.title
        label.font = .head
        label.textColor = .dotchiWhite
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    // MARK: Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        if self.superview != nil {
            self.setLayout()
        }
    }
}

// MARK: - Layout

extension HomeTodayView {
    private func setLayout() {
        self.addSubviews([
            logoView,
            titleLabel
        ])
        
        self.logoView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(13)
            make.centerX.equalToSuperview()
            make.width.equalTo(64.75)
            make.height.equalTo(21.53)
        }
        
        self.titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.logoView.snp.bottom).offset(51.47)
            make.centerX.equalToSuperview()
        }
    }
}
