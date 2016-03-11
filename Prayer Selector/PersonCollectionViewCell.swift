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
        
        myLabel.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width/3, UIScreen.mainScreen().bounds.width/3)
        myLabel.textAlignment = NSTextAlignment.Center
        contentView.addSubview(myLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        print("oops")
        fatalError("init(coder:) has not been implemented")
    }
}
