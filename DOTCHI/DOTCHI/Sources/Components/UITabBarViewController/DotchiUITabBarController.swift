//
//  DotchiUITabBarController.swift
//  DOTCHI
//
//  Created by Jungbin on 6/27/24.
//

import UIKit
import SnapKit
import SwiftUI

final class DotchiUITabBarController: UITabBarController {
    
    // MARK: UIComponents
    
    private let backgroundView: UIImageView = {
        let iamgeView: UIImageView = UIImageView(image: .imgTabBar)
        return iamgeView
    }()
    
    // MARK: Initializer
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        
        self.modalPresentationStyle = .fullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setTabBarItemStyle()
        self.setTabBar()
        self.setTabBarUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.setTabBarHeight()
    }
    
    /// TabBarItem 생성해 주는 메서드
    private func makeTabBarItem(viewController: UIViewController, title: String, image: UIImage, selectedImage: UIImage) -> UIViewController {
        
        viewController.tabBarItem = UITabBarItem(
            title: title,
            image: image.withRenderingMode(.alwaysOriginal),
            selectedImage: selectedImage.withRenderingMode(.alwaysOriginal)
        )
        
        viewController.tabBarItem.imageInsets = UIEdgeInsets(top: 7, left: 0, bottom: -7, right: 0)
        return viewController
    }
    
    /// TabBarItem을 지정하는 메서드
    private func setTabBar() {
        self.delegate = self
        
        let homeTab = self.makeTabBarItem(
            title: "홈",
            image: .icnHome,
            selectedImage: .icnHomeSelected
        )
        
        homeTab.tabBarItem.tag = 0
        
        let writeTab = self.makeTabBarItem(
            viewController: BaseUINavigationController(rootViewController: BaseViewController()), // 이 부분 마이페이지 뷰로 변경 필요 @유빈
            title: "",
            image: .icnPlus,
            selectedImage: .icnPlus
        )
        
        writeTab.tabBarItem.tag = 1
        writeTab.tabBarItem.imageInsets = UIEdgeInsets(top: 16.adjustedH, left: 0, bottom: 0, right: 0)
        
        let myTab = self.makeTabBarItem(
            viewController: BaseUINavigationController(rootViewController: UIHostingController(rootView: MyView())),
            title: "마이",
            image: .icnMy,
            selectedImage: .icnMySelected
        )
        
        myTab.tabBarItem.tag = 2
        
        
        let tabs = [homeTab, writeTab, myTab]
        self.setViewControllers(tabs, animated: false)
    }
    
    func hideTabbar() {
        self.tabBar.isHidden = true
        self.backgroundView.isHidden = true
    }
    
    func showTabbar() {
        self.tabBar.isHidden = false
        self.backgroundView.isHidden = false
    }
}

// MARK: - Layout

extension DotchiUITabBarController {
    
    /// TabBar의 height을 설정하는 메서드
    private func setTabBarHeight() {
        let height = 100.0.adjustedH
        
        var tabFrame = self.tabBar.frame
        tabFrame.size.height = height
        tabFrame.origin.y = self.view.frame.size.height - height
        
        self.tabBar.frame = tabFrame
        self.tabBar.setNeedsLayout()
        self.tabBar.layoutIfNeeded()
        self.backgroundView.frame = tabBar.frame
    }
    
    /// TabBarItem 스타일을 지정하는 메서드
    private func setTabBarItemStyle() {
        tabBar.tintColor = .dotchiWhite
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.sSub], for: .normal)
    }
    
    /// TabBar의 UI를 지정하는 메서드
    private func setTabBarUI() {
        let appearance = self.tabBar.standardAppearance
        appearance.shadowColor = nil
        appearance.shadowImage = nil
        appearance.backgroundImage = nil
        appearance.backgroundEffect = nil
        appearance.backgroundColor = .clear
        self.tabBar.standardAppearance = appearance
        
        self.backgroundView.addShadow(location: .top)
        self.view.addSubviews([self.backgroundView])
        self.view.bringSubviewToFront(self.tabBar)
    }
}

// MARK: - UITabBarControllerDelegate

extension DotchiUITabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let writeIndex: Int = 1
        if viewController.tabBarItem.tag != writeIndex { return true }
        
        self.present(MakeDotchiPhotoViewController(), animated: true)
        return false
    }
}
