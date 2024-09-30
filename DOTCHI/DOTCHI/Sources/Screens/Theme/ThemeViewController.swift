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
    
    private let collectionView: UICollectionView = {
        let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    // MARK: Properties
    
    private var luckyType: LuckyType = .lucky
    private var cards: [CardEntity] = []
    
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
        
        self.setBackButtonAction(self.navigationView.backButton)
        self.setUI()
        self.setLayout()
        self.setButtonToggle()
        self.setCollectionView()
        self.setTwoColumnCollectionViewLayout()
        self.fetchCards(sort: self.latestButton.isSelected ? .recent : .popular)
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
                self?.cards = []
                self?.collectionView.reloadData()
                self?.fetchCards(sort: self?.latestButton.isSelected ?? true ? .recent : .popular)
            }
        })
    }
    
    private func setTwoColumnCollectionViewLayout() {
        let collectionViewLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()

        // 컬렉션 뷰의 너비에서 2열을 만들기 위한 셀 너비 계산
        let padding: CGFloat = 28 // 좌우 패딩
        let minimumInteritemSpacing: CGFloat = 12 // 열 간의 간격
        let availableWidth = self.view.frame.width - (padding * 2) - minimumInteritemSpacing
        let cellWidth = availableWidth / 2
        
        // 셀 크기 및 간격 설정
        collectionViewLayout.itemSize = CGSize(width: cellWidth, height: cellWidth * 241 / 163) // 1:1 비율로 설정
        collectionViewLayout.minimumInteritemSpacing = minimumInteritemSpacing
        collectionViewLayout.minimumLineSpacing = 12 // 행 간의 간격 설정
        
        // 컬렉션 뷰의 섹션 인셋 설정
        collectionViewLayout.sectionInset = UIEdgeInsets(top: 0, left: padding, bottom: 16, right: padding)
        
        // 스크롤 방향 설정 (세로 스크롤)
        collectionViewLayout.scrollDirection = .vertical
        
        // 레이아웃 적용
        self.collectionView.collectionViewLayout = collectionViewLayout
    }
    
    private func setCollectionView() {
        self.collectionView.register(cell: DotchiSmallCardCollectionViewCell.self)
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }
}

extension ThemeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DotchiSmallCardCollectionViewCell.className, for: indexPath) as! DotchiSmallCardCollectionViewCell
        
        cell.setData(frontData: self.cards[indexPath.row].front)
        
        return cell
    }
}

extension ThemeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.present(DotchiDetailViewController(cardId: self.cards[indexPath.row].front.cardId), animated: true)
    }
}

// MARK: - Network

extension ThemeViewController {
    private func fetchCards(sort: CardSortType) {
        CardService.shared.getCardsByTheme(luckyType: self.luckyType, sort: sort) { result in
            if case .success(let cards) = result {
                self.cards = (cards as? CardListResponseDTO)?.toCardEntity() ?? []
                self.collectionView.reloadData()
            } else {
                self.showNetworkErrorAlert()
            }
        }
    }
}

// MARK: - Layout

extension ThemeViewController {
    private func setLayout() {
        self.view.addSubviews([
            navigationView,
            titleLabel,
            latestButton,
            popularButton,
            collectionView
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
        
        self.collectionView.snp.makeConstraints { make in
            make.top.equalTo(self.latestButton.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
}

