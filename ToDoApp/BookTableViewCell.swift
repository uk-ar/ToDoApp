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
    optional func moveBook(index: Int)
}

struct Action {
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

class BookTableViewCell : MCSwipeTableViewCell {
    //var delegate used in parent
    weak var myDelegate: BookTableViewCellDelegate?
    var checkAction :Action
    var crossAction :Action
    var clockAction :Action
    var listAction :Action

    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        let greenColor = UIColor(red: 85.0 / 255.0, green: 213.0 / 255.0, blue: 80.0 / 255.0, alpha: 1.0);
        let redColor   = UIColor(red: 232.0 / 255.0, green: 61.0 / 255.0, blue: 14 / 255.0, alpha: 1.0);
        let yellowColor = UIColor(red: 254.0 / 255.0, green: 217.0 / 255.0, blue: 56.0 / 255.0, alpha: 1.0);
        let brownColor = UIColor(red: 206.0 / 255.0, green: 149.0 / 255.0, blue: 98.0 / 255.0, alpha: 1.0);

        let checkView = BookTableViewCell.viewWithImageName("check");
        let crossView = BookTableViewCell.viewWithImageName("cross");
        let clockView = BookTableViewCell.viewWithImageName("clock");
        let listView  = BookTableViewCell.viewWithImageName("list");

        self.checkAction =
            Action(view: checkView, color: greenColor){
            (cell: MCSwipeTableViewCell!, state: MCSwipeTableViewCellState, mode:MCSwipeTableViewCellMode) in
            println("Did swipe \"Checkmark\" cell")
        }

        self.crossAction = Action(view: crossView, color: redColor){
            (cell: MCSwipeTableViewCell!, state: MCSwipeTableViewCellState, mode:MCSwipeTableViewCellMode) in
            println("Did swipe \"Cross\" cell")
        }

        self.clockAction = Action(view: clockView, color: yellowColor){
            (cell: MCSwipeTableViewCell!, state: MCSwipeTableViewCellState, mode:MCSwipeTableViewCellMode) in
            println("Did swipe \"Clock\" cell")
        }

        self.listAction = Action(view: listView, color: brownColor){
            (cell: MCSwipeTableViewCell!, state: MCSwipeTableViewCellState, mode:MCSwipeTableViewCellMode) in
            println("Did swipe \"List\" cell")
        }
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

    func moveBook() {
        myDelegate?.moveBook?(self.tag)
    }
}
