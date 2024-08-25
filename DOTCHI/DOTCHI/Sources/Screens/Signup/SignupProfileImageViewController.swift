//
//  SignupProfileImageViewController.swift
//  DOTCHI
//
//  Created by Jungbin on 7/16/24.
//

import UIKit
import SnapKit

final class SignupProfileImageViewController: BaseViewController {
    
    // MARK: UIComponents
    
    
    
    // MARK: Properties
    
    private var signupRequestData = SignupRequestDTO()
    
    // MARK: Initializer
    
    init(signupRequestData: SignupEntity) {
        super.init(nibName: nil, bundle: nil)
        
        self.signupRequestData = signupRequestData
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setLayout()
    }
    
    // MARK: Methods
    
    
}

// MARK: - Layout

extension SignupProfileImageViewController {
    private func setLayout() {
        self.view.addSubviews([])
    }
}
