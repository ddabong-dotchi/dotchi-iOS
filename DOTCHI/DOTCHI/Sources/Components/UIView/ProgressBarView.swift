//
//  ProgressBarView.swift
//  DOTCHI
//
//  Created by Jungbin on 7/22/24.
//

import UIKit
import SnapKit

final class ProgressBarView: UIView {
    
    enum Step: Int {
        case one = 1, two, three, four
    }
    
    // MARK: UIComponents
    
    private let progressView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = .dotchiGreen
        return view
    }()
    
    // MARK: Properties
    
    private let defaultWidth: CGFloat = 5
    
    // MARK: Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View Life Cycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.setUI()
    }
    
    // MARK: Methods
    
    private func setUI() {
        self.makeRounded(cornerRadius: self.frame.height / 2)
        
        self.backgroundColor = .dotchiBlack90
    }
    
    func setProgress(step: Step) {
        let fullWidth = self.frame.width
        var newWidth = self.defaultWidth
        switch step {
        case .one: break
        case .two, .three, .four:
            print(fullWidth)
            newWidth = (fullWidth - defaultWidth) / 3.0 * CGFloat(step.rawValue - 1)
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            self.progressView.snp.remakeConstraints { make in
                make.top.bottom.left.equalToSuperview()
                make.width.equalTo(newWidth)
            }
            self.layoutIfNeeded()
        })
    }
}

// MARK: - Layout

extension ProgressBarView {
    private func setLayout() {
        self.addSubviews([progressView])
        
        self.progressView.snp.makeConstraints { make in
            make.verticalEdges.left.equalToSuperview()
            make.width.equalTo(0)
        }
    }
}
