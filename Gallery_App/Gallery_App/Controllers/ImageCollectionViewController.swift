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
        setupUpdateView()
        viewModel.fetchImages()
        setupLayout()
        setupCollectionView()
    }
    
    private func setupUpdateView() {
        viewModel.updateView = {
            self.collectionView.reloadData()
        }
    }
    
    private func setupLayout() {
        layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: view.frame.width/3 - 2, height: view.frame.width/3 - 2)
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 2
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
        viewModel.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageViewCell
        let imageUrlString = viewModel.images[indexPath.item].urls.regular
        cell.loadImage(with: imageUrlString)
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
}
