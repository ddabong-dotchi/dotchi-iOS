//
//  BrowseViewController.swift
//  DOTCHI
//
//  Created by Jungbin Jung on 9/29/24.
//


import UIKit
import SnapKit

final class BrowseViewController: BaseViewController {
    
    private enum Number {
        static let cellHorizonInset = isScreenSmallerThanIPhone13Mini() ? 80.0 : 65.0
        static let scale = 0.925
    }
    
    private enum Text {
        static let title = "따봉도치 둘러보기"
    }
    
    // MARK: UIComponents
    
    private let navigationView = DotchiNavigationView(type: .back)
    
    private let titleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = Text.title
        label.setStyle(.bigTitle, .white)
        return label
    }()
    
    private let latestButton: DotchiSortButton = DotchiSortButton(sortType: .recent)
    
    private let popularButton: DotchiSortButton = DotchiSortButton(sortType: .popular)
    
    private var collectionView: UICollectionView = {
        let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
        collectionView.isPagingEnabled = false
        collectionView.contentInset = .init(top: 0, left: Number.cellHorizonInset.adjustedW, bottom: 0, right: Number.cellHorizonInset.adjustedW)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.layoutMargins = .zero
        collectionView.decelerationRate = .fast
        return collectionView
    }()
    
    // MARK: Properties
    
    private var cards: [CardEntity] = []
    private var previousCellIndex: Int = 0
    private var currentCellIndex: Int = 0
    private var isLoadingData: Bool = false
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setLayout()
        self.setBackButtonAction(self.navigationView.backButton)
        self.setButtonToggle()
        self.fetchData(
            isLatest: self.latestButton.isSelected
        )
        self.setCollectionViewLayout()
        self.setCollectionView()
    }
    
    // MARK: Methods
    
    func resetAndFetchData() {
        self.currentCellIndex = 0
        self.previousCellIndex = 0
        self.cards = []
        self.collectionView.reloadData()
        self.fetchData(
            isLatest: self.latestButton.isSelected
        )
    }
    
    private func setButtonToggle() {
        self.latestButton.isSelected = true
        
        [self.latestButton, self.popularButton].forEach({ button in
            button.setAction { [weak self] in
                self?.latestButton.isSelected = button == self?.latestButton
                self?.popularButton.isSelected = button == self?.popularButton
                self?.cards = []
                self?.collectionView.reloadData()
                self?.fetchData(
                    isLatest: self?.latestButton.isSelected ?? true
//                    lastCardId: self?.cards.last?.front.cardId ?? APIConstants.pagingDefaultValue,
//                    lastCommentCount: self?.cards.last?.commentsCount ?? APIConstants.pagingDefaultValue
                )
            }
        })
    }
    
    private func setCollectionViewLayout() {
        let collectionViewLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        let cellWidth = self.view.frame.width - (Number.cellHorizonInset.adjustedW * 2)
        let cellHeight = cellWidth * 1.671186
        collectionViewLayout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        
        // 셀 간의 간격 및 스크롤 방향 설정
        collectionViewLayout.minimumLineSpacing = 24.adjustedW
        collectionViewLayout.scrollDirection = .horizontal
        
        // 컬렉션 뷰의 높이에서 셀 높이를 뺀 값을 계산해 중앙 배치
        let collectionViewHeight = self.collectionView.frame.height
        
        // 셀이 컬렉션 뷰의 높이보다 크거나 같아야 한 줄로 고정됩니다.
        if collectionViewHeight >= cellHeight {
            let verticalInset = (collectionViewHeight - cellHeight) / 2
            collectionViewLayout.sectionInset = UIEdgeInsets(top: verticalInset, left: 0, bottom: verticalInset, right: 0)
        } else {
            // 셀 높이가 컬렉션 뷰 높이를 초과할 경우 위아래 여백 없이 중앙 배치
            collectionViewLayout.sectionInset = .zero
        }
        
        self.collectionView.collectionViewLayout = collectionViewLayout
    }
    
    private func setCollectionView() {
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        self.collectionView.register(cell: BrowseCollectionViewCell.self)
    }
    
    private func zoomFocusCell(cell: UICollectionViewCell, isFocus: Bool ) {
         UIView.animate( withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
             cell.transform = isFocus ? .identity : CGAffineTransform(scaleX: Number.scale, y: Number.scale)
         }, completion: nil)
     }
    
    private func shareInstagram(data: CardEntity) {
        let instagramShareView: InstagramShareView = InstagramShareView(frame: CGRect(x: 0, y: 0, width: 570, height: 424))
        instagramShareView.setData(data: data)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if let storiesUrl = URL(string: "instagram-stories://share?source_application=\(APIConstants.facebookAppId)") {
                if UIApplication.shared.canOpenURL(storiesUrl) {
                    let imageData = instagramShareView.toUIImage().png()
                    let pasteboardItems: [String: Any] = [
                        "com.instagram.sharedSticker.stickerImage": imageData,
                        "com.instagram.sharedSticker.backgroundTopColor": UIColor.dotchiBlack.toHexString(),
                        "com.instagram.sharedSticker.backgroundBottomColor": UIColor.dotchiBlack.toHexString()
                    ]
                    let pasteboardOptions = [
                        UIPasteboard.OptionsKey.expirationDate: Date().addingTimeInterval(300)
                    ]
                    UIPasteboard.general.setItems([pasteboardItems], options: pasteboardOptions)
                    UIApplication.shared.open(storiesUrl, options: [:], completionHandler: nil)
                } else {
                    print("User doesn't have instagram on their device.")
                    if let openStore = URL(string: "itms-apps://itunes.apple.com/app/instagram/id389801252"), UIApplication.shared.canOpenURL(openStore) {
                        UIApplication.shared.open(openStore, options: [:], completionHandler: nil)
                    }
                }
            }
        }
    }
}

// MARK: - UICollectionViewDataSource

extension BrowseViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BrowseCollectionViewCell.className, for: indexPath) as? BrowseCollectionViewCell
        else { return UICollectionViewCell() }
        
        cell.setData(data: self.cards[indexPath.row])
        cell.setCardFlipDefault()
        cell.commentButton.removeTarget(nil, action: nil, for: .touchUpInside)
        cell.commentButton.setAction { [weak self] in
            let viewController = DotchiDetailViewController(cardId: self?.cards[indexPath.row].front.cardId ?? 0)
            viewController.browseViewController = self
            self?.present(viewController, animated: true)
        }
        
        cell.shareButton.removeTarget(nil, action: nil, for: .touchUpInside)
        cell.shareButton.setAction { [weak self] in
            if let card = self?.cards[indexPath.row] {
                self?.shareInstagram(data: card)
            }
        }
        
        self.zoomFocusCell(cell: cell, isFocus: indexPath.row == self.currentCellIndex)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension BrowseViewController: UICollectionViewDelegateFlowLayout {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity:CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
        let roundedIndex = round(index)
        offset = CGPoint(
            x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left,
            y: scrollView.contentInset.top
        )
        targetContentOffset.pointee = offset
        
        let indexPath = IndexPath(item: Int(roundedIndex), section: 0)
        self.currentCellIndex = Int(roundedIndex)
        
        if let cell = self.collectionView.cellForItem(at: indexPath) {
            self.zoomFocusCell(cell: cell, isFocus: true)
        }
        
        if Int(roundedIndex) != self.previousCellIndex {
            let preIndexPath = IndexPath(item: self.previousCellIndex, section: 0)
            if let preCell = self.collectionView.cellForItem(at: preIndexPath) {
                self.zoomFocusCell(cell: preCell, isFocus: false)
            }
            self.previousCellIndex = indexPath.item
        }
    }
}

// MARK: - Network

extension BrowseViewController {
    private func fetchData(isLatest: Bool) {
        CardService.shared.getAllCards(sort: isLatest ? .recent : .popular) { result in
            if case .success(let cards) = result {
                self.cards = (cards as? CardListResponseDTO)?.toCardEntity() ?? []
                self.currentCellIndex = 0
                self.previousCellIndex = 0
                self.collectionView.reloadData()
                self.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .centeredHorizontally, animated: true)
            }
            else {
                debugPrint("Error fetching cards: \(result)")
            }
        }
    }
}

// MARK: - Layout

extension BrowseViewController {
    private func setLayout() {
        self.view.addSubviews([navigationView, titleLabel, latestButton, popularButton, collectionView])
        
        self.navigationView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        self.titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.navigationView.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(28)
            make.height.equalTo(32)
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
            make.top.equalTo(self.latestButton.snp.bottom).offset(0)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
}
