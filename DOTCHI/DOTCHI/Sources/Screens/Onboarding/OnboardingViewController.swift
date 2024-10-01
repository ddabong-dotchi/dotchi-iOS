//
//  OnboardingViewController.swift
//  DOTCHI
//
//  Created by Jungbin Jung on 9/30/24.
//

import UIKit
import SnapKit

class OnboardingViewController: BaseViewController, UIScrollViewDelegate {
    
    // MARK: UIComponents
    
    private let scrollView = UIScrollView()
    private let pageControl = UIPageControl()
    private let images = ["imgOnboarding1", "imgOnboarding2", "imgOnboarding3", "imgOnboarding4"]
    private var imageViews = [UIImageView]()
    
    private var startButton = {
        let button = DoneButton()
        button.setTitle("시작하기", for: .normal)
        return button
    }()
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupScrollView()
        self.setupPageControl()
        self.setLayout()
        self.setStartButtonAction()
    }

    // MARK: Methods
    
    private func setupScrollView() {
        self.scrollView.delegate = self
        self.scrollView.isPagingEnabled = true
        self.scrollView.showsHorizontalScrollIndicator = false
        
        for imageName in self.images {
            let imageView = UIImageView()
            imageView.image = UIImage(named: imageName)
            imageView.contentMode = .scaleAspectFit
            self.scrollView.addSubview(imageView)
            self.imageViews.append(imageView)
        }
    }

    
    private func setupPageControl() {
        self.pageControl.numberOfPages = self.images.count
        self.pageControl.currentPage = 0
        self.pageControl.pageIndicatorTintColor = .dotchiBlack80
        self.pageControl.currentPageIndicatorTintColor = .dotchiWhite
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / self.view.frame.width)
        self.pageControl.currentPage = Int(pageIndex)
    }
    
    private func setStartButtonAction() {
        self.startButton.setAction {
            self.present(SigninViewController(), animated: true)
        }
    }
}

extension OnboardingViewController {
    private func setLayout() {
        self.view.addSubviews([
            self.scrollView,
            self.pageControl,
            self.startButton
        ])

        
        self.scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(80)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(self.view.snp.height).multipliedBy(500.0 / 852.0)
        }

        
        for (index, imageView) in self.imageViews.enumerated() {
            imageView.snp.makeConstraints { make in
                make.top.equalTo(self.scrollView)
                make.width.equalTo(self.view.snp.width)
                make.height.equalToSuperview()

                if index == 0 {
                    make.leading.equalTo(self.scrollView.snp.leading)
                } else {
                    make.leading.equalTo(self.imageViews[index - 1].snp.trailing)
                }

                if index == self.images.count - 1 {
                    make.trailing.equalTo(self.scrollView.snp.trailing)
                }
            }
        }
        
        
        self.startButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(32)
            make.horizontalEdges.equalToSuperview().inset(28)
            make.height.equalTo(52)
        }
        
        
        self.pageControl.snp.makeConstraints { make in
            make.bottom.equalTo(self.startButton.snp.top).offset(-60)
            make.centerX.equalToSuperview()
        }
    }
}
