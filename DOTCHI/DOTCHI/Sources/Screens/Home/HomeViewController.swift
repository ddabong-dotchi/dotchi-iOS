//
//  HomeViewController.swift
//  DOTCHI
//
//  Created by Jungbin on 7/3/24.
//

import UIKit
import SnapKit

final class HomeViewController: BaseViewController {
    
    // MARK: UIComponents
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let todayView = HomeTodayView()
    
    // MARK: Properties
    
    
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setLayout()
        self.setUI()
    }
    
    // MARK: Methods
    
    private func setUI() {
        self.view.backgroundColor = .dotchiHomeBackgroundGray
    }
    
}

// MARK: - Layout

extension HomeViewController {
    private func setLayout() {
        self.view.addSubviews([scrollView])
        self.scrollView.addSubviews([contentView])
        self.contentView.addSubviews([
            todayView
        ])
        
        self.scrollView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        self.contentView.snp.makeConstraints { make in
            make.edges.width.equalToSuperview()
        }
        
        self.todayView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(500)
            make.bottom.equalToSuperview()
        }
    }
}
