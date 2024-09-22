//
//  HomeDiscoverView.swift
//  DOTCHI
//
//  Created by Jungbin Jung on 9/9/24.
//

import UIKit
import SnapKit

final class HomeDiscoverView: UIView {
    
    private enum Text {
        static let title = "따봉도치 둘러보기"
        static let discover = "다양한 따봉도치들을 만나 보세요"
    }
    
    enum Number {
        static let cellHeight = 211.0
        static let cellWidth = 143.0
        static let cellSpacing = 12.0
    }
    
    // MARK: Properties
    
    private let titleLabel = {
        let label = UILabel()
        label.font = .head
        label.textColor = .dotchiWhite
        label.text = Text.title
        return label
    }()
    
    private let descriptionLabel = {
        let label = UILabel()
        label.font = .sub
        label.textColor = .dotchiLgray
        label.text = Text.discover
        return label
    }()
    
    private let allButton = MoreButton()
    
    private let cardCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = Number.cellSpacing
        flowLayout.itemSize = .init(width: Number.cellWidth, height: Number.cellHeight)
        
        let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.layoutMargins = .zero
        collectionView.contentInset = .init(top: 0, left: 28, bottom: 0, right: 28)
        return collectionView
    }()
    
    // MARK: Properties
    
    private var cards: [CardFrontEntity] = []
    
    // MARK: Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setUI()
        self.setLayout()
        self.setCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        if superview != nil {
            self.fetchCards()
        }
    }
    
    private func setUI() {
        self.backgroundColor = .dotchiBlack
    }
    
    private func setCollectionView() {
        self.cardCollectionView.delegate = self
        self.cardCollectionView.dataSource = self
        
        self.cardCollectionView.register(cell: DotchiSmallCardCollectionViewCell.self)
    }
}

// MARK: - UICollectionViewDataSource

extension HomeDiscoverView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DotchiSmallCardCollectionViewCell.className, for: indexPath) as? DotchiSmallCardCollectionViewCell
        else { return UICollectionViewCell() }
        
        cell.setData(frontData: self.cards[indexPath.row])
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension HomeDiscoverView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        print("cell clicked")
    }
}

// MARK: - Network

extension HomeDiscoverView {
    private func fetchCards() {
        CardService.shared.getAllCards(sort: .recent) { result in
            if case .success(let cards) = result {
                self.cards = (cards as? CardListResponseDTO)?.toCardFrontEntity() ?? []
                self.cardCollectionView.reloadData()
            }
            else {
                debugPrint("Error fetching cards: \(result)")
            }
        }
    }
}

// MARK: - Layout

extension HomeDiscoverView {
    private func setLayout() {
        self.addSubviews([
            titleLabel,
            descriptionLabel,
            allButton,
            cardCollectionView
        ])
        
        self.titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(47)
            make.left.equalToSuperview().inset(28)
            make.height.equalTo(24)
        }
        
        self.descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(14)
            make.left.equalToSuperview().inset(28)
            make.height.equalTo(14)
        }
        
        self.allButton.snp.makeConstraints { make in
            make.centerY.equalTo(self.titleLabel)
            make.right.equalToSuperview().inset(25)
            make.height.equalTo(14)
        }
        
        self.cardCollectionView.snp.makeConstraints { make in
            make.top.equalTo(self.descriptionLabel.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(211)
            make.bottom.equalToSuperview().inset(9)
        }
    }
}
