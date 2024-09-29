//
//  ThemeViewController.swift
//  DOTCHI
//
//  Created by Jungbin Jung on 9/30/24.
//

import UIKit
import SnapKit

final class ThemeViewController: BaseViewController {
    
    private enum Text {
        static let titleTail = "을 빌어주는 따봉도치"
    }
    
    // MARK: UIComponents
    
    private let navigationView = DotchiNavigationView(type: .back)
    
    private let titleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = Text.titleTail
        label.setStyle(.title, .white)
        return label
    }()
    
    private let latestButton: DotchiSortButton = DotchiSortButton(sortType: .recent)
    
    private let popularButton: DotchiSortButton = DotchiSortButton(sortType: .popular)
    
    // MARK: Properties
    
    private var luckyType: LuckyType = .lucky
    
    // MARK: Initializer
    
    init(luckyType: LuckyType) {
        super.init(nibName: nil, bundle: nil)
        
        self.luckyType = luckyType
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUI()
        self.setLayout()
        self.setButtonToggle()
    }
    
    // MARK: Methods
    
    private func setUI() {
        self.titleLabel.text = "\(self.luckyType.name())\(Text.titleTail)"
    }
    
    private func setButtonToggle() {
        self.latestButton.isSelected = true
        
        [self.latestButton, self.popularButton].forEach({ button in
            button.setAction { [weak self] in
                self?.latestButton.isSelected = button == self?.latestButton
                self?.popularButton.isSelected = button == self?.popularButton
            }
        })
    }
}

// MARK: - Layout

extension ThemeViewController {
    private func setLayout() {
        self.view.addSubviews([
            navigationView,
            titleLabel,
            latestButton,
            popularButton
        ])
        
        self.navigationView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        self.titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.navigationView.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(28)
            make.height.equalTo(28)
        }
        
        self.latestButton.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().inset(28)
            make.width.equalTo(42)
            make.height.equalTo(22)
        }
        
        self.popularButton.snp.makeConstraints { make in
            make.top.width.height.equalTo(self.latestButton)
            make.leading.equalTo(self.latestButton.snp.trailing).offset(9)
        }
    }
}

