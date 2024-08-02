//
//  TermsLabel.swift
//  DOTCHI
//
//  Created by Jungbin on 7/31/24.
//

import UIKit
import SnapKit
import RxGesture
import RxSwift
import RxCocoa

final class TermsLabel: UILabel {
    
    // MARK: - Properties
    
    private let disposeBag = DisposeBag()
    var onTermsTap: (() -> Void)?
    var onPrivacyTap: (() -> Void)?
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setLabel()
        self.setupGestureHandling()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Private Methods
    
    private func setLabel() {
        let fullText = "회원가입 시 이용약관과 개인정보 처리 방침에 동의하게 됩니다."
        let termsText = "이용약관"
        let privacyText = "개인정보 처리 방침"
        
        self.font = .sSub
        self.textColor = .dotchiWhite
        self.textAlignment = .center
        self.isUserInteractionEnabled = true
        
        let attributedString = NSMutableAttributedString(string: fullText)
        let termsRange = (fullText as NSString).range(of: termsText)
        let privacyRange = (fullText as NSString).range(of: privacyText)
        
        // "이용약관"에 밑줄 추가
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: termsRange)
        attributedString.addAttribute(.foregroundColor, value: UIColor.white, range: termsRange)
        
        // "개인정보 처리 방침"에 밑줄 추가
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: privacyRange)
        attributedString.addAttribute(.foregroundColor, value: UIColor.white, range: privacyRange)
        
        self.attributedText = attributedString
    }
    
    private func setupGestureHandling() {
        let termsText = "이용약관"
        let privacyText = "개인정보 처리 방침"
        
        guard let text = self.attributedText?.string else { return }
        let termsRange = (text as NSString).range(of: termsText)
        let privacyRange = (text as NSString).range(of: privacyText)
        
        self.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] gesture in
                guard let self = self else { return }
                
                if gesture.didTapAttributedTextInLabel(label: self, inRange: termsRange) {
                    self.onTermsTap?()
                } else if gesture.didTapAttributedTextInLabel(label: self, inRange: privacyRange) {
                    self.onPrivacyTap?()
                }
            })
            .disposed(by: self.disposeBag)
    }
}
