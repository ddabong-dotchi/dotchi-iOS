//
//  DotchiSmallCardCollectionViewCell.swift
//  DOTCHI
//
//  Created by Jungbin Jung on 9/21/24.
//

import UIKit
import SnapKit

final class DotchiSmallCardCollectionViewCell: UICollectionViewCell {
    
    // MARK: UIComponents
    
    private let frameImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let dotchiImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.makeRounded(cornerRadius: 16)
        return imageView
    }()
    
    private let dotchiNameLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .dotchiName2
        label.textAlignment = .center
        return label
    }()
    
    // MARK: Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    
    private func setFrameImageView(luckyType: LuckyType) {
        switch luckyType {
        case .health:
            self.frameImageView.image = .imgHealthFrontSmall
        case .lucky:
            self.frameImageView.image = .imgLuckyFrontSmall
        case .money:
            self.frameImageView.image = .imgMoneyFrontSmall
        case .love:
            self.frameImageView.image = .imgLoveFrontSmall
        }
    }
    
    func setData(frontData: CardFrontEntity) {
        self.setFrameImageView(luckyType: frontData.luckyType)
        self.dotchiNameLabel.textColor = frontData.luckyType.uiColorDeep()
        self.dotchiImageView.setImageUrl(frontData.imageUrl)
        self.dotchiNameLabel.text = frontData.dotchiName
    }
}

// MARK: - Layout

extension DotchiSmallCardCollectionViewCell {
    private func setLayout() {
        self.addSubviews([
            dotchiImageView,
            frameImageView,
            dotchiNameLabel
        ])
        
        self.frameImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.dotchiImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().multipliedBy((200.0 - 16.0) / 200.0)
            make.width.equalToSuperview().multipliedBy(210.0 / 270.0)
            make.height.equalTo(self.dotchiImageView.snp.width)
        }
        
        self.dotchiNameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview().multipliedBy(1.75)
            make.horizontalEdges.equalToSuperview().inset(30)
            make.centerX.equalToSuperview()
        }
    }
}

