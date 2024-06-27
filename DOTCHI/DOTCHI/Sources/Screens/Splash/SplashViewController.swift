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
    
    // MARK: Methods
    
    private func setUI() {
        self.view.backgroundColor = .dotchiBlack
    }
    
//    private func autoSignIn() {
//        // TODO: FCM
////        let deviceToken: String = UserInfo.shared.deviceToken
//        
//        let tokenData: RefreshTokenRequestDTO = .init(
//            accessToken: UserDefaultsManager.accessToken ?? "",
//            refreshToken: UserDefaultsManager.refreshToken ?? ""
//        )
//        
//        self.requestRefreshToken(data: tokenData) { isProfileCompleted in
//            self.presentNextViewController(isProfileCompleted: isProfileCompleted)
//        }
//    }
//    
//    private func presentNextViewController(isProfileCompleted: Bool) {
//        if isProfileCompleted {
//            self.present(GamTabBarController(), animated: true)
//        } else {
//            self.present(BaseNavigationController(rootViewController: SignUpUsernameViewController()), animated: true)
//        }
//    }

}

// MARK: - UI

extension SplashViewController {
    private func setLayout() {
        self.view.addSubviews([logoImageView])
        
        self.logoImageView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.height.equalTo(180)
        }
    }
}
