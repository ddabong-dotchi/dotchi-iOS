//
//  TextUnderlineUIButton.swift
//  DOTCHI
//
//  Created by Jungbin on 7/4/24.
//

import UIKit
import SnapKit

final class TextUnderlineButtonView: UIView {
    
    // MARK: Properties
    
    let button: UIButton = {
        let button: UIButton = UIButton(type: .system)
        button.setBackgroundColor(.clear, for: .normal)
        return button
    }()
    
    private let underlineView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    // MARK: Initializer
    
    init(title: String) {
        super.init(frame: .zero)
        
        self.setButtonTitle(title: title)
        self.setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    
    private func setButtonTitle(title: String) {
        self.button.setTitle(title, for: .normal)
        self.button.setTitleColor(.white, for: .normal)
        self.button.titleLabel?.font = .sub
    }
}

// MARK: - Layout

extension TextUnderlineButtonView {
    
    private func setLayout() {
        self.addSubviews([self.button, self.underlineView])
        
        self.button.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(14)
        }
        
        self.underlineView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(1)
            make.height.equalTo(0.5)
            make.top.equalTo(self.button.snp.bottom).offset(1.5)
        }
    }
}
