//
//  MainViewController.swift
//  UnsplashPhotoCollection
//
//  Created by Данил Чапаров on 21.06.2022.
//

import UIKit
import RxSwift
import RxRelay

final class MainViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let viewModel = MainCollectionViewModel()
    private let sectionInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    private let itemsPerRow: CGFloat = 2
    private var collectionView: UICollectionView!
    private var cellId = "collectionCellId"
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Main"
        titleLabel.font = .systemFont(ofSize: 24)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter to search photo"
        textField.font = .systemFont(ofSize: 16)
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configure()
        subscribe()
    }
    
    private func configure() {
        stackView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: stackView.topAnchor, constant: 50),
            titleLabel.heightAnchor.constraint(equalToConstant: 50),
            titleLabel.centerXAnchor.constraint(equalTo: stackView.centerXAnchor)
        ])
        
        stackView.addSubview(searchTextField)
        searchTextField.delegate = self
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            searchTextField.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 10),
            searchTextField.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -10),
            searchTextField.heightAnchor.constraint(equalToConstant: 40),
            searchTextField.centerXAnchor.constraint(equalTo: stackView.centerXAnchor)
        ])
        stackView.addSubview(cancelButton)
        NSLayoutConstraint.activate([
            cancelButton.centerYAnchor.constraint(equalTo: searchTextField.centerYAnchor),
            cancelButton.heightAnchor.constraint(equalToConstant: 40),
            cancelButton.trailingAnchor.constraint(equalTo: searchTextField.trailingAnchor, constant: -20)
        ])
        self.view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        configureCollectionView()
    }
    
    private func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = sectionInsets
        
        collectionView = UICollectionView(
            frame: CGRect(x: 0, y: 200, width: self.view.frame.width, height: self.view.frame.height - 200),
            collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MainCollectionCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.backgroundColor = UIColor.white
        self.view.addSubview(collectionView)
//        viewModel.getRequest()
        viewModel.photoArray
            .bind(onNext: { [collectionView] _ in
                collectionView?.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    private func subscribe() {
        searchTextField
            .rx
            .text
            .orEmpty
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .bind(onNext: { [weak self] text in
                guard let self = self, !text.isEmpty else { return }
                self.viewModel.searchPhoto(with: text)
            })
            .disposed(by: disposeBag)
        
        cancelButton
            .rx
            .tap
            .bind(onNext: { [weak self] _ in
                guard let self = self,
                      !(self.searchTextField.text?.isEmpty ?? false) else { return }
                self.searchTextField.text = ""
                self.viewModel.getRequest()
            })
            .disposed(by: disposeBag)
    }
}

extension MainViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.photoArray.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? MainCollectionCell else {
            return MainCollectionCell()
        }
        cell.configureCell(with: viewModel.photoArray.value[indexPath.item])
        return cell
    }
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = DetailViewController()
        detailVC.configure(with: viewModel.photoArray.value[indexPath.item])
        self.present(detailVC, animated: true)
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingWidth = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = collectionView.frame.width - paddingWidth
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
}
