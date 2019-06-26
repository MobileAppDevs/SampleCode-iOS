//
//  PMediaVC.swift
//  Popbox
//
//  Created by Ongraph on 3/20/18.
//  Copyright © 2018 mac. All rights reserved.
//

import UIKit

let ratio = 24.6575342465753
class PMediaVC: UIViewController {
    
    @IBOutlet var mediaTblView : UITableView!
    var mediaList = [1,2,3,3,4,5,5,2,2]
    var navController: UINavigationController!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mediaTblView.rowHeight = UITableViewAutomaticDimension
        mediaTblView.estimatedRowHeight = 90
        mediaTblView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //====================================================================================================
    //MARK: -  IB ACTION
    //====================================================================================================
    
    @IBAction func btnBackAction(_ sender: Any) {
        
        _ =  self.navigationController?.popViewController(animated: true)
        
    }
    

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < -100 {
 
        }
        debugPrint("scrollViewDidScroll")
    }
    
}
//====================================================================================================
//MARK: -  Table View DataSource and Delegate Method
//====================================================================================================

extension PMediaVC:UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellID =  "PMediaCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! PMediaCell
        cell.colView.delegate = self
        cell.colView.dataSource = self
        let w = ((screenW()-10)*ratio)/100
        let f = Double(mediaList.count/4).rounded(.up)
        cell.heightConstraint.constant = CGFloat(f*w)
        return cell
    }
 
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sectionCell") as! PMediaCell
        cell.monthLbl.text = "Jan"
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 44
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

//====================================================================================================
//MARK: -  Collection View DataSource and Delegate Method
//====================================================================================================
extension PMediaVC:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w = ((screenW()-10)*ratio)/100
        return CGSize(width: w, height: w)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: "PMediaCVCell", for: indexPath) as! PMediaCVCell
      
        return item
    }
}
