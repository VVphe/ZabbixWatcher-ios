//
//  HostViewController.swift
//  MyZabbixWatcher
//
//  Created by apple on 2018/6/1.
//  Copyright © 2018 apple. All rights reserved.
//

import UIKit

let SCREEN_WIDTH = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height

class HostViewController: UICollectionViewController {
    
    var hostSearchBar: UISearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH - 130, height: 200))
    var searchResult = [String]()
    
    //var indexPath: IndexPath?
    //var dragingItem: CardCell = CardCell()
    
    var currentIndexPath: IndexPath?
    var snapedImageView: UIImageView?
    var deltaSize: CGSize!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        dragingItem.isHidden = true
//        dragingItem.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        
        //collection layout(custom)
        let layout = CardLayout()
        layout.itemSize = CGSize(width: SCREEN_WIDTH-80, height: SCREEN_HEIGHT-64-240)
        collectionView?.collectionViewLayout = layout
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressGesture(_:)))
        collectionView?.addGestureRecognizer(longPress)

        //host search bar
        let leftNavBarButton = UIBarButtonItem(customView:hostSearchBar)
        self.navigationItem.rightBarButtonItem = leftNavBarButton
        self.navigationItem.hidesSearchBarWhenScrolling = true
        self.hostSearchBar.delegate = self
        self.hostSearchBar.placeholder = "Search for hosts"
        searchResult = HostsData
        
    }
    
    func transform3d() -> CATransform3D {
        var transform = CATransform3DIdentity
        transform.m34 = 2.5 / -2000
        return transform
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
}

//collection extension
extension HostViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResult.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCell
        cell.backgroundColor = UIColor.orange
        cell.hostIdLabel.text = "\(searchResult[indexPath.row])"
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        UIView.animate(withDuration: 0.2, animations: {
//            cell?.transform = (cell?.transform.rotated(by: CGFloat(M_PI)))!
            var allTransofrom = CATransform3DIdentity
            let rotateTransform = CATransform3DMakeRotation(CGFloat.pi, 0, 1, 0)
            allTransofrom = CATransform3DConcat(allTransofrom, rotateTransform)
            allTransofrom = CATransform3DConcat(allTransofrom, self.transform3d())
            cell?.layer.transform = allTransofrom
            cell?.alpha = 0.0
        })
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
}

//search bar extension
extension HostViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if(searchText == "") {
            searchResult = HostsData
        } else {
            searchResult = []
            
            for arr in HostsData {
                if(arr.lowercased().hasPrefix(searchText.lowercased())) {
                    searchResult.append(arr)
                }
            }
        }
        
        collectionView?.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        hostSearchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        hostSearchBar.text = "Search for hosts"
        searchResult = HostsData
        collectionView?.reloadData()
    }
    
}

// press gesture
extension HostViewController {
    
    @objc func longPressGesture(_ tap: UILongPressGestureRecognizer) {
        
        let point = tap.location(in: collectionView)
        let notSureIndexPath = collectionView?.indexPathForItem(at: point)
        
        switch tap.state {
            case UIGestureRecognizerState.began:
                if let indexPath = notSureIndexPath {
                    currentIndexPath = indexPath
                    let cell = collectionView?.cellForItem(at: indexPath)!
                    snapedImageView = getTheCellSnap(targetView: cell!)
                    deltaSize = CGSize(width: point.x - (cell?.frame.origin.x)!, height: point.y - (cell?.frame.origin.y)!)
           
                    snapedImageView?.center = (cell?.center)!
                    snapedImageView?.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        
                    cell!.alpha = 0.0
        
                    collectionView?.addSubview(snapedImageView!)
            }
            
            case UIGestureRecognizerState.changed:
                if snapedImageView == nil {return}
                snapedImageView?.frame.origin.x = point.x - deltaSize.width
                snapedImageView?.frame.origin.y = point.y - deltaSize.height
            
            case UIGestureRecognizerState.ended:
                if(point.y <= 45) {
                    searchResult.remove(at: (currentIndexPath?.row)!)
                    collectionView?.reloadData()
                    
                    snapedImageView?.alpha = 0.0
                } else {
                    let cell = collectionView?.cellForItem(at: notSureIndexPath!)!
                    snapedImageView?.alpha = 0.0
                    cell!.alpha = 1.0
                }
            //case UIGestureRecognizerState.cancelled:
                //dragEnded(point: point)
            default: break
        }
    }
    
    func getTheCellSnap(targetView: UIView) -> UIImageView {
        UIGraphicsBeginImageContextWithOptions(targetView.bounds.size, false, 0.0)
        
        targetView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let gottenImageView = UIImageView(image: image)
        
        return gottenImageView
    }
    
//    func dragBegan(point: CGPoint) {
//        indexPath = collectionView?.indexPathForItem(at: point)
//        if (indexPath == nil || (indexPath?.section)! > 0 )
//        {return}
//        let item = collectionView?.cellForItem(at: indexPath!) as? CardCell
//        print(item)
//        item?.isHidden = true
//        dragingItem.isHidden = false
//        dragingItem.frame = (item?.frame)!
//        dragingItem.backgroundColor = UIColor.orange
//        dragingItem.transform = CGAffineTransform(scaleX: 2, y: 2)
//        print(dragingItem)
//    }
//
//    func dragChanged(point: CGPoint) {
//        if (indexPath == nil || (indexPath?.section)! > 0) {return}
//        dragingItem.center = point
//    }
//
//    func dragEnded(point: CGPoint) {
//        if indexPath == nil || (indexPath?.section)! > 0  {return}
//        let endCell = collectionView?.cellForItem(at: indexPath!)
//    }
    
}
