//
//  InstagramShareView.swift
//  DOTCHI
//
//  Created by Jungbin Jung on 9/29/24.
//

import UIKit
import SnapKit

final class InstagramShareView: UIView {
    
    // MARK: UIComponents
    
    private let cardFrontView: CardFrontView = CardFrontView()
    private let cardBackView: CardBackView = CardBackView()
    private let logoView: UIImageView = UIImageView(image: .imgLogo)
    
    // MARK: Properties
    
    private var card: CardEntity?
    
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
        self.makeRounded(cornerRadius: 18)
        self.backgroundColor = .dotchiBlack
    }
    
    func setData(data: CardEntity) {
        self.cardFrontView.setData(frontData: data.front, userData: data.user)
        self.cardBackView.setData(backData: data.back, userData: data.user)
    }
}

// MARK: - Layout

extension InstagramShareView {
    private func setLayout() {
        self.addSubviews([cardFrontView, cardBackView, logoView])
        
        self.cardFrontView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(12)
            make.width.equalToSuperview().multipliedBy(0.470383)
        }
        
        self.cardBackView.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(12)
            make.left.equalTo(self.cardFrontView.snp.right).offset(8)
            make.width.equalToSuperview().multipliedBy(0.470383)
            make.bottom.equalTo(self.cardFrontView)
        }
        
        self.logoView.snp.makeConstraints { make in
            make.top.equalTo(self.cardBackView.snp.bottom).offset(4)
            make.right.equalTo(self.cardBackView).inset(2)
            make.width.equalToSuperview().multipliedBy(0.2)
            make.height.equalTo(self.logoView.snp.width).multipliedBy(23.94 / 72)
            make.bottom.equalToSuperview().inset(12)
        }
    }
}
