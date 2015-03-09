//
//  bookDataSource.swift
//  bookapp
//
//  Created by Hirose Tatsuya on 2014/07/06.
//  Copyright (c) 2014年 Tatsuya Hirose. All rights reserved.
//

import UIKit

struct Book {
    var title : String
}

class BookDataManager {
    
    let STORE_KEY = "BookDataManager.store_key"
    
    class var sharedInstance : BookDataManager {
        struct Static {
            static let instance : BookDataManager = BookDataManager()
        }
        return Static.instance
    }
    
    var books: [Book]
    
    var size : Int {
        return books.count
    }
    
    subscript(index: Int) -> Book {
        return books[index]
    }
    
    init() {
        let defaults = NSUserDefaults.standardUserDefaults()
        if let data = defaults.objectForKey(self.STORE_KEY) as? [String] {
            self.books = data.map { title in
                Book(title: title)
            }
        } else {
            self.books = [
                Book(title: "foo"),
                Book(title: "bar"),
                Book(title: "baz")
            ]
        }
    }
    
    class func validate(book: Book!) -> Bool {
        return book.title != ""
    }
    
    func save() {
        let defaults = NSUserDefaults.standardUserDefaults()
        let data = self.books.map { book in
            book.title
        }
        defaults.setObject(data, forKey: self.STORE_KEY)
        defaults.synchronize()
    }
    
    func create(book: Book!) -> Bool {
        if BookDataManager.validate(book) {
            self.books.insert(book, atIndex: 0)
            //self.books.append(book)
            self.save()
            return true
        }
        return false
    }
    
    func update(book: Book!, at index: Int) -> Bool {
        if (index >= self.books.count) {
            return false
        }
        
        if BookDataManager.validate(book) {
            self.books[index] = book
            self.save()
            return true
        }
        return false
    }
    
    func remove(index: Int) -> Book? {
        if (index >= self.books.count) {
            return nil
        }
        let target = self.books[index]
        self.books.removeAtIndex(index)
        self.save()
        
        return target
    }
}
