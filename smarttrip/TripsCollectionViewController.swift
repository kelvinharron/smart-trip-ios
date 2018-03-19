//
//  TripsCollectionViewController.swift
//  smarttrip
//
//  Created by Kelvin Harron on 19/03/2018.
//  Copyright © 2018 Kelvin Harron. All rights reserved.
//

import UIKit

class TripsCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private let reuseIdentifier = "Cell"
    private let trips = ["Weekend in Dublin", "Bavarian Road Tour"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(TripCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let customCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TripCell
        customCell.triplabel.text = trips[indexPath.item]
        return customCell
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ colmlectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 150)
    }
}

class TripCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    var triplabel: UILabel = {
        let label = UILabel()
        label.text = "My Trip"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
  
    
    private func setupViews() {
        backgroundColor = UIColor.lightGray
        addSubview(triplabel)
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : triplabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : triplabel]))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder: has not been implemented")
    }
    

}
