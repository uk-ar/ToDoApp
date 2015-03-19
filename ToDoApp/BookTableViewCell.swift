//
//  TodoTableViewCell.swift
//  todoapp
//
//  Created by Hirose Tatsuya on 2014/07/06.
//  Copyright (c) 2014年 Tatsuya Hirose. All rights reserved.
//

import UIKit

@objc protocol BookTableViewCellDelegate {
    optional func updateBook(index: Int)
    optional func removeBook(index: Int)
}

struct Action {
  static let greenColor :UIColor=UIColor(red: 85.0 / 255.0, green: 213.0 / 255.0, blue: 80.0 / 255.0, alpha: 1.0);
  static let redColor   :UIColor=UIColor(red: 232.0 / 255.0, green: 61.0 / 255.0, blue: 14 / 255.0, alpha: 1.0);
  static let yellowColor:UIColor=UIColor(red: 254.0 / 255.0, green: 217.0 / 255.0, blue: 56.0 / 255.0, alpha: 1.0);
  static let brownColor :UIColor=UIColor(red: 206.0 / 255.0, green: 149.0 / 255.0, blue: 98.0 / 255.0, alpha: 1.0);
  static let checkView:UIView=BookTableViewCell.viewWithImageName("check");
  static let crossView:UIView=BookTableViewCell.viewWithImageName("cross");
  static let clockView:UIView=BookTableViewCell.viewWithImageName("clock");
  static let listView :UIView=BookTableViewCell.viewWithImageName("list");

    let view: UIView!
    let color: UIColor!
    let block: (cell: MCSwipeTableViewCell!, state: MCSwipeTableViewCellState, mode:MCSwipeTableViewCellMode)->()
}

enum GestureDirection {
    case Right
    case LongRight
    case Left
    case LongLeft
    func toCellState() -> MCSwipeTableViewCellState{
        switch self {
        case let .Right:
            return MCSwipeTableViewCellState.State1
        case let .LongRight:
            return MCSwipeTableViewCellState.State2
        case let .Left:
            return MCSwipeTableViewCellState.State3
        case let .LongLeft:
            return MCSwipeTableViewCellState.State4
        }
    }
}

enum BookAlertViewType {
    case Create, Update(Int), Remove(Int)
}

class BookTableViewCell : MCSwipeTableViewCell {
    //var delegate used in parent
    weak var myDelegate: BookTableViewCellDelegate!

    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // self.selectionStyle = .None

        // let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: "showDeleteButton")
        // swipeRecognizer.direction = .Left
        // self.contentView.addGestureRecognizer(swipeRecognizer)

        // self.contentView.addGestureRecognizer(UISwipeGestureRecognizer(target: self, action: "hideDeleteButton"))
    }

    func addGesture(direction: GestureDirection ,action: Action){
        self.setSwipeGestureWithView(
            action.view, color: action.color, mode: .Exit,
            state: direction.toCellState(),
            completionBlock: action.block
        );
    }

    class func viewWithImageName(name: String) -> UIView {
        let image: UIImage? = UIImage(named: name);
        let imageView: UIImageView = UIImageView(image: image);
        imageView.contentMode = UIViewContentMode.Center;
        return imageView;
    }

    func updateBook() {
        myDelegate?.updateBook?(self.tag)
    }

    func removeBook() {
        //let indexPath: NSIndexPath = self.tableView.indexPathForCell(self)!
        //myDelegate?.removeBook?(indexPath.row)
    }
}
