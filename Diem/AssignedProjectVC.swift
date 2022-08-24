//
//  AssignedProject.swift
//  Requestor
//
//  Created by Nasim on 10/5/18.
//  Copyright © 2018 SMTech. All rights reserved.
//

import UIKit
import  ApiManagerLibrary
import Firebase
import MessageUI


class AssignedProjectVC: UICollectionViewController, UICollectionViewDelegateFlowLayout, AssignedProjectHeaderDelegate, AssignedTaskSegmentedCellDelegate, MFMessageComposeViewControllerDelegate{
    
    var selectedProject : ProjectModel!
    
    func handleJobComplete() {
        let jobCompleteVC = JobCompleteVC()
        jobCompleteVC.selectedProject = self.selectedProject
        jobCompleteVC.selectedOfferId = self.selectedProject.offer_id
        present(jobCompleteVC, animated: true, completion: nil)
    }
    
    func handleMessageJobberComplete() {
        
        let offers = selectedProject?.offers
        for offer in offers!
        {
            if offer.id == selectedProject?.offer_id
            {
                if let phone = offer.user_profile?.phone
                {
                    if (MFMessageComposeViewController.canSendText()) {
                        let controller = MFMessageComposeViewController()
                        controller.body = ""
                        controller.recipients = [offer.user_profile?.phone] as! [String]
                        controller.messageComposeDelegate = self
                        self.present(controller, animated: true, completion: nil)
                    }
                }
                else
                {
                    self.showAlertWith(title: "Sorry", message: "Diem didn't have Jobber Contact Number.")
                }
                break
            }
        }
        
        
        
       
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        //... handle sms screen actions
        self.dismiss(animated: true, completion: nil)
    }
    
    func handleCallJobberComplete() {
        let offers = selectedProject?.offers
        for offer in offers!
        {
            if offer.id == selectedProject?.offer_id
            {
                if let phone = offer.user_profile?.phone
                {
                    if let phoneCallURL = URL(string: "tel://\(phone.removeWhitespace())") {
                        
                        let application:UIApplication = UIApplication.shared
                        if (application.canOpenURL(phoneCallURL)) {
                            application.open(phoneCallURL, options: [:], completionHandler: nil)
                        }
                    }
                }
                else
                {
                    self.showAlertWith(title: "Sorry", message: "Diem didn't have Jobber Contact Number.")
                }
                break
            }
        }
    }
    
    func handleMenuItemClick(index : Int)
    {
        print(index)
        
        if index == 0
        {
            let fileDisputeVC = FileDisputeVC()
            fileDisputeVC.selectedProject = self.selectedProject
            self.navigationController?.pushViewController(fileDisputeVC, animated: true)
            //self.didClickOnDispute()
        }
        
        else if index == 1
        {
            let cancelJobVC = CancelJobVC()
            cancelJobVC.selectedProject = self.selectedProject

            self.present(cancelJobVC, animated: true, completion: nil)
            //self.didCancelTask()
        }
        
        
    }
    
   
    
   
    
    
  
    
   
    
    
    func showAlertWith(title: String, message:String, style: UIAlertControllerStyle = .alert){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        
        let action2 = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction) in
            print("You've pressed cancel");
        }
        
        
        alertController.addAction(action2)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func didSelectSegmentedItem(index: Int) {
        if index == 0{
            heightOfCollectionView = 460
            changeToSelectedIndex(index: 0)
        }else{
            heightOfCollectionView = 1000
            changeToSelectedIndex(index: 1)
        }
    }
    
    func changeToSelectedIndex(index: Int){
        let indexPath = NSIndexPath(item: index, section: 0)
        assignedTaskSegementedCell?.collectionView.scrollToItem(at: indexPath as IndexPath, at: .right, animated: false)
    }
    

    private let headerId = "headerId"
    private let taskTitleCellId = "taskTitleCellId"
    private let cellId = "cellId"
    private let assignedSegmentedCell = "assignedSegmentedCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .white
        
        navigationItem.largeTitleDisplayMode = .never

        
        navigationItem.title = selectedProject.category_name!
        
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.9450980392, green: 0.3843137255, blue: 0.2352941176, alpha: 1)
        //self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont(name: "SFProText-Semibold", size: 17)!]
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.hidesBarsOnSwipe = false

        
        setUpNavigationBar()
        setupCollectionView()
        setUpViews()
    }
    
    func setUpViews(){
      
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
    }
    
    
    func setupCollectionView(){
        if let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout{
            layout.minimumLineSpacing = 0
        }
        
       collectionView?.register(AssignedProjectHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
        
      
       collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
       collectionView?.register(AssignedTaskSegmentedCell.self, forCellWithReuseIdentifier: assignedSegmentedCell)
    
    }
    
    func setUpNavigationBar(){
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "backarrow").withRenderingMode(.alwaysOriginal), for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "SFProText-Regular", size: 17)
        button.sizeToFit()
        let leftBarButton = UIBarButtonItem(customView: button)
        navigationItem.leftBarButtonItem = leftBarButton
        button.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
    }
    
    @objc func handleBack(){
       self.navigationController?.popViewController(animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 220 + 105 + 83)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! AssignedProjectHeader
        
        headerView.assignedDelegate = self
        
        headerView.backgroundColor = #colorLiteral(red: 0.9568627451, green: 0.9568627451, blue: 0.9568627451, alpha: 1)
        
        if selectedProject.image != nil{
            headerView.pageControl.numberOfPages = (selectedProject.image?.count)!

        }
        else
        {
            headerView.pageControl.numberOfPages = 0
        }
        headerView.titleLabel.text = selectedProject.title
        
        
        if selectedProject.accept_date != nil{
            let doubleTime = Date(timeIntervalSince1970: Double(selectedProject.accept_date!.formatted()))
            
            headerView.subtitleLabel.text = "Assigned \( doubleTime.getElapsedInterval()) ago"
            print(selectedProject?.budget! as Any)
            print((String(describing: selectedProject?.budget!)))
        }
        else{
            headerView.subtitleLabel.text  = ""
        }
      
        
        let offers = selectedProject?.offers
        var budget = ""
        
        
        if selectedProject?.DOD == "true"
        {
            budget = (selectedProject?.budget)!
        }
        else{
            for offer in offers!
            {
                if offer.id == selectedProject?.offer_id
                {
                    budget = offer.offer_price!
                    break
                }
            }
        }
        
        
        if budget.count == 0 && offers!.count > 0
        {
            let selectedOffer = offers![0]
            budget = selectedOffer.offer_price!

        }
       

        
        let price = (budget as! NSString).doubleValue
        headerView.priceLabel.text = "$\(String(format: "%.2f", price))"
        
        if self.selectedProject.image != nil
        {
            headerView.images = self.selectedProject.image!
        }
        
        return headerView
    }
    
    var assignedTaskSegementedCell: AssignedTaskSegmentedCell?
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0{
            assignedTaskSegementedCell = collectionView.dequeueReusableCell(withReuseIdentifier: assignedSegmentedCell, for: indexPath) as? AssignedTaskSegmentedCell
        
            assignedTaskSegementedCell?.segmentedCellDelegate = self
            assignedTaskSegementedCell?.job = self.selectedProject
            return assignedTaskSegementedCell!
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
            cell.backgroundColor = .blue
            return cell
        }
  
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    var heightOfCollectionView: CGFloat = 460
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 0{
    
            return CGSize(width: view.frame.width, height: heightOfCollectionView)
        }else{
            
             return CGSize(width: view.frame.width, height: 100)
        }
       

    }
    
}

extension String {
    func replace(string:String, replacement:String) -> String {
        return self.replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
    }
    
    func removeWhitespace() -> String {
        return self.replace(string: " ", replacement: "")
    }
}
