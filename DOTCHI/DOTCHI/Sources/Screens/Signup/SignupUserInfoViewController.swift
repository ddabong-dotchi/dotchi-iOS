//
//  SignupUserInfoViewController.swift
//  DOTCHI
//
//  Created by Jungbin on 7/10/24.
//

import UIKit
import SnapKit

final class SignupUserInfoViewController: BaseViewController {
    
    // MARK: UIComponents
    
    private let navigationView: DotchiNavigationView = DotchiNavigationView(type: .close)
    
    private let progressBarView = ProgressBarView()
    
    // MARK: Properties
    
    
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.setUI()
    }
    
    // MARK: Methods
    
    private func setUI() {
        self.progressBarView.setProgress(step: .one)
    }
}

// MARK: - Layout

extension SignupUserInfoViewController {
    private func setLayout() {
        self.view.addSubviews([navigationView, progressBarView])
        
        self.navigationView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide)
            make.height.equalTo(48)
        }
        
        self.progressBarView.snp.makeConstraints { make in
            make.top.equalTo(self.navigationView.snp.bottom).offset(37)
            make.horizontalEdges.equalToSuperview().inset(28)
            make.height.equalTo(6)
        }
    }
}
