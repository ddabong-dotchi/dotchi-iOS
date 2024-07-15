//
//  MyViewController.swift
//  DOTCHI
//
//  Created by KimYuBin on 7/5/24.
//

import UIKit
import SnapKit

class MyViewController: BaseViewController {
    
    var collectionView: UICollectionView!
    var zeroView: UIView!
    
    private let userService = UserService.shared
    
    private var profileImageView: UIImageView!
    private var nameLabel: UILabel!
    private var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.dotchiScreenBackground
        
        setupNavigationBar()
        setupSubviews()
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
        guard let navigationController = self.navigationController as? BaseUINavigationController else {
            print("네비게이션 컨트롤러가 설정되지 않았습니다.")
            return
        }
        navigationController.showNavigationBar()
        navigationItem.title = ""
        
        if let image = UIImage(named: "icnSetting") {
            let settingButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(settingButtonTapped))
            navigationItem.rightBarButtonItem = settingButton
        } else {
            print("이미지를 찾을 수 없습니다.")
        }
    }
    
    // MARK: - Setup Subviews
    
    private func setupSubviews() {
        profileImageView = UIImageView()
        profileImageView.layer.cornerRadius = 24
        profileImageView.layer.masksToBounds = true
        profileImageView.contentMode = .scaleAspectFill
        
        view.addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(0)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(116)
        }
        
        nameLabel = UILabel()
        nameLabel.font = UIFont.body
        nameLabel.textColor = UIColor.dotchiWhite
        
        view.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        descriptionLabel = UILabel()
        descriptionLabel.font = UIFont.subSbold
        descriptionLabel.textColor = UIColor.dotchiLgray
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
        
        view.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(18)
            make.leading.trailing.equalToSuperview().inset(30)
        }
        
        let containerView = UIView()
        containerView.backgroundColor = UIColor.dotchiMgray
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        containerView.layer.cornerRadius = 24
        containerView.layer.masksToBounds = true
        
        view.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(31)
            make.leading.trailing.equalToSuperview().inset(0)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(0)
        }
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        
        let titleLabel = UILabel()
        titleLabel.font = UIFont.head2
        titleLabel.textColor = UIColor.dotchiGreen
        titleLabel.text = "공유 따봉도치"
        
        let countLabel = UILabel()
        countLabel.font = UIFont.head2
        countLabel.textColor = UIColor.dotchiGreen
        countLabel.text = "0"
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(countLabel)
        
        containerView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(25)
            make.centerX.equalToSuperview()
        }
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MyCollectionViewCell.self, forCellWithReuseIdentifier: "MyCollectionViewCell")
        
        containerView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(10)
        }
        
        zeroView = UIView()
        containerView.addSubview(zeroView)
        zeroView.snp.makeConstraints { make in
            make.edges.equalTo(collectionView)
        }
        
        setupZeroView()
    }
    
    private func setupZeroView() {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "imgNClover")
        imageView.contentMode = .scaleAspectFit
        
        zeroView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-50)
            make.width.equalTo(155.9)
            make.height.equalTo(132)
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
    
    private func fetchMyData() {
        userService.getUser { [weak self] result in
            switch result {
            case .success(let data):
                if let userResponse = data as? UserResultDTO {
                    self?.updateUI(with: userResponse)
                    
                } else {
                    print("Invalid data format received")
                }
            case .requestErr(let message):
                print("Request error: \(message)")
            case .pathErr:
                print("Path error")
            case .serverErr:
                print("Server error")
            case .networkFail:
                print("Network failure")
            }
        }
    }
    
    private func updateUI(with userData: UserResultDTO) {
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
    
    @objc private func settingButtonTapped() {
        let settingViewController = SettingViewController()
        navigationController?.pushViewController(settingViewController, animated: true)
    }
}

extension MyViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCollectionViewCell", for: indexPath) as? MyCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        return cell
    }
}

class MyCollectionViewCell: UICollectionViewCell {
    private let cardImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(cardImageView)
        cardImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
