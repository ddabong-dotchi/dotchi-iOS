//
//  MyViewController.swift
//  DOTCHI
//
//  Created by KimYuBin on 7/5/24.
//

import UIKit
import SnapKit

class MyViewController: BaseViewController {
    private let userService = UserService.shared
    private var myCardData: [MyCardResponseDTO] = []
    
    private var profileImageView = UIImageView()
    private var nameLabel = UILabel()
    private var descriptionLabel = UILabel()
    private let containerView = UIView()
    private let stackView = UIStackView()
    private let titleLabel = UILabel()
    private let countLabel = UILabel()
    private var collectionView: UICollectionView!
    private var zeroView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.dotchiScreenBackground
        
        setupNavigationBar()
        setupSubviews()
        setupConstraints()
        fetchMyData()
        
        if let navigationBar = self.navigationController?.navigationBar {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor.dotchiScreenBackground
            
            appearance.titleTextAttributes = [
                .foregroundColor: UIColor.dotchiWhite,
                .font: UIFont.subTitle
            ]
            
            navigationBar.standardAppearance = appearance
            navigationBar.scrollEdgeAppearance = appearance
            navigationBar.compactAppearance = appearance
            navigationBar.isTranslucent = false
            
            navigationController?.navigationBar.tintColor = UIColor.dotchiWhite
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchMyData()
    }

    // MARK: - Setup NavigationBar
    
    private func setupNavigationBar() {
        guard let navigationController = self.navigationController as? BaseNavigationController else {
            print("네비게이션 컨트롤러가 설정되지 않았습니다.")
            return
        }
        navigationController.showNavigationBar()
        navigationItem.title = ""
        
        let settingButton = UIBarButtonItem(image: UIImage(named: "icnSetting"), style: .plain, target: self, action: #selector(settingButtonTapped))
        navigationItem.rightBarButtonItem = settingButton
    }
    
    // MARK: - Setup Subviews
    
    private func setupSubviews() {
        self.view.addSubviews([
            profileImageView,
            nameLabel,
            descriptionLabel,
            containerView
        ])
        
        profileImageView.layer.cornerRadius = 24
        profileImageView.layer.masksToBounds = true
        profileImageView.contentMode = .scaleAspectFill
        
        nameLabel.setStyle(.body, .dotchiWhite)
        
        descriptionLabel.setStyle(.subSbold, .dotchiLgray)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .center
        if description.count > 20 {
            let firstLineIndex = description.index(description.startIndex, offsetBy: 20)
            let firstLine = String(description.prefix(upTo: firstLineIndex))
            let secondLine = String(description.suffix(from: firstLineIndex))
            descriptionLabel.text = "\(firstLine)\n\(secondLine)"
        } else {
            descriptionLabel.text = description
        }
        
        containerView.backgroundColor = UIColor.dotchiMgray
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        containerView.layer.cornerRadius = 24
        containerView.layer.masksToBounds = true
        
        stackView.axis = .horizontal
        stackView.spacing = 8
        
        titleLabel.text = "공유 따봉도치"
        titleLabel.setStyle(.head2, .dotchiGreen)
        
        countLabel.text = "0"
        countLabel.setStyle(.head2, .dotchiGreen)
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(countLabel)
        
        setupZeroView()
        
        setupCollectionViewLayout()
        
        containerView.addSubviews([
            stackView,
            collectionView,
            zeroView
        ])
    }
    
    private func setupZeroView() {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "imgNClover")
        imageView.contentMode = .scaleAspectFit
        
        zeroView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-55)
        }
        
        let messageLabel = UILabel()
        messageLabel.font = UIFont.head2
        messageLabel.textColor = UIColor.dotchiDGray
        messageLabel.text = "아직 베푼 행운이 없어요!"
        
        zeroView.addSubview(messageLabel)
        messageLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).offset(20)
        }
    }
    
    private func setupCollectionViewLayout() {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .vertical

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(cell: DotchiSmallCardCollectionViewCell.self, forCellWithReuseIdentifier: "DotchiSmallCardCollectionViewCell")

        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false

        let padding: CGFloat = 28
        let minimumInteritemSpacing: CGFloat = 12
        let availableWidth = self.view.frame.width - (padding * 2)
        let cellWidth = (availableWidth - minimumInteritemSpacing) / 2

        collectionViewLayout.itemSize = CGSize(width: cellWidth, height: cellWidth * 241 / 163)
        collectionViewLayout.minimumInteritemSpacing = minimumInteritemSpacing
        collectionViewLayout.minimumLineSpacing = 12
        collectionViewLayout.sectionInset = UIEdgeInsets(top: 0, left: padding, bottom: 28, right: padding)

        collectionView.collectionViewLayout = collectionViewLayout
    }

    
    // MARK: - Setup Constraints
    
    private func setupConstraints() {
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(0)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(116)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(18)
            make.leading.trailing.equalToSuperview().inset(30)
        }
        
        containerView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(31)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(25)
            make.centerX.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(20)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        zeroView.snp.makeConstraints { make in
            make.edges.equalTo(collectionView)
        }
    }
    
    // MARK: - Network
    
    private func fetchMyData() {
        userService.getUser { networkResult in
            switch networkResult {
            case .success(let data):
                if let userResponse = data as? UserResponseDTO {
                    self.updateProfileUI(with: userResponse)
                } else {
                    print("Invalid data format received")
                }
            default:
                self.showNetworkErrorAlert()
            }
        }
        
        userService.getMyCard { networkResult in
            switch networkResult {
            case .success(let data):
                if let myCardResponse = data as? [MyCardResponseDTO] {
                    self.myCardData = myCardResponse
                    self.updateCardUI(with: self.myCardData)
                } else {
                    print("Invalid data format received")
                }
            default:
                self.showNetworkErrorAlert()
            }
        }
    }
    
    private func updateProfileUI(with userData: UserResponseDTO) {
        DispatchQueue.main.async { [weak self] in
            self?.nameLabel.text = userData.nickname
            self?.descriptionLabel.text = userData.description
            if let url = URL(string: userData.imageUrl) {
                self?.profileImageView.loadImage(from: url)
            } else {
                print("Invalid image URL: \(userData.imageUrl)")
            }
        }
    }
    
    private func updateCardUI(with cardData: [MyCardResponseDTO]) {
        DispatchQueue.main.async { [weak self] in
            let count = cardData.count
            self?.countLabel.text = String(count)
            
            if count == 0 {
                self?.zeroView.isHidden = false
                self?.collectionView.isHidden = true
            } else {
                self?.zeroView.isHidden = true
                self?.collectionView.isHidden = false
                self?.collectionView.reloadData()
            }
        }
    }
    
    @objc private func settingButtonTapped() {
        let settingViewController = SettingViewController()
        navigationController?.pushViewController(settingViewController, animated: true)
    }
}

extension MyViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myCardData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DotchiSmallCardCollectionViewCell", for: indexPath) as? DotchiSmallCardCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let cardFrontEntities = myCardData.toCardFrontEntity()
        let frontEntity = cardFrontEntities[indexPath.row]
        
        cell.setData(frontData: frontEntity)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let cardId = myCardData[indexPath.row].cardId
        let detailVC = DotchiDetailViewController(cardId: cardId)
        detailVC.modalPresentationStyle = .fullScreen
        
        self.present(detailVC, animated: true)
    }
}

extension UIImageView {
    func loadImage(from url: URL) {
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self, let data = data, error == nil, let image = UIImage(data: data) else {
                print("Failed to load image from URL: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            DispatchQueue.main.async {
                self.image = image
            }
        }
        dataTask.resume()
    }
}
