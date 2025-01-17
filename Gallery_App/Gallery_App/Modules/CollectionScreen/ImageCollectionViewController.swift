//
//  ViewController.swift
//  Gallery_App
//
//  Created by Vlad Klunduk on 28/11/2024.
//

import UIKit

final class ImageCollectionViewController: UIViewController {
    var viewModel: ImageCollectionViewModelProtocol?
    private var collectionView: UICollectionView?
    private var layout: UICollectionViewFlowLayout?
    private let buttonImageName = "heart"
    private let buttonFilledImageName = "heart.fill"

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.fetchImages()
        setupCollectionViewLayout()
        setupCollectionView()
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.updateFavouriteImages()
        collectionView?.reloadData()
        updateHeartBarButtonItemImage()
    }
    
    private func setupCollectionViewLayout() {
        layout = UICollectionViewFlowLayout()
        layout?.scrollDirection = .vertical
        layout?.itemSize = CGSize(width: view.frame.width/3 - 1, height: view.frame.width/3 - 1)
        layout?.minimumLineSpacing = 1
        layout?.minimumInteritemSpacing = 1
    }
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout!)
        collectionView?.register(ImageViewCell.self, forCellWithReuseIdentifier: ImageViewCell.identifier)
        collectionView?.dataSource = self
        collectionView?.delegate = self
        collectionView?.frame = view.bounds
        view.addSubview(collectionView!)
    }
    
    private func setupNavigationBar() {
        title = "Gallery"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: buttonImageName), style: .plain, target: self, action: #selector(heartButtonPressed))
    }
    
    private func updateHeartBarButtonItemImage() {
        if viewModel?.showFavouriteImages ?? false {
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: buttonFilledImageName)
        } else {
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: buttonImageName)
        }
    }
    
    @objc private func heartButtonPressed() {
        viewModel?.showFavouriteImages.toggle()
        collectionView?.reloadData()
        updateHeartBarButtonItemImage()
    }
}

extension ImageCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel?.getImages().count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageViewCell.identifier, for: indexPath) as! ImageViewCell
        guard let imageUrlString = viewModel?.getImages()[indexPath.item].urls.thumb else { return cell }
        cell.loadImage(with: imageUrlString)
        if viewModel?.isImageFavourite(indexPath) ?? false {
            cell.markAsFavourite()
        } else {
            cell.removeFavouriteMark()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let images = viewModel?.getImages() else { return }
        let vm = ImageDetailsViewModel(images: images, imageIndex: indexPath.item)
        let vc = ImageDetailsViewController()
        vc.viewModel = vm
        vm.delegate = vc
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        viewModel?.loadNextPage(indexPath)
        viewModel?.fetchImages()
    }
}

extension ImageCollectionViewController: ImageCollectionViewModelDelegate {
    func insertItems(_ indexPaths: [IndexPath]) {
        collectionView?.insertItems(at: indexPaths)
    }
    
    func showAlert(_ error: any Error) {
        let ac = UIAlertController(title: "Loading error", message: error.localizedDescription, preferredStyle: .alert)
        let reloadAction = UIAlertAction(title: "Reload", style: .default) { _ in
            self.viewModel?.reloadData()
            self.collectionView?.reloadData()
            self.viewModel?.fetchImages()
        }
        let okAction = UIAlertAction(title: "Ok", style: .default)
        ac.addAction(reloadAction)
        ac.addAction(okAction)
        present(ac, animated: true)
    }
}

protocol ImageCollectionViewModelDelegate: AnyObject {
    func insertItems(_ indexPaths: [IndexPath])
    func showAlert(_ error: Error)
}
