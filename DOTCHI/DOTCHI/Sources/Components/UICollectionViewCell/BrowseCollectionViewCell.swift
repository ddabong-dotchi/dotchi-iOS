//
//  BrowseCollectionViewCell.swift
//  DOTCHI
//
//  Created by Jungbin Jung on 9/29/24.
//


import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class BrowseCollectionViewCell: UICollectionViewCell {
    
    // MARK: UIComponents
    
    private let cardBackgroundView: UIView = UIView()
    private let cardFrontView: CardFrontView = CardFrontView()
    private let cardBackView: CardBackView = CardBackView()
    
    private let buttonStackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    let shareButton: DotchiCircleButton = DotchiCircleButton(type: .share)
    let commentButton: DotchiCircleButton = DotchiCircleButton(type: .comment)
    
    
    // MARK: Properties
    
    private let disposeBag: DisposeBag = DisposeBag()
    
    // MARK: Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setUI()
        self.setLayout()
        self.setTapGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    
    private func setUI() {
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        self.buttonStackView.addArrangedSubviews([shareButton, commentButton])
        self.cardBackView.isHidden = true
    }
    
    func setData(data: CardEntity) {
        self.cardFrontView.setData(frontData: data.front, userData: data.user)
        self.cardBackView.setData(backData: data.back, userData: data.user)
    }
    
    private func setTapGesture() {
        let tapGesture = UITapGestureRecognizer()
        tapGesture.rx.event
            .bind { [weak self] _ in
                self?.flipCard()
            }
            .disposed(by: self.disposeBag)
        
        self.cardBackgroundView.addGestureRecognizer(tapGesture)
    }
    
    private func flipCard() {
        let transitionOptions: UIView.AnimationOptions = [.transitionFlipFromRight, .showHideTransitionViews]
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if !self.cardFrontView.isHidden {
                UIView.transition(from: self.cardFrontView, to: self.cardBackView, duration: 0.5, options: transitionOptions)
            } else {
                UIView.transition(from: self.cardBackView, to: self.cardFrontView, duration: 0.5, options: transitionOptions)
            }
        }
    }
    
    func setCardFlipDefault() {
        self.cardFrontView.isHidden = false
        self.cardBackView.isHidden = true
    }
}

// MARK: - Layout

extension BrowseCollectionViewCell {
    private func setLayout() {
        self.contentView.addSubviews([cardBackgroundView, buttonStackView])
        self.cardBackgroundView.addSubviews([cardBackView, cardFrontView])
        
        self.cardBackgroundView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalTo((270 * 0.95).adjustedH)
            make.height.equalTo((400 * 0.95).adjustedH)
        }
        
        self.cardFrontView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.cardBackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(self.cardFrontView.snp.bottom).offset(27.adjustedH)
            make.centerX.equalToSuperview()
            make.width.equalTo(56.adjustedH * 2 + 16)
            make.height.equalTo(56.adjustedH)
        }
    }
}
