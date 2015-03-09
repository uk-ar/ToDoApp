//
//  TodoListViewController.swift
//  todoapp
//
//  Created by Hirose Tatsuya on 2014/07/06.
//  Copyright (c) 2014年 Tatsuya Hirose. All rights reserved.
//

import UIKit

enum TodoAlertViewType {
    case Create, Update(Int), Remove(Int)
}

class TodoTableViewController : UIViewController {
    
    var books = BookDataManager.sharedInstance
    
    var alert : UIAlertController?
    var alertType : TodoAlertViewType?
    
    var tableView : UITableView?
    
    override init() {
        super.init()
        
        // Viewの背景色をCyanに設定する.
        //self.view.backgroundColor = UIColor.cyanColor()
        self.view.backgroundColor = UIColor.whiteColor()
        
        //tabBarItemのアイコンをFeaturedに、タグを1と定義する.
        self.tabBarItem = UITabBarItem(tabBarSystemItem: UITabBarSystemItem.Featured, tag: 1)
    }
    
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
        
        // TableViewの生成する(status barの高さ分ずらして表示).
        //let myTableView: UITableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight))
        let header = UIImageView(frame: CGRect(x: 0, y: 0, width: displayWidth, height: 64))
        header.image = UIImage(named:"header")
        header.userInteractionEnabled = true
        
        let title = UILabel(frame: CGRect(x: 10, y: 20, width: displayWidth-10, height: 44))
        //let title = UILabel(frame: CGRect(x: 10, y: barHeight, width: displayWidth-10, height: 44))
        title.text = "Todoリスト🐶🐮"
        header.addSubview(title)
        
        let button = UIButton.buttonWithType(.System) as UIButton
        button.frame = CGRect(x: 320 - 50, y: 20, width: 50, height: 44)
        //button.frame = CGRect(x: displayWidth - 50, y: 20, width: 50, height: 44)
        button.setTitle("追加", forState: .Normal)
        button.addTarget(self, action:"showCreateView", forControlEvents: .TouchUpInside)
        header.addSubview(button)
        
        let screenWidth = UIScreen.mainScreen().bounds.size.height
        //println(displayWidth,displayHeight,screenWidth)
        self.tableView = UITableView(frame: CGRect(x: 0, y: 60, width: displayWidth, height: screenWidth - 60))
        //self.tableView = UITableView(frame: CGRect(x: 0, y: 60, width: displayWidth, height: screenWidth - 60))
        //self.tableView = UITableView(frame: CGRect(x: 0, y: 60, width: 320, height: screenWidth))
        self.tableView!.dataSource = self
        
        self.view.addSubview(self.tableView!)
        self.view.addSubview(header)
    }
    
    func showCreateView() {
        
        self.alertType = TodoAlertViewType.Create
        
        self.alert = UIAlertController(title: "Todoを追加する", message: nil, preferredStyle: .Alert)
        
        self.alert!.addTextFieldWithConfigurationHandler({ textField in
            textField.delegate = self
            textField.returnKeyType = .Done
        })
        
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        self.alert!.addAction(okAction)
        
        self.presentViewController(self.alert!, animated: true, completion: nil)
    }
    
}

extension TodoTableViewController : UITextFieldDelegate {
    func textFieldShouldEndEditing(textField: UITextField!) -> Bool {
        
        if let type = self.alertType {
            switch type {
            case .Create:
                let todo = Book(title: textField.text)
                if self.books.create(todo) {
                    textField.text = nil
                    self.tableView!.reloadData()
                }
            case let .Update(index):
                let todo = Book(title: textField.text)
                if self.books.update(todo, at:index) {
                    textField.text = nil
                    self.tableView!.reloadData()
                }
            case let .Remove(index):
                break
            }
        }
        
        self.alert!.dismissViewControllerAnimated(false, completion: nil)
        return true
    }
}

extension TodoTableViewController : TodoTableViewCellDelegate {
    
    func updateTodo(index: Int) {
        self.alertType = TodoAlertViewType.Update(index)
        
        self.alert = UIAlertController(title: "編集", message: nil, preferredStyle: .Alert)
        self.alert!.addTextFieldWithConfigurationHandler({ textField in
            textField.text = self.books[index].title
            textField.delegate = self
            textField.returnKeyType = .Done
        })
        
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        self.alert!.addAction(okAction)
        
        self.presentViewController(self.alert!, animated: true, completion: nil)
    }
    
    func removeTodo(index: Int) {
        self.alertType = TodoAlertViewType.Remove(index)
        
        self.alert = UIAlertController(title: "削除", message: nil, preferredStyle: .Alert)
        self.alert!.addAction(UIAlertAction(title: "Delete", style: .Destructive) { action in
            self.books.remove(index)
            self.tableView!.reloadData()
            })
        self.alert!.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        self.presentViewController(self.alert!, animated: true, completion: nil)
    }
}

extension TodoTableViewController : UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.books.size
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = TodoTableViewCell(style: .Default, reuseIdentifier: nil)
        cell.delegate = self
        
        cell.textLabel?.text = self.books[indexPath.row].title
        cell.tag = indexPath.row
        
        return cell
    }
}