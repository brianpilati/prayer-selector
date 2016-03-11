//
//  ViewController.swift
//  Prayer Selector
//
//  Created by Brian Pilati on 3/10/16.
//  Copyright © 2016 Brian Pilati. All rights reserved.
//


import UIKit
import GameplayKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var timer: NSTimer!
    var collectionView: UICollectionView?
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    var hoursButton: UIButton = UIButton()
    
    var originalPeople: [AnyObject] = ["Ammon", "Levi", "Abby", "Dylan", "Jaden", "Lea", "Brynn", "Madeline", "Jayelyn", "Jordan", "Brother Hales", "Sister Hales"]
    
    var people: [AnyObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.people = self.originalPeople
        
        let columns: CGFloat = 3
        let cellSpacing: CGFloat = 5
        screenSize = UIScreen.mainScreen().bounds
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        
        self.view.backgroundColor = UIColor.whiteColor()
    
        // Do any additional setup after loading the view, typically from a nib
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: cellSpacing, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: screenWidth/columns - cellSpacing, height: screenWidth/columns)
        layout.minimumInteritemSpacing = cellSpacing
        layout.minimumLineSpacing = cellSpacing
        
        let collectionViewHeight = (screenWidth / columns + cellSpacing) * 4 + cellSpacing
        
        let yOffset: CGFloat = 50
        let frame = CGRectMake(0, yOffset, self.view.frame.width, collectionViewHeight)
        collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView!.dataSource = self
        collectionView!.delegate = self
        collectionView!.registerClass(PersonCollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
        collectionView!.backgroundColor = UIColor.greenColor()
        self.view.addSubview(collectionView!)
        
        
        self.hoursButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.hoursButton.backgroundColor = UIColor(red: 38.0/255.0, green: 106.0/255.0, blue: 46.0/255.0, alpha: 1.0)
        self.hoursButton.frame = CGRectMake(50, collectionViewHeight + yOffset + 5, self.view.bounds.width/2, 100)
        self.hoursButton.titleLabel!.font =  UIFont(name: "Arial-BoldMt", size: 40)
        self.hoursButton.layer.borderWidth = 5
        self.hoursButton.layer.borderColor = UIColor.blackColor().CGColor
        self.hoursButton.addTarget(self, action: "startSelectionProcess:", forControlEvents: .TouchUpInside)
        self.hoursButton.setContentHuggingPriority(UILayoutPriorityDefaultLow, forAxis: UILayoutConstraintAxis.Vertical)
        self.hoursButton.layer.cornerRadius = self.view.bounds.width/25
        
        
        self.hoursButton.setTitle("Select", forState: .Normal)
        self.hoursButton.backgroundColor = UIColor.greenColor()
        self.view.addSubview(hoursButton)
    }
    
    func startSelectionProcess(sender: UIButton) {
        self.people = self.originalPeople
        timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "selectPerson", userInfo: nil, repeats: true)
    }
    
    func colorCell() {
        let indexPath: NSIndexPath = NSIndexPath(forItem: 0, inSection: 0)
        let cell = collectionView!.cellForItemAtIndexPath(indexPath)
        cell?.backgroundColor = UIColor.redColor()
        timer?.invalidate()
    }
    
    func selectPerson() {
        self.people = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(self.people)
        self.people.removeLast()
        self.collectionView?.reloadData()
        
        if( self.people.count == 1) {
            timer?.invalidate()
            timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "colorCell", userInfo: nil, repeats: false)
        }
    }
    
    // tell the collection view how many cells to make
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.people.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        print("coloring")
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionViewCell", forIndexPath: indexPath) as! PersonCollectionViewCell
        cell.layer.borderColor = UIColor.blackColor().CGColor
        cell.layer.cornerRadius = 25;
        cell.layer.borderWidth = 0.5
        cell.frame.size.width = screenWidth / 3
        cell.frame.size.height = screenWidth / 3
        
        cell.myLabel.text = self.people[indexPath.item] as? String
        cell.backgroundColor = UIColor.yellowColor() // make cell more visible in our example project
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        cell?.backgroundColor = UIColor.redColor()
    }
    
    // change background color back when user releases touch
    func collectionView(collectionView: UICollectionView, didUnhighlightItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        cell?.backgroundColor = UIColor.yellowColor()
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}