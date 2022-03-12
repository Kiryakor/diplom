//
//  SimularView.swift
//  Diplom
//
//  Created by KIRILL on 11.03.2022.
//

import UIKit

class SimularView: UIView,
                   UICollectionViewDelegate,
                   UICollectionViewDataSource,
                   UICollectionViewDelegateFlowLayout {
    
    private enum Constants {
        static let spacing: CGFloat = 8
    }
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = Constants.spacing
        layout.minimumInteritemSpacing = Constants.spacing
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.register(InfoViewCell.self, forCellWithReuseIdentifier: "cell")
        return view
    }()
    
    var images: [String]? = [] {
        willSet {
            self.collectionView.reloadData()
        }
    }
    
    init() {
        super.init(frame: .zero)

        self.addSubviews([self.collectionView])
        
        self.collectionView.snp.makeConstraints { make in
            make.left.right.equalTo(self).inset(Constants.spacing)
            make.top.bottom.equalTo(self)
        }
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        let request = "sobor1.jpg"
        FirebaseService.requestImage(with: request) { result in
            switch result {
            case .success(let data):
                print(data)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return self.images?.count ?? 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! InfoViewCell
        cell.clipsToBounds = true
        cell.layer.cornerRadius = 10
        cell.imageName = self.images?[indexPath.row] ?? nil
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width - Constants.spacing
        return CGSize(width: width / 2 , height: width / 2)
    }
}
