//
//  ViewController.swift
//  Gallery_App
//
//  Created by Vlad Klunduk on 28/11/2024.
//

import UIKit

final class ImageCollectionViewController: UIViewController {
    var viewModel: ImageCollectionViewModelProtocol!
    private var collectionView: UICollectionView!
    private var layout: UICollectionViewFlowLayout!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Gallery"
        viewModel.fetchImages()
        setupLayout()
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    private func setupLayout() {
        layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: view.frame.width/3 - 1, height: view.frame.width/3 - 1)
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
    }
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        collectionView.register(ImageViewCell.self, forCellWithReuseIdentifier: "ImageCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        view = collectionView
    }
}

extension ImageCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.getImagesCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageViewCell
        let imageUrlString = viewModel.getImageUrl(indexPath)
        cell.loadImage(with: imageUrlString)
        if viewModel.isImageFavourite(indexPath) {
            cell.markAsFavourite()
        } else {
            cell.removeFavouriteMark()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ImageDetailsViewController()
        let vm = ImageDetailsViewModel()
        vc.viewModel = vm
        vm.delegate = vc
        vm.setImages(viewModel.getImages())
        vm.setImageIndex(indexPath.item)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        viewModel.loadNextPage(indexPath)
    }
}

extension ImageCollectionViewController: ImageCollectionViewModelDelegate {
    func insertItems(_ indexPaths: [IndexPath]) {
        collectionView.insertItems(at: indexPaths)
    }
    
    func showAlert(_ error: any Error) {
        let ac = UIAlertController(title: "Loading error", message: error.localizedDescription, preferredStyle: .alert)
        let reloadAction = UIAlertAction(title: "Reload", style: .default) { _ in
            self.viewModel.reloadView()
            self.collectionView.reloadData()
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
