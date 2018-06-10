//
//  HostViewController.swift
//  MyZabbixWatcher
//
//  Created by apple on 2018/6/1.
//  Copyright © 2018 apple. All rights reserved.
//

import UIKit
import SwiftyJSON

let SCREEN_WIDTH = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height

class HostViewController: UICollectionViewController {
    
    var hostSearchBar: UISearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH - 130, height: 200))
    var searchResult: [JSON] = [JSON]()
    var allElements: [JSON] = [JSON]()
    
    //var indexPath: IndexPath?
    //var dragingItem: CardCell = CardCell()
    
    var currentIndexPath: IndexPath?
    var snapedImageView: UIImageView?
    var deltaSize: CGSize!
    
    var isDetail: Bool = false
    var deleteArea: UIButton?
    
    var json: JSON?
    
    var addBtn: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        dragingItem.isHidden = true
//        dragingItem.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        
        //collection layout(custom)
        let layout = CardLayout()
        layout.itemSize = CGSize(width: SCREEN_WIDTH-80, height: SCREEN_HEIGHT-64-320)
        collectionView?.collectionViewLayout = layout
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressGesture(_:)))
        collectionView?.addGestureRecognizer(longPress)
        collectionView?.backgroundColor = UIColor.yellow

        //host search bar
        let leftNavBarButton = UIBarButtonItem(customView:hostSearchBar)
        self.navigationItem.rightBarButtonItem = leftNavBarButton
        self.navigationItem.hidesSearchBarWhenScrolling = true
        self.hostSearchBar.delegate = self
        self.hostSearchBar.placeholder = "Search for hosts"
        
        //add button
        addBtn = UIButton()
        addBtn?.frame = CGRect(x:320, y: 600, width:50, height:50)
        addBtn?.layer.masksToBounds = true
        addBtn?.layer.cornerRadius = (addBtn?.frame.width)! / 2
        addBtn?.setImage(UIImage(named: "plus"), for: .normal)
        addBtn?.addTarget(self, action: #selector(btnClick(sender:)), for:.touchUpInside)
        collectionView?.addSubview(addBtn!)
        
        if let dataFromString = HostsData1.data(using: .utf8, allowLossyConversion: false) {
            json = try? JSON(data: dataFromString)
        }
        for j in json! {
            allElements.append(j.1)
        }
        searchResult = allElements
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
        //cell.backgroundColor = UIColor(red: 125/255, green: 206/255, blue: 250/255, alpha: 1.0)
        cell.backgroundColor = UIColor.yellow
        cell.layer.cornerRadius = 10
        
        cell.id = "\(indexPath.row + 1)"
        cell.hostId = searchResult[indexPath.row]["hostid"].stringValue
        cell.hostName = searchResult[indexPath.row]["name"].stringValue
        cell.hostDecription = searchResult[indexPath.row]["description"].stringValue
        cell.hostStatus = searchResult[indexPath.row]["status"].stringValue
        cell.hostError = searchResult[indexPath.row]["error"].stringValue
        cell.hostGroup = searchResult[indexPath.row]["group"].stringValue
        cell.hostAvailable = searchResult[indexPath.row]["available"].stringValue
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
}

//search bar extension
extension HostViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if(searchText == "") {
            searchResult = allElements
        } else {
            searchResult = []
            
            for arr in allElements {
                if(arr["name"].stringValue.lowercased().hasPrefix(searchText.lowercased())) {
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
        searchResult = allElements
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
                    
                    deleteArea = UIButton()
                    deleteArea?.frame = CGRect(x: 0, y: 45, width: SCREEN_WIDTH, height: 100)
                    
                    deleteArea?.backgroundColor = UIColor(red: 112/255, green: 128/255, blue: 144/255, alpha: 0.1)
                    deleteArea?.setTitle("DELETE", for: .normal)
                    deleteArea?.setTitleColor(UIColor.black, for: .normal)
                    deleteArea?.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
                    view.addSubview(deleteArea!)
            }
            
            case UIGestureRecognizerState.changed:
                if snapedImageView == nil {return}
                snapedImageView?.frame.origin.x = point.x - deltaSize.width
                snapedImageView?.frame.origin.y = point.y - deltaSize.height
                if point.y <= 84 {
                    deleteArea?.backgroundColor = UIColor(red: 112/255, green: 128/255, blue: 144/255, alpha: 0.6)
                } else {
                    deleteArea?.backgroundColor = UIColor(red: 112/255, green: 128/255, blue: 144/255, alpha: 0.1)
                }
            
            case UIGestureRecognizerState.ended:
                if(point.y <= 84) {
                    searchResult.remove(at: (currentIndexPath?.row)!)
                    collectionView?.reloadData()
                    
                    snapedImageView?.alpha = 0.0
                } else {
                    let cell = collectionView?.cellForItem(at: notSureIndexPath!)!
                    snapedImageView?.alpha = 0.0
                    cell!.alpha = 1.0
                }
            
                deleteArea?.removeFromSuperview()
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
    
}

extension HostViewController {
    @objc func btnClick(sender: UIButton) {
        let controller = UIStoryboard(name: "HostAdd", bundle: nil).instantiateViewController(withIdentifier: "HostAddViewController") as! HostAddViewController
        self.navigationController?.pushViewController(controller, animated: true)
        //self.present(controller, animated: true, completion: nil)
        
    }
}
