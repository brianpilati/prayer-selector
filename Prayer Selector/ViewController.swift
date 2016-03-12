//
//  ViewController.swift
//  Prayer Selector
//
//  Created by Brian Pilati on 3/10/16.
//  Copyright © 2016 Brian Pilati. All rights reserved.
//


import UIKit
import GameplayKit
import Darwin

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var timer: NSTimer!
    var collectionView: UICollectionView?
    var screenSize: CGRect!
    var screenHeight: CGFloat!
    var personSelectButton: UIButton = UIButton()
    let cellSpacing: CGFloat = 5
    var cellWidthAndHeight: CGFloat = 0
    
    enum SelectStatus{
        case ready
        case sorting
        case reset
    }
    
    var selectStatus: SelectStatus!
    
    var deletedPerson: AnyObject!
    
    var originalPeople: [AnyObject] = ["Ammon", "Levi", "Abby", "Dylan", "Jaden", "Lea", "Brynn", "Madeline", "Jayelyn", "Jordan", "Brother Hales", "Sister Hales"]
    
    var people: [AnyObject] = []
    let yOffset: CGFloat = 50
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.people = self.originalPeople
        
        screenSize = UIScreen.mainScreen().bounds
        screenHeight = screenSize.height
        
        calculateCellSize()
        view.backgroundColor = UIColor.whiteColor()
        
        // Do any additional setup after loading the view, jtypically from a nib
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .Vertical
        layout.sectionInset = UIEdgeInsets(top: cellSpacing, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: cellWidthAndHeight, height: cellWidthAndHeight)
        layout.minimumInteritemSpacing = cellSpacing
        layout.minimumLineSpacing = cellSpacing
        
        
        let frame = CGRectMake(0, yOffset, self.view.frame.width, calculateCollectionHeight())
        collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView!.dataSource = self
        collectionView!.delegate = self
        collectionView!.registerClass(PersonCollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
        collectionView!.backgroundColor = UIColor.clearColor()
        self.view.addSubview(collectionView!)
        addBackgroundImage()
        
        self.personSelectButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.personSelectButton.frame = CGRectMake(calculateButtonCenter(), calculateButtonYOffset(), calculateButtonWidth(), 100)
        self.personSelectButton.titleLabel!.font =  UIFont(name: "Arial-BoldMt", size: 40)
        self.personSelectButton.layer.borderWidth = 2
        self.personSelectButton.layer.borderColor = UIColor.blackColor().CGColor
        self.personSelectButton.addTarget(self, action: "startSelectionProcess:", forControlEvents: .TouchUpInside)
        self.personSelectButton.setContentHuggingPriority(UILayoutPriorityDefaultLow, forAxis: UILayoutConstraintAxis.Vertical)
        self.personSelectButton.layer.cornerRadius = self.view.bounds.width/25
        
        
        self.statusReady()
        self.view.addSubview(personSelectButton)
    }
    
    func addBackgroundImage() {
        let width = collectionView!.bounds.size.width
        let height = collectionView!.bounds.size.height
        
        let imageViewBackground = UIImageView(frame: CGRectMake(0, 50, width, height))
        imageViewBackground.image = UIImage(named: "angelMoroni.jpg")
        
        // you can change the content mode:
        imageViewBackground.contentMode = UIViewContentMode.ScaleAspectFit
        
        view.addSubview(imageViewBackground)
        view.sendSubviewToBack(imageViewBackground)
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }

    func getCellWidth(columns: Int) -> CGFloat {
        return view.bounds.width / CGFloat(columns) - cellSpacing
    }
    
    func getEstimatedCollectionHeight(cellWidth: CGFloat, rows: Int) -> CGFloat {
        return cellWidth * CGFloat(rows)
    }
    
    func calculateCellSize() {
        var isContinue = true
        var columns = 0
        
        while (isContinue == true) {
            columns++
            let rows = ceil(Float(originalPeople.count / columns))
            cellWidthAndHeight = getCellWidth(columns)
            
            if (getEstimatedCollectionHeight(cellWidthAndHeight, rows: Int(rows)) < calculateCollectionHeight() || columns > 10) {
                isContinue = false
            }
        }
    }
    
    func calculateCollectionHeight() -> CGFloat {
        return screenHeight - (yOffset + 120)
    }
    
    func calculateButtonYOffset() -> CGFloat {
        return calculateCollectionHeight() + yOffset + 10
    }
    
    func calculateButtonCenter() -> CGFloat {
        return calculateButtonWidth() - calculateButtonWidth() / 2
    }
    
    func calculateButtonWidth() -> CGFloat {
        return self.view.bounds.width/2
    }
    
    func configureSelectButton() {
        var title: String!
        if (self.selectStatus == SelectStatus.ready) {
            self.personSelectButton.backgroundColor = UIColor(red: 173.0/255.0, green: 255.0/255.0, blue: 47.0/255.0, alpha: 1.0)
            self.personSelectButton.enabled = true
            title = "Ready"
        } else if (self.selectStatus == SelectStatus.sorting) {
            self.personSelectButton.enabled = false
            self.personSelectButton.backgroundColor = UIColor.lightGrayColor()
            title = "Sorting"
        } else if (self.selectStatus == SelectStatus.reset) {
            self.personSelectButton.enabled = true
            self.personSelectButton.backgroundColor = UIColor.redColor()
            title = "Reset"
        }
        
        self.personSelectButton.setTitle(title, forState: .Normal)
    }
    
    func statusReady() {
        self.selectStatus = SelectStatus.ready
        self.configureSelectButton()
    }
    
    func statusReset() {
        self.selectStatus = SelectStatus.reset
        self.configureSelectButton()
    }
    
    func statusSorting() {
        self.selectStatus = SelectStatus.sorting
        self.configureSelectButton()
    }
    
    func shuffle() {
        self.people = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(self.people)
    }
    
    func resetList() {
        self.people = self.originalPeople
        self.shuffle()
        self.collectionView?.reloadData()
        self.statusReady()
    }
    
    func startSelectionProcess(sender: UIButton) {
        if (self.selectStatus == SelectStatus.ready) {
            statusSorting()
            timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "selectPerson", userInfo: nil, repeats: true)
        } else {
            self.resetList()
        }
    }
    
    func colorCell() {
        let indexPath: NSIndexPath = NSIndexPath(forItem: 0, inSection: 0)
        let cell = collectionView!.cellForItemAtIndexPath(indexPath) as! PersonCollectionViewCell
        cell.backgroundColor = UIColor(red: 173.0/255.0, green: 255.0/255.0, blue: 47.0/255.0, alpha: 1.0)
        cell.myLabel.textColor = UIColor.whiteColor()
        cell.myLabel.font = UIFont(name: "Arial-BoldMt", size: 60)
        cell.myLabel.adjustsFontSizeToFitWidth = true
        timer?.invalidate()
        self.statusReset()
    }
    
    func selectPerson() {
        self.shuffle()
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
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionViewCell", forIndexPath: indexPath) as! PersonCollectionViewCell
        cell.layer.borderColor = UIColor.blackColor().CGColor
        cell.layer.cornerRadius = 25;
        cell.layer.borderWidth = 2
        cell.frame.size.width = cellWidthAndHeight
        cell.frame.size.height = cellWidthAndHeight
        
        cell.myLabel.text = self.people[indexPath.item] as? String
        cell.backgroundColor = UIColor(red: 255.0/255.0, green: 228.0/255.0, blue: 181.0/255.0, alpha: 0.75)
        cell.myLabel.textColor = UIColor.blackColor()
        cell.myLabel.font = UIFont(name: "Arial-BoldMt", size: 24)
        cell.myLabel.frame.size.width = cellWidthAndHeight - 4
        cell.myLabel.frame.size.height = cellWidthAndHeight
        cell.myLabel.adjustsFontSizeToFitWidth = true
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        cell?.backgroundColor = UIColor.redColor()
    }
    
    func collectionView(collectionView: UICollectionView, didUnhighlightItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        cell?.backgroundColor = UIColor.yellowColor()
    }
    
    // MARK: - UICollectionViewDelegate protocol
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let person = people[indexPath.item]
        let title = "Remove"
        let message = "Do you want to remove \(person)?"
        let alertView: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alertView.addAction(UIAlertAction(title: "Continue", style: .Default, handler: { (alertAction) -> Void in self.deletePerson(indexPath.item) }))
        alertView.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        presentViewController(alertView, animated: true, completion: nil)
    }
    
    func deletePerson(index: Int) {
        deletedPerson = people.removeAtIndex(index)
        self.collectionView?.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    func undoPerson() {
        people.append(deletedPerson)
        self.collectionView?.reloadData()
        deletedPerson = nil
    }

    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent!) {
        if(event.subtype == UIEventSubtype.MotionShake) {
            if (deletedPerson != nil) {
                let title = "Undo"
                let message = "Do you want to add \(deletedPerson)?"
                let alertView: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
                alertView.addAction(UIAlertAction(title: "Continue", style: .Default, handler: { (alertAction) -> Void in self.undoPerson() }))
                alertView.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
                presentViewController(alertView, animated: true, completion: nil)
            }
        }
    }
}