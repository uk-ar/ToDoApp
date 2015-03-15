//
//  ViewController.swift
//  UIKit037
//

import UIKit

class SegmentedViewController: UIViewController {

    let mySegLabel: UILabel = UILabel(frame: CGRectMake(0,0,150,150))

    override init() {
        super.init()
        self.tabBarItem = UITabBarItem(tabBarSystemItem: UITabBarSystemItem.Featured, tag: 1)
    }

    // required for protocol NSCoding
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    required override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Status Barの高さを取得する.
        let barHeight: CGFloat = UIApplication.sharedApplication().statusBarFrame.size.height

        // Viewの高さと幅を取得する.
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height

        // 表示する配列を作成する.
        let myArray: NSArray = ["Red","Blue","Green"]

        // SegmentedControlを作成する.
        let mySegcon: UISegmentedControl = UISegmentedControl(items: myArray)

        mySegcon.center = CGPoint(x: displayWidth/2, y: 400)
        mySegcon.backgroundColor = UIColor.grayColor()
        mySegcon.tintColor = UIColor.whiteColor()

        // イベントを追加する.
        mySegcon.addTarget(self, action: "segconChanged:", forControlEvents: UIControlEvents.ValueChanged)

        // Viewに追加する.
        self.view.addSubview(mySegcon)

        // Labelを作成する.
        mySegLabel.backgroundColor = UIColor.whiteColor()
        mySegLabel.layer.masksToBounds = true
        mySegLabel.layer.cornerRadius = 75.0
        mySegLabel.textColor = UIColor.whiteColor()
        mySegLabel.shadowColor = UIColor.grayColor()
        mySegLabel.font = UIFont.systemFontOfSize(CGFloat(30))
        mySegLabel.textAlignment = NSTextAlignment.Center
        mySegLabel.layer.position = CGPoint(x: self.view.bounds.width/2,y: 200)

        // Viewの背景色をCyanにする.
        self.view.backgroundColor = UIColor.cyanColor()

        // Viewに追加する.
        self.view.addSubview(mySegLabel);
    }

    func segconChanged(segcon: UISegmentedControl){

        switch(segcon.selectedSegmentIndex){
        case 0:
            mySegLabel.backgroundColor = UIColor.redColor()

        case 1:
            mySegLabel.backgroundColor = UIColor.blueColor()

        case 2:
            mySegLabel.backgroundColor = UIColor.greenColor()

        default:
            println("Error")

        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
