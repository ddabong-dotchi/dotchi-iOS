//
//  HomeNicknameView.swift
//  DOTCHI
//
//  Created by Jungbin Jung on 9/8/24.
//

import UIKit
import SnapKit

class HomeNicknameView: UIView {
    
    // MARK: Properties
    
    private let label = {
        let label = UILabel()
        label.font = .sub
        label.textColor = .dotchiWhite
        label.textAlignment = .center
        return label
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
    
    private func setUI() {
        self.backgroundColor = .dotchiBlack90
        self.makeRounded(cornerRadius: 16)
        
        self.addSubviews([label])
        
        self.label.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(13)
            make.verticalEdges.equalToSuperview().inset(9)
        }
    }
    
    func setNickname(nickname: String) {
        self.label.text = nickname
        self.label.sizeToFit()
    }
}
