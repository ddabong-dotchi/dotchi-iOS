//
//  HomeRankDotchiImageView.swift
//  DOTCHI
//
//  Created by Jungbin Jung on 9/8/24.
//

import UIKit
import SnapKit

class HomeRankDotchiImageView: UIView {
    
    enum Rank {
        case first
        case other
    }
    
    // MARK: Properties
    
    private let imageView = {
        let imageView = UIImageView(image: .imgDefaultProfile)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var dotchiImageView = {
        let imageView = UIImageView(image: .imgDotchiGreenLogo)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let nicknameLabelView = HomeNicknameView()
    let rankLabel = {
        let label = UILabel()
        label.font = .subSbold
        return label
    }()
    
    // MARK: Initializer
    
    init(rank: Rank) {
        super.init(frame: .zero)
        
        switch rank {
        case .first:
            self.setFirstUI()
        case .other:
            self.setOtherUI()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    
    private func setFirstUI() {
        self.setFirstLayout()
        
        self.imageView.makeRounded(cornerRadius: 30)
        self.imageView.layer.borderWidth = 2
        self.imageView.layer.borderColor = UIColor.dotchiGreen.cgColor
        self.rankLabel.textColor = .dotchiWhite
        self.rankLabel.text = "1위"
    }
    
    private func setOtherUI() {
        self.setOtherLayout()
        
        self.imageView.makeRounded(cornerRadius: 25)
        self.rankLabel.textColor = .dotchiLgray
    }
}

// MARK: - Layout

extension HomeRankDotchiImageView {
    private func setFirstLayout() {
        self.addSubviews([
            imageView,
            dotchiImageView,
            nicknameLabelView,
            rankLabel
        ])
        
        self.imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(self.superview?.snp.width ?? 112)
        }
        
        self.dotchiImageView.snp.makeConstraints { make in
            make.top.centerX.equalToSuperview()
            make.width.height.equalTo(32)
        }
        
        self.nicknameLabelView.snp.makeConstraints { make in
            make.top.equalTo(self.imageView.snp.bottom).offset(17)
            make.centerX.equalToSuperview()
            make.height.equalTo(32)
        }
        
        self.rankLabel.snp.makeConstraints { make in
            make.top.equalTo(self.nicknameLabelView.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
            make.height.equalTo(14)
        }
    }
    
    private func setOtherLayout() {
        self.addSubviews([
            imageView,
            nicknameLabelView,
            rankLabel
        ])
        
        self.imageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(self.superview?.snp.width ?? 82)
        }
        
        self.nicknameLabelView.snp.makeConstraints { make in
            make.top.equalTo(self.imageView.snp.bottom).offset(17)
            make.centerX.equalToSuperview()
            make.height.equalTo(32)
        }
        
        self.rankLabel.snp.makeConstraints { make in
            make.top.equalTo(self.nicknameLabelView.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
            make.height.equalTo(14)
        }
    }
}
