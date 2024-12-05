//
//  ViewController.swift
//  Gallery_App
//
//  Created by Vlad Klunduk on 28/11/2024.
//

import UIKit

class ImageCollectionViewController: UIViewController {
    var viewModel: ImageCollectionViewModel!
    private var collectionView: UICollectionView!
    private var layout: UICollectionViewFlowLayout!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = ImageCollectionViewModel()
        setupInsertItems()
        viewModel.fetchImages()
        setupLayout()
        setupCollectionView()
        setupShowAlert()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    private func setupInsertItems() {
        viewModel.insertItems = { array in
            self.collectionView.insertItems(at: array)
        }
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
    
    func setupShowAlert() {
        viewModel.showAlert = { error in
            let ac = UIAlertController(title: "Loading error", message: error.localizedDescription, preferredStyle: .alert)
            let reloadAction = UIAlertAction(title: "Reload", style: .default) { _ in
                self.viewModel.reloadView()
                self.collectionView.reloadData()
            }
            let okAction = UIAlertAction(title: "Ok", style: .default)
            ac.addAction(reloadAction)
            ac.addAction(okAction)
            self.present(ac, animated: true)
        }
    }
}

extension ImageCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageViewCell
        let imageUrlString = viewModel.images[indexPath.item].urls.thumb
        cell.loadImage(with: imageUrlString)
        if viewModel.isImageFavourite(indexPath) {
            cell.markAsFavourite()
        } else {
            cell.removeFavouriteMark()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let imageUrlString = viewModel.images[indexPath.item].urls.regular
        let vc = ImageDetailsViewController()
        let vm = ImageDetailsViewModel()
        vm.images = viewModel.images
        vm.imageIndex = indexPath.item
        vm.fetchImage(imageUrlString)
        vc.viewModel = vm
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        viewModel.loadNextPage(indexPath)
    }
}
