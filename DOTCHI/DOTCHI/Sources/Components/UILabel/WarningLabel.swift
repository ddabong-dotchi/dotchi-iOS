//
//  WarningLabel.swift
//  DOTCHI
//
//  Created by Jungbin on 7/31/24.
//

import UIKit

final class StatusLabel: UILabel {
    
    enum LabelStatus {
        case warning
        case success
    }
    
    // MARK: Properties
    
    var status: LabelStatus = .warning {
        didSet {
            self.updateLabel()
        }
    }
    
    private var warningText: String = ""
    private var successText: String = ""
    
    // MARK: Initializer
    
    init(warningText: String, successText: String) {
        super.init(frame: .zero)
        
        self.warningText = warningText
        self.successText = successText
        self.setStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    
    private func setStyle() {
        self.font = .sSub
    }
    
    private func updateLabel() {
        switch status {
        case .warning:
            self.text = self.warningText
            self.textColor = .dotchiOrange
        case .success:
            self.text = self.successText
            self.textColor = .dotchiGreen
        }
    }
}
