//
//  MakeDotchiPhotoViewController.swift
//  DOTCHI
//
//  Created by Jungbin on 6/27/24.
//

import UIKit
import SnapKit

final class MakeDotchiPhotoViewController: BaseViewController {
    
    private enum Number {
        static let cellHorizonInset = isScreenSmallerThanIPhone13Mini() ? 70.0 : 49.0
        static let scale = 0.925
    }
    
    private enum Text {
        static let title = "따봉도치 만들기"
        static let info = "프레임에 따라 바뀌는 행운 테마를 확인해 보세요!"
        static let next = "다음"
    }
    
    // MARK: UIComponents
    
    private let navigationView: DotchiNavigationView = {
        let view = DotchiNavigationView(type: .closeCenterTitle)
        view.centerTitleLabel.text = Text.title
        return view
    }()
    
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
    
    private var luckyTitleView = MakeDotchiLuckyTitleView(luckyType: .lucky)
    
    private let infoLabel: UILabel = {
        let label: UILabel = UILabel()
        label.setStyle(.sub, .dotchiWhite)
        label.text = Text.info
        label.textAlignment = .center
        return label
    }()
    
    private let nextButton: DoneButton = {
        let button: DoneButton = DoneButton()
        button.setTitle(Text.next, for: .normal)
        button.isEnabled = false
        return button
    }()
    
    private let imagePickerController: UIImagePickerController = {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = true
        return imagePickerController
    }()
    
    // MARK: Properties
    
    private var currentCellIndex: Int = 0
    private var previousCellIndex: Int = 0
    private var makeDotchiData: MakeDotchiEntity = MakeDotchiEntity()
    
    // MARK: Initializer
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        
        self.modalPresentationStyle = .overFullScreen
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setLayout()
        self.setCloseButtonAction(self.navigationView.closeButton)
        self.setCollectionViewLayout()
        self.setCollectionView()
        self.setImagePickerController()
        self.setNextButtonAction()
    }
    
    // MARK: Methods
    
    private func setCollectionViewLayout() {
        let collectionViewLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        let cellWidth = self.view.frame.width - (Number.cellHorizonInset.adjustedW * 2)
        let cellHeight = cellWidth * 1.476014
        collectionViewLayout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        
        // 셀 간의 간격 및 스크롤 방향 설정
        collectionViewLayout.minimumLineSpacing = 12.adjustedW
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
        
        self.collectionView.register(cell: MakeDotchiCollectionViewCell.self)
    }
    
    private func zoomFocusCell(cell: UICollectionViewCell, isFocus: Bool ) {
         UIView.animate( withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
             cell.transform = isFocus ? .identity : CGAffineTransform(scaleX: Number.scale, y: Number.scale)
         }, completion: nil)
     }
    
    private func setImagePickerController() {
        self.imagePickerController.delegate = self
    }
    
    private func setNextButtonAction() {
        self.nextButton.setAction { [weak self] in
            self?.navigationController?.pushViewController(
                MakeDotchiContentViewController(makeDotchiData: self?.makeDotchiData ?? .init()),
                animated: true
            )
        }
    }
}

// MARK: - UICollectionViewDataSource

extension MakeDotchiPhotoViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MakeDotchiCollectionViewCell.className, for: indexPath) as? MakeDotchiCollectionViewCell
        else { return UICollectionViewCell() }
        
        cell.setData(luckyType: (indexPath.row + 1).toLuckyType())
        cell.setPhoto(image: self.makeDotchiData.image)
        
        self.zoomFocusCell(cell: cell, isFocus: indexPath.row == self.currentCellIndex)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MakeDotchiPhotoViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.present(self.imagePickerController, animated: true)
    }
    
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
        self.makeDotchiData.luckyType = (self.currentCellIndex + 1).toLuckyType()
        
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
        
        self.luckyTitleView.setTitle(luckyType: (Int(roundedIndex) + 1).toLuckyType())
    }
}

// MARK: - UIImagePickerControllerDelegate

extension MakeDotchiPhotoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) {
            if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                self.makeDotchiData.image = image
                self.nextButton.isEnabled = true
                self.collectionView.reloadData()
            }
        }
    }
}

// MARK: - Layout

extension MakeDotchiPhotoViewController {
    private func setLayout() {
        self.view.addSubviews([navigationView, collectionView, luckyTitleView, nextButton, infoLabel])
        
        self.navigationView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        self.collectionView.snp.makeConstraints { make in
            make.centerY.equalTo(self.view.safeAreaLayoutGuide).offset(-84.adjustedH)
//            make.top.equalTo(self.navigationView)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(440)
        }
        
        self.luckyTitleView.snp.makeConstraints { make in
            make.top.equalTo(self.collectionView.snp.bottom).offset(isScreenSmallerThanIPhone13Mini() ? -10 : 22.adjustedH)
            make.centerX.equalToSuperview()
        }
        
        self.nextButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(32)
            make.horizontalEdges.equalToSuperview().inset(28)
            make.height.equalTo(52)
        }
        
        self.infoLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(self.nextButton.snp.top).offset(-20.adjustedH)
            make.height.equalTo(14)
        }
    }
}
