//
//  BaseUINavigationController.swift
//  DOTCHI
//
//  Created by Jungbin on 6/27/24.
//

import UIKit

final class BaseNavigationController: UINavigationController {
    
    // MARK: Initializer
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        
        self.modalPresentationStyle = .fullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideNavigationBar()
    }
    
    func hideNavigationBar() {
        self.navigationBar.isHidden = true
    }
    
    func showNavigationBar() {
        self.navigationBar.isHidden = false
    }
}
