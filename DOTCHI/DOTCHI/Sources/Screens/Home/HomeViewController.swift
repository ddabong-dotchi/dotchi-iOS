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
    private let discoverView = HomeBrowseView()
    private let themeView = HomeThemeView()
    
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
            todayView,
            discoverView,
            themeView
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
            make.height.equalTo(451)
        }
        
        self.discoverView.snp.makeConstraints { make in
            make.top.equalTo(self.todayView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(343)
        }
        
        self.themeView.snp.makeConstraints { make in
            make.top.equalTo(self.discoverView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(560)
            make.bottom.equalToSuperview()
        }
    }
}
