//
//  CardFrontView.swift
//  DOTCHI
//
//  Created by Jungbin Jung on 9/29/24.
//


import UIKit
import SnapKit

final class CardFrontView: UIView {
    
    // MARK: UIComponents
    
    private let frameImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let dotchiImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.makeRounded(cornerRadius: 16)
        return imageView
    }()
    
    private let cardProfileView: CardProfileView = {
        let view = CardProfileView()
        view.makeRounded(cornerRadius: 34 / 2)
        return view
    }()
    
    private let dotchiNameLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .dotchiName
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
            self.frameImageView.image = .imgHealthFront
        case .lucky:
            self.frameImageView.image = .imgLuckyFront
        case .money:
            self.frameImageView.image = .imgMoneyFront
        case .love:
            self.frameImageView.image = .imgLoveFront
        }
    }
    
    func setData(frontData: CardFrontEntity, userData: CardUserEntity) {
        self.setFrameImageView(luckyType: frontData.luckyType)
        self.dotchiNameLabel.textColor = frontData.luckyType.uiColorDeep()
        self.dotchiImageView.setImageUrl(frontData.imageUrl)
        self.dotchiNameLabel.text = frontData.dotchiName
        self.cardProfileView.setData(data: userData, luckyType: frontData.luckyType, headType: .front)
    }
    
    func setData(makeDotchiData: MakeDotchiEntity) {
        self.setFrameImageView(luckyType: makeDotchiData.luckyType)
        self.dotchiNameLabel.textColor = makeDotchiData.luckyType.uiColorDeep()
        self.dotchiImageView.image = makeDotchiData.image
        self.dotchiNameLabel.text = makeDotchiData.dotchiName
        self.cardProfileView.setData(
            data: .init(
                userId: 0,
                profileImageUrl: UserInfo.shared.profileImageUrl,
                username: UserInfo.shared.nickname,
                nickname: UserInfo.shared.nickname
            ),
            luckyType: makeDotchiData.luckyType,
            headType: .front
        )
    }
}

// MARK: - Layout

extension CardFrontView {
    private func setLayout() {
        self.addSubviews([dotchiImageView, frameImageView, cardProfileView, dotchiNameLabel])
        
        self.frameImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.dotchiImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().multipliedBy((200.0 - 16.0) / 200.0)
            make.width.equalToSuperview().multipliedBy(210.0 / 270.0)
            make.height.equalTo(self.dotchiImageView.snp.width)
        }
        
        self.cardProfileView.snp.makeConstraints { make in
            make.centerY.equalToSuperview().multipliedBy(0.245)
            make.centerX.equalToSuperview()
            make.height.equalTo(34)
        }
        
        self.dotchiNameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview().multipliedBy(1.75)
            make.horizontalEdges.equalToSuperview().inset(30)
            make.centerX.equalToSuperview()
        }
    }
}
