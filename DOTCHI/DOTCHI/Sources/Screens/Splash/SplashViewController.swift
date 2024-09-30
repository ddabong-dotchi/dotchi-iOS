//
//  SplashViewController.swift
//  DOTCHI
//
//  Created by Jungbin on 6/27/24.
//

import UIKit

final class SplashViewController: BaseViewController {
    
    // MARK: UIComponents
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView(image: .imgDotchiLogoCenter)
        return imageView
    }()
    
    // MARK: Properties
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUI()
        self.setLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.autoSignIn()
    }
    
    // MARK: Methods
    
    private func setUI() {
        self.view.backgroundColor = .dotchiBlack
    }
    
    private func autoSignIn() {
        // TODO: FCM
//        let deviceToken: String = UserInfo.shared.deviceToken
        
        let signinRequestData: SigninRequestDTO = self.getSigninDataFromKeychain()
        
        self.requestSignin(data: signinRequestData) { response in
            self.setUserToken(data: response)
            self.presentHomeViewController()
        }
    }
    
    private func presentHomeViewController() {
        let tabBarController = DotchiTabBarController()
        self.present(tabBarController, animated: true)
    }
    
    private func presentSigninViewController() {
        self.present(OnboardingViewController(), animated: true)
    }
}

// MARK: - Network

extension SplashViewController {
    
    private func requestSignin(data: SigninRequestDTO, completion: @escaping (SigninResponseDTO) -> (Void)) {
        AuthService.shared.requestSignin(data: data) { networkResult in
            switch networkResult {
            case .success(let responseData):
                if let result = responseData as? SigninResponseDTO {
                    completion(result)
                }
            default:
                self.presentSigninViewController()
            }
        }
    }
}

// MARK: - UI

extension SplashViewController {
    private func setLayout() {
        self.view.addSubviews([logoImageView])
        
        self.logoImageView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.equalTo(209)
            make.height.equalTo(88)
        }
    }
}
