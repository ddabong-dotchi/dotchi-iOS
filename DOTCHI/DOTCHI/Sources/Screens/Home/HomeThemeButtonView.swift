//
//  HomeThemeButtonView.swift
//  DOTCHI
//
//  Created by Jungbin Jung on 9/23/24.
//

import UIKit
import SnapKit

final class HomeThemeButtonView: UIView {
    
    // MARK: Properties
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .dotchiWhite
        label.font = .head2
        label.textAlignment = .left
        label.numberOfLines = 2
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .dotchiWhite50
        label.font = .sub
        label.textAlignment = .left
        return label
    }()
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let rightArrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icnChevronRightThemeButton")
        return imageView
    }()
    
    let button: UIButton = {
        let button = UIButton(type: .system)
        return button
    }()
    
    // MARK: Properties
    
    private var luckyType: LuckyType = .lucky
    
    // MARK: Initializer
    
    init(luckyType: LuckyType) {
        super.init(frame: .zero)
        
        self.luckyType = luckyType
        self.setUI(luckyType: luckyType)
        self.setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        if superview != nil {
            self.fetchData(luckyType: self.luckyType)
        }
    }
    
    private func setUI(luckyType: LuckyType) {
        self.backgroundColor = .dotchiBlack80
        self.titleLabel.text = "\(luckyType.name())을\n나누는 도치들"
        self.titleLabel.setColor(to: "\(luckyType.name())", with: luckyType.uiColorNormal())
        self.backgroundImageView.image = UIImage(named: "imgThemeButton\(luckyType.rawValue)")
        self.makeRounded(cornerRadius: 12)
    }
}

// MARK: - Network

extension HomeThemeButtonView {
    private func fetchData(luckyType: LuckyType) {
        CardService.shared.getCardLastTime(luckyType: luckyType) { result in
            if case .success(let time) = result {
                self.timeLabel.text = time as? String
            }
            else {
                self.timeLabel.text = nil
            }
        }
    }
}

// MARK: - Layout

extension HomeThemeButtonView {
    private func setLayout() {
        self.addSubviews([
            backgroundImageView,
            titleLabel,
            rightArrowImageView,
            timeLabel,
            button
        ])
        
        self.backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.titleLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview().inset(24.adjustedW)
        }
        
        self.timeLabel.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(12)
            make.left.equalTo(self.titleLabel)
        }
        
        self.rightArrowImageView.snp.makeConstraints { make in
            make.width.height.equalTo(16.adjustedW)
            make.left.equalTo(self.titleLabel.snp.right).offset(2)
            make.bottom.equalTo(self.titleLabel.snp.bottom).inset(2)
        }
        
        self.button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

