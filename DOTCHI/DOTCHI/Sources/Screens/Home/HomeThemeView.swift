//
//  HomeThemeView.swift
//  DOTCHI
//
//  Created by Jungbin Jung on 9/23/24.
//

import UIKit
import SnapKit

final class HomeThemeView: UIView {
    
    private enum Text {
        static let title = "테마별 따봉도치.zip"
        static let description = "나에게 필요한 행운 테마를 선택하세요!"
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
        label.text = Text.description
        return label
    }()
    
    private let allButton = MoreButton()
    private let luckyButton = HomeThemeButtonView(luckyType: .lucky)
    private let loveButton = HomeThemeButtonView(luckyType: .love)
    private let healthButton = HomeThemeButtonView(luckyType: .health)
    private let moneyButton = HomeThemeButtonView(luckyType: .money)
    
    private let horStackView1: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 13
        return stackView
    }()
    
    private let horStackView2: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 13
        return stackView
    }()
    
    private let verStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 13
        return stackView
    }()
    
    // MARK: Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        if superview != nil {
            self.setLayout()
        }
    }
    
    private func setUI() {
        self.backgroundColor = .dotchiBlack
    }
}

// MARK: - Layout

extension HomeThemeView {
    private func setLayout() {
        self.horStackView1.addArrangedSubviews([
            luckyButton,
            loveButton
        ])
        
        self.horStackView2.addArrangedSubviews([
            healthButton,
            moneyButton
        ])
        
        self.verStackView.addArrangedSubviews([
            horStackView1,
            horStackView2
        ])
        
        self.addSubviews([
            titleLabel,
            descriptionLabel,
            allButton,
            verStackView
        ])
        
        self.titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(47)
            make.left.equalToSuperview().inset(28)
            make.height.equalTo(24)
        }
        
        self.descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(14)
            make.left.equalToSuperview().inset(28)
            make.height.equalTo(14)
        }
        
        self.allButton.snp.makeConstraints { make in
            make.centerY.equalTo(self.titleLabel)
            make.right.equalToSuperview().inset(25)
            make.height.equalTo(14)
        }
        
        self.horStackView1.snp.makeConstraints { make in
            make.height.equalTo((self.frame.width - 28 * 2 - 13) / 2)
        }
        
        self.horStackView2.snp.makeConstraints { make in
            make.height.equalTo((self.frame.width - 28 * 2 - 13) / 2)
        }
        
        self.verStackView.snp.makeConstraints { make in
            make.top.equalTo(self.descriptionLabel.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(28)
            make.height.equalTo(self.frame.width - 28 * 2)
            make.bottom.equalToSuperview().inset(100)
        }
    }
}
