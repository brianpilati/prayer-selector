//
//  PersonCollectionViewCell.swift
//  Prayer Selector
//
//  Created by Brian Pilati on 3/10/16.
//  Copyright © 2016 Brian Pilati. All rights reserved.
//

import UIKit

class PersonCollectionViewCell: UICollectionViewCell {
    let myLabel: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        myLabel.textAlignment = NSTextAlignment.Center
        contentView.addSubview(myLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
