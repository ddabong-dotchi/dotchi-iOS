//
//  HomeTodayView.swift
//  DOTCHI
//
//  Created by Jungbin Jung on 8/29/24.
//

import UIKit
import SnapKit
import Lottie

final class HomeTodayView: UIView {
    
    private enum Text {
        static let title = "가장 많은 행운을\n나눠 준 오늘의 따봉도치"
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
    
    private let dateStackView = {
        let stackView = UIStackView()
        stackView.spacing = 7
        stackView.alignment = .center
        return stackView
    }()
    
    private let graphImageView = {
        let imageView = UIImageView(image: .imgGraph)
        return imageView
    }()
    
    private let dateLabel = {
        let label = UILabel()
        label.font = .sub
        label.textColor = .dotchiWhite
        return label
    }()
    
    private var particleAnimationView = {
        let view: LottieAnimationView = LottieAnimationView(name: "pung")
        view.loopMode = .playOnce
        view.animationSpeed = 0.8
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private var firstDotchiImage = HomeRankDotchiImageView(rank: .first)
    private var secondDotchiImage = HomeRankDotchiImageView(rank: .other)
    private var thirdDotchiImage = HomeRankDotchiImageView(rank: .other)
    
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
            self.setUI()
        }
    }
    
    // MARK: Methods
    
    private func setUI() {
        self.dateLabel.text = self.generateDateText()
        self.setParticleAnimationView()
        
        self.secondDotchiImage.rankLabel.text = "2위"
        self.thirdDotchiImage.rankLabel.text = "3위"
        
        self.firstDotchiImage.nicknameLabelView.setNickname(nickname: "일곱글자따봉닉")
        self.secondDotchiImage.nicknameLabelView.setNickname(nickname: "따봉도치")
        self.thirdDotchiImage.nicknameLabelView.setNickname(nickname: "따봉")
    }
    
    private func setParticleAnimationView() {
        self.particleAnimationView.play()
    }
    
    private func generateDateText() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 M월 d일"

        let currentDate = Date()
        let formattedDate = dateFormatter.string(from: currentDate)

        return "\(formattedDate) 기준"
    }
}

// MARK: - Layout

extension HomeTodayView {
    private func setLayout() {
        self.dateStackView.addArrangedSubviews([
            graphImageView,
            dateLabel
        ])
        
        self.addSubviews([
            logoView,
            titleLabel,
            dateStackView,
            particleAnimationView,
            firstDotchiImage,
            secondDotchiImage,
            thirdDotchiImage
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
        
        self.dateStackView.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(14)
        }
        
        self.particleAnimationView.snp.makeConstraints { make in
            make.top.equalTo(self.logoView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(200)
        }
        
        self.firstDotchiImage.snp.makeConstraints { make in
            make.top.equalTo(self.dateStackView.snp.bottom).offset(36)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(112.0/393.0)
            make.height.equalTo(self.firstDotchiImage.snp.width).multipliedBy(204.0/112.0)
        }
        
        self.secondDotchiImage.snp.makeConstraints { make in
            make.bottom.equalTo(self.firstDotchiImage)
            make.right.equalTo(self.firstDotchiImage.snp.left).offset(-10)
            make.height.equalTo(self.firstDotchiImage.snp.height).multipliedBy(157.0/204.0)
            make.width.equalTo(self.firstDotchiImage.snp.width).multipliedBy(82.0/112.0)
        }
        
        self.thirdDotchiImage.snp.makeConstraints { make in
            make.bottom.equalTo(self.firstDotchiImage)
            make.left.equalTo(self.firstDotchiImage.snp.right).offset(10)
            make.height.equalTo(self.firstDotchiImage.snp.height).multipliedBy(157.0/204.0)
            make.width.equalTo(self.firstDotchiImage.snp.width).multipliedBy(82.0/112.0)
        }
    }
}
