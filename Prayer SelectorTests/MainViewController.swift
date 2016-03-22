//
//  ViewController.swift
//  Prayer Selector
//
//  Created by Brian Pilati on 3/22/16.
//  Copyright © 2016 Brian Pilati. All rights reserved.
//

import UIKit
import XCTest

@testable import Prayer_Selector

class MainViewControllerTest: XCTestCase {
    
    var controller : MainViewController!

    override func setUp() {
        super.setUp()
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        controller = (storyboard.instantiateViewControllerWithIdentifier("MainViewController")) as! MainViewController
        controller.viewDidLoad()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testViewDidLoad() {
        let collectionView = controller.view.viewWithTag(110) as? UICollectionView
        XCTAssertFalse(collectionView!.hidden)
        
        let personSelectButton = controller.view.viewWithTag(111) as? UIButton
        XCTAssert(personSelectButton!.titleLabel?.text == "Ready")
        XCTAssertFalse(personSelectButton!.hidden)
        
        let selectedPerson = controller.view.viewWithTag(112) as? UILabel
        XCTAssertNil(selectedPerson!.text)
        XCTAssertTrue(selectedPerson!.hidden)
        
        let congratulations = controller.view.viewWithTag(113) as? UILabel
        XCTAssert(congratulations!.text == "Congratulations!")
        XCTAssertTrue(congratulations!.hidden)
        
        let appTitle = controller.view.viewWithTag(114) as? UILabel
        XCTAssert(appTitle!.text == "Prayer Selector")
        XCTAssertFalse(appTitle!.hidden)
        
        let imageView = controller.view.viewWithTag(115) as? UIImageView
        XCTAssertNotNil(imageView!.image)
        XCTAssertFalse(imageView!.hidden)
        
        XCTAssert(controller.selectStatus == SelectStatus.ready)
        XCTAssert(personSelectButton?.backgroundColor == UIColor(red: 173.0/255.0, green: 255.0/255.0, blue: 47.0/255.0, alpha: 1.0))
        XCTAssertTrue(personSelectButton!.enabled)
        XCTAssertFalse(personSelectButton!.hidden)
        XCTAssertTrue(selectedPerson!.hidden)
        XCTAssertTrue(congratulations!.hidden)
        XCTAssertFalse(controller.title == "Ready")
    }
    
    func testViewDidLoadValuesWith12Name() {
        XCTAssert(controller.originalPeople.count == 12, "The original people array is wrong - \(controller.originalPeople.count)")
        XCTAssert(controller.originalPeople[0] as! String == "Ammon")
        XCTAssert(controller.people.count == 12)
        
        
        XCTAssert(controller.cellSpacing == 5)
        XCTAssert(controller.cellWidthAndHeight == 187.0, "The cellWidthAndHeight is \(controller.cellWidthAndHeight)")
        XCTAssert(controller.yOffset == 50)
    }
    
    func testViewDidLoadValuesWith2Name() {
        controller.originalPeople = ["Ammon", "Brian"]
        controller.viewDidLoad()
        
        XCTAssert(controller.originalPeople.count == 2, "The original people array is wrong - \(controller.originalPeople.count)")
        XCTAssert(controller.originalPeople[1] as! String == "Brian")
        XCTAssert(controller.people.count == 2)
        XCTAssert(controller.people[1] as! String == "Brian")
        
        XCTAssert(controller.cellSpacing == 5)
        XCTAssert(controller.cellWidthAndHeight == 379.0, "The cellWidthAndHeight is \(controller.cellWidthAndHeight)")
        XCTAssert(controller.yOffset == 50)
    }
    
    func testStatusReady() {
        controller.statusReady()
        
        XCTAssert(controller.selectStatus == SelectStatus.ready)
        XCTAssert(controller.personSelectButton.backgroundColor == UIColor(red: 173.0/255.0, green: 255.0/255.0, blue: 47.0/255.0, alpha: 1.0))
        XCTAssertTrue(controller.personSelectButton.enabled)
        XCTAssertFalse(controller.personSelectButton.hidden)
        XCTAssertTrue(controller.selectedPerson.hidden)
        XCTAssertTrue(controller.congratulations.hidden)
        XCTAssertFalse(controller.title == "Ready")
    }
    
    func testStatusSorting() {
        controller.statusSorting()
        
        XCTAssert(controller.selectStatus == SelectStatus.sorting)
        XCTAssert(controller.personSelectButton.backgroundColor == UIColor.lightGrayColor())
        XCTAssertFalse(controller.personSelectButton.enabled)
        XCTAssertFalse(controller.personSelectButton.hidden)
        XCTAssertTrue(controller.selectedPerson.hidden)
        XCTAssertTrue(controller.congratulations.hidden)
        XCTAssertFalse(controller.title == "Sorting")
    }
    
    func testStatusReset() {
        controller.statusReset()
        
        XCTAssert(controller.selectStatus == SelectStatus.reset)
        XCTAssert(controller.personSelectButton.backgroundColor == UIColor.redColor())
        XCTAssertTrue(controller.personSelectButton.enabled)
        XCTAssertFalse(controller.personSelectButton.hidden)
        XCTAssertTrue(controller.selectedPerson.hidden)
        XCTAssertTrue(controller.congratulations.hidden)
        XCTAssertFalse(controller.title == "Reset")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }

    
    
}