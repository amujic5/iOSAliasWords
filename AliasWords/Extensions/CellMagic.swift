//
//  CellMagic.swift
//  Tvm
//
//  Created by Azzaro Mujic on 23/03/16.
//  Copyright © 2016 Infinum. All rights reserved.
//

import UIKit

extension UIViewController {
    static var identifier: String {
        return String(describing: self)
    }
}

//MARK: UIViewController identifiers
protocol CellIdentifiable {
    static var cellIdentifier: String { get }
}

extension CellIdentifiable where Self: UITableViewCell {
    static var cellIdentifier: String {
        return String(describing: self)
    }
}

extension CellIdentifiable where Self: UICollectionViewCell {
    static var cellIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: CellIdentifiable { }
extension UICollectionViewCell: CellIdentifiable {}

extension UITableView {
    
    func dequeueCellAtIndexPath<T: UITableViewCell>(_ indexPath: IndexPath) -> T where T: CellIdentifiable {
        return dequeueReusableCell(withIdentifier: T.cellIdentifier, for: indexPath) as! T
    }
    
    func reloadDataWithCompletion(completion: @escaping () -> Void) {
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            completion()
        }
        reloadData()
        CATransaction.commit()
    }
    
}

extension UICollectionView {
    
    func dequeueCellAtIndexPath<T: UICollectionViewCell>(_ indexPath: IndexPath) -> T where T: CellIdentifiable {
        return dequeueReusableCell(withReuseIdentifier: T.cellIdentifier, for: indexPath) as! T
    }
    
    func reloadDataWithCompletion(completion: @escaping () -> Void) {
        CATransaction.begin()
        CATransaction.setCompletionBlock { 
            completion()
        }
        reloadData()
        CATransaction.commit()
    }
    
}

extension UIView {
    
    static func initViewWithOwner<T: UIView>(_ owner: AnyObject) -> T {
        let wrapedView = Bundle.main.loadNibNamed(String(describing: T.self), owner: owner, options: nil)?[0]
        guard let view = wrapedView as? T else {
            fatalError("Couldn’t instantiate view from nib with identifier \(String(describing: T.self))")
        }
        
        return view
    }
}

func delay(seconds: Double, completion:@escaping ()->()) {
    let popTime = DispatchTime.now() + Double(Int64( Double(NSEC_PER_SEC) * seconds )) / Double(NSEC_PER_SEC)
    
    DispatchQueue.main.asyncAfter(deadline: popTime) {
        completion()
}
}

