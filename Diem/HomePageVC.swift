//
//  HomePageVC.swift
//  Requestor
//
//  Created by Nasim on 26/7/18.
//  Copyright © 2018 SMTech. All rights reserved.
//

import UIKit
import MXSegmentedPager
import ApiManagerLibrary
import CoreData
import PINRemoteImage
import ChatSDK
import ChatSDKFirebase


class HomePageVC: UIViewController, MXSegmentedPagerDelegate, MXSegmentedPagerDataSource, HomeCategoryCellDelegate{
    
    private let cellId = "cellId"
    private let pageId = "pageId"
    
    
    var recentJobs =  [ProjectModel]()

    
    var blockOperations = [BlockOperation]()
    
    lazy var fetchedhResultController: NSFetchedResultsController<NSFetchRequestResult> = {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: JobCategory.self))
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "priority", ascending: true)]
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.sharedInstance.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        return frc
    }()
    
    func handleRecentJobCell(project : ProjectModel) {
        
        self.reportJob(project : project)
//        let recentCompletedJobVC = RecentCompletedJobVC(collectionViewLayout: UICollectionViewFlowLayout())
//        recentCompletedJobVC.hidesBottomBarWhenPushed = true
//        self.navigationController?.pushViewController(recentCompletedJobVC, animated: true)
    }
    
    func handleMoreButton(project : ProjectModel) {
        self.reportJob(project : project)

//        let popularRequestsVC = PopularRequestsVC(collectionViewLayout: UICollectionViewFlowLayout())
//        popularRequestsVC.hidesBottomBarWhenPushed = true
//        self.navigationController?.pushViewController(popularRequestsVC, animated: true)
    }
    
    func reportJob(project : ProjectModel)  {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        
        
        let postButton = UIAlertAction(title: "Post Similar Job", style: .destructive, handler: { [weak self] (action) -> Void in
            //self?.reportJobAPI(listingID: listingID, reason: "It's spam", uid: uid)
            let jobPostVC = JobPostVC(collectionViewLayout: UICollectionViewFlowLayout())
            categoryName = project.category_name!
            categoryId = project.category_id!
            let navController = UINavigationController(rootViewController: jobPostVC)
            self?.present(navController, animated: true, completion: nil)
            print("Ok button tapped")
        })
        
        
        let sendButton = UIAlertAction(title: "It's spam", style: .destructive, handler: { [weak self] (action) -> Void in
            self?.reportJobAPI(listingID: project.offers![0].listingID!, reason: "It's spam", uid: project.user_id!)
            print("Ok button tapped")
        })
        
        let  deleteButton = UIAlertAction(title: "It's inappropriate", style: .destructive, handler: { [weak self] (action) -> Void in
            self?.reportJobAPI(listingID: project.offers![0].listingID!, reason: "It's inappropriate", uid: project.user_id!)
            print("Delete button tapped")
        })
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
            print("Cancel button tapped")
        })
        
        alertController.addAction(postButton)
        alertController.addAction(sendButton)
        alertController.addAction(deleteButton)
        alertController.addAction(cancelButton)
        
        self.navigationController!.present(alertController, animated: true, completion: nil)
        
    }
    
    func reportJobAPI(listingID: String, reason: String, uid: String){
        
        let progressHUD = ProgressHUD(text: "Please wait")
        self.view.addSubview(progressHUD)
        progressHUD.show()
        
        ListingReportApiManager.reportJob(listingID: listingID, reason: reason, uid: uid) { (result) in
            
            progressHUD.hide()

            
            switch result{
                
            case .success(let msg):
                print(msg)
                self.showAlertWith(title: "Success", message: msg)
                break
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    func categoryCellDidTapped(name: String, id: String) {
        let jobPostVC = JobPostVC(collectionViewLayout: UICollectionViewFlowLayout())
        categoryName = name
        categoryId = id
        let navController = UINavigationController(rootViewController: jobPostVC)
        present(navController, animated: true, completion: nil)
    }
    
    func categoryCellDidTapped(name: String, id: String, isDOD: Bool, timelimit: String, price :  String, dodBookingData : Data) {
//        let onDemandVC = UIStoryboard(name: "OnDemand", bundle: nil).instantiateViewController(withIdentifier: "OnDemandVC") as! OnDemandVC
//        categoryName = name
//        categoryId = id
//        timeLimit = timelimit
//        itemPrice = price
//        dodBookingdata = dodBookingData
//
//
//        let navController = UINavigationController(rootViewController: onDemandVC)
//        self.present(navController, animated: true, completion: nil)
    }
    
    func categoryCellDidTapped(subCat: JobSubCategory)
    {
       
        let onDemandVC = UIStoryboard(name: "OnDemand", bundle: nil).instantiateViewController(withIdentifier: "OnDemandVC") as! OnDemandVC
        
        onDemandVC.subCat = subCat
       
        
        let navController = UINavigationController(rootViewController: onDemandVC)
        self.present(navController, animated: true, completion: nil)
    }
    
    func handleCategorisTappedFailed() {
        
        self.handleApiCell()
       
    }
    
     func handleVideoPlayClick(videoId : String)
     {
        let stroyboard = UIStoryboard(name: "Main", bundle: nil)
        let videoPlayerVC = stroyboard.instantiateViewController(withIdentifier: "VideoPlayerController") as! VideoPlayerController
        videoPlayerVC.videoId = videoId
        videoPlayerVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(videoPlayerVC, animated: true)
    }
    
    func handleInteriorJobber() {
        //        let vc = InteriorVC(nibName: "InteriorVC", bundle: nil)
        //        self.navigationController?.present(vc, animated: true, completion: nil)
        let storyboard = UIStoryboard(name: "InteriorStoryboard", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "InteriorVC") as! InteriorVC
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
    
    
    func handleBecomeJobber() {
        let becomeAJobber = BecomeJobberNewVC()
        self.present(becomeAJobber, animated: true, completion: nil)
    }
    

    var categoriesArray: [CategoriesModel]?
    
    let segmentedPager: MXSegmentedPager = {
        let segmentdPager = MXSegmentedPager()
        return segmentdPager
    }()
    
    
    lazy var headerView: HomeHeaderView = {
        let mb = HomeHeaderView()
        mb.contentMode = .scaleToFill
        mb.translatesAutoresizingMaskIntoConstraints = false
        return mb
    }()
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.9058823529, green: 0.368627451, blue: 0.2235294118, alpha: 1)
        
        setUpSegmentedPager()
        
        self.callRecentJObCompletedAPI()
        self.changeStatusbarColor()
        
    }
    
    
    func changeStatusbarColor(){
        let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
        let statusBarColor = #colorLiteral(red: 0.9529411765, green: 0.3803921569, blue: 0.2, alpha: 1)
        statusBarView.backgroundColor = statusBarColor
        view.addSubview(statusBarView)
    }
    
    func handleApiCell(){
        
        do {
            try self.fetchedhResultController.performFetch()
        } catch let error  {
            print("ERROR: \(error)")
        }
        
        let count = fetchedhResultController.sections?.first?.numberOfObjects
        let progressHUD = ProgressHUD(text: "Please wait")
        if(count != 0)
        {
            do {
                try self.fetchedhResultController.performFetch()
                self.segmentedPager.reloadData()
            } catch let error  {
                print("ERROR: \(error)")
            }
            
        }
        
        else
        {
            self.view.addSubview(progressHUD)
            progressHUD.show()
            
        }
            
       
        
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate.handleApiCell(completionHandler: { (success) in
            print(success)
            if success
            {
                progressHUD.hide()
                do {
                    try self.fetchedhResultController.performFetch()
                    self.segmentedPager.reloadData()
                } catch let error  {
                    print("ERROR: \(error)")
                }
            }
        })
        
      

        
    }
    
    func callRecentJObCompletedAPI()
    {
        
        UsersApiManager.fetchRecentCompletedListings( completion: { (result) in
            switch result{
            case .success(let data):
                self.recentJobs = data
                
                self.handleApiCell()

                break
            case .failure(let error):
                print(error)
                
                
            }
        })
        
       
      
    }

    
    
    
    func showAlertWith(title: String, message:String, style: UIAlertControllerStyle = .alert){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        
        let action = UIAlertAction(title: "Ok", style: .default) { (action) in
            //self.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    
    
    override func viewWillLayoutSubviews() {
//        segmentedPager.frame = CGRect()
//
//        segmentedPager.frame.origin = CGPoint(x: 0, y: 0)
        
       
        
        if hasTopNotch
        {
            segmentedPager.frame.origin = CGPoint(x: 0, y: 23)
            segmentedPager.frame.size = CGSize(width:  view.frame.size.width, height:  view.frame.size.height - 96)
        }
        else
        {
            segmentedPager.frame.origin = CGPoint(x: 0, y: 0)
            segmentedPager.frame.size = CGSize(width:  view.frame.size.width, height:  view.frame.size.height - 44)
        }
     
        super.viewWillLayoutSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        self.checkforupdate()

        
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        
        let initialStatusBarStyle : UIStatusBarStyle
        initialStatusBarStyle = UIApplication.shared.statusBarStyle
        UIApplication.shared.setStatusBarStyle(.lightContent, animated: animated)
        
        handleApiCell()
        
        
        
    }
    
    
    func checkforupdate()
    {
        UsersApiManager.getUpdateVersion { (result) in
            switch result{
            case .success(let data):
                
                print(data)
                
                if let ios = data["ios"] as? [String : AnyObject]
                {
                let version = ios["version_name"] as! NSNumber
                let Build = ios["version_code"] as! NSNumber
                
                print(version)
                print(Build)
                
                print(Bundle.main.releaseVersionNumber)
                print(Bundle.main.buildVersionNumber)

                let currrentVersion = Bundle.main.releaseVersionNumber!
                let currentBuild = Bundle.main.buildVersionNumber!
               
             
                if (version.floatValue > currrentVersion)
                {
                     self.showUpdateAlertWith(title: "New Version Avaialble", message: "Please, update Diem to new version to continue use the app.")
                }
                else if  (version.floatValue == currrentVersion)
                {
                    if (Build.floatValue > currentBuild)
                    {
                         self.showUpdateAlertWith(title: "New Version Avaialble", message: "Please, update Diem to new version to continue use the app.")
                    }
                    
                }
                }
                
                
                break
                
            case .failure(let message):
                print(message)
                
            }
            
        }
    
    }
    
    func showUpdateAlertWith(title: String, message:String, style: UIAlertControllerStyle = .alert){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        
        let action = UIAlertAction(title: "Update", style: .default) { (action) in
            //self.dismiss(animated: true, completion: nil)
            
            guard let url = URL(string: "https://itunes.apple.com/us/app/diem/id1422037593?ls=1&mt=8") else {
                return //be safe
            }
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
        
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    
    func setUpSegmentedPager(){
        view.addSubview(segmentedPager)
        segmentedPager.delegate = self
        segmentedPager.dataSource = self
        
        segmentedPager.parallaxHeader.view =  headerView
        segmentedPager.parallaxHeader.mode = .fill
        segmentedPager.parallaxHeader.height = 200
        segmentedPager.parallaxHeader.minimumHeight = 20
        
        
        segmentedPager.segmentedControl.selectionIndicatorLocation = .down
        segmentedPager.segmentedControl.selectionIndicatorColor = UIColor.orange
        segmentedPager.segmentedControl.selectionStyle = .fullWidthStripe
        segmentedPager.segmentedControl.selectedTitleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.orange]
        segmentedPager.segmentedControl.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "Telegrafico", size: 18)!, NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.6352233291, green: 0.6353349686, blue: 0.6352162957, alpha: 1)]
        segmentedPager.segmentedControl.segmentWidthStyle = .fixed
        segmentedPager.segmentedControl.setViewFrameWidth(Float(self.view.frame.width / 3))
        segmentedPager.pager.register(HomeCategoryCell.self, forPageReuseIdentifier: pageId)
    }
    
    
    func segmentedPager(_ segmentedPager: MXSegmentedPager, didSelectViewWithTitle title: String) {
        print("Page selected \(title)")
    }
    
//    var page: HomeCategoryCell?
    
    func segmentedPager(_ segmentedPager: MXSegmentedPager, viewForPageAt index: Int) -> UIView {
        let page = segmentedPager.pager.dequeueReusablePage(withIdentifier: pageId) as! HomeCategoryCell
        page.delegate = self
        page.recentJobs = self.recentJobs
        let indexPath = IndexPath(item: index, section: 0)
        
        if self.validateIndexPath(indexPath){
            if let categories = fetchedhResultController.object(at: indexPath) as? JobCategory{
                let subCategories = categories.subCategories?.allObjects as? [JobSubCategory]
                var subCategoriesTemp = subCategories?.sorted(by: {$0.dod?.localizedCaseInsensitiveCompare($1.dod ?? "") == ComparisonResult.orderedAscending})
                subCategoriesTemp?.reverse()
                page.subCategories = subCategoriesTemp
                
                if let url = categories.image{
                    self.headerView.imageView.loadImageUsingCacheWithURLString(url, placeHolder: UIImage(named: "placeholder"))
                }
            }
        }
    

        return page

    }


    func heightForSegmentedControl(in segmentedPager: MXSegmentedPager) -> CGFloat {
        return 40
    }

    func numberOfPages(in segmentedPager: MXSegmentedPager) -> Int {
        guard let count = fetchedhResultController.sections?.first?.numberOfObjects else {return 1}
        print(count)

        if count != 0{
            return count
        }else{
            return 1
        }

//        if let count = fetchedhResultController.sections?.first?.numberOfObjects{
//            return count
//        }else{
//            return 1
//        }

    }

    func segmentedPager(_ segmentedPager: MXSegmentedPager, titleForSectionAt index: Int) -> String {
        
        let indexPath = IndexPath(item: index, section: 0)

        
        if self.validateIndexPath(indexPath){
            let categories = fetchedhResultController.object(at: indexPath) as? JobCategory
            guard let title = categories?.name else {return ""}
            return title
        }
        
        return ["Home"][index]
        
    }
    
    func validateIndexPath(_ indexPath: IndexPath) -> Bool {
        if let sections = self.fetchedhResultController.sections,
            indexPath.section < sections.count {
            if indexPath.row < sections[indexPath.section].numberOfObjects {
                return true
            }
        }
        return false
    }
   
    

    
//    func numberOfPages(in segmentedPager: MXSegmentedPager) -> Int {
//        if let count = categories?.count{
//            return count
//        }else{
//            return 1
//        }
//    }
//
//    func segmentedPager(_ segmentedPager: MXSegmentedPager, titleForSectionAt index: Int) -> String {
//        if let category = categories?[index]{
//            let title = category.value.name
//            return title
//        }
//        else{
//            return ["Home"][index]
//        }
//    }
//
//    func segmentedPager(_ segmentedPager: MXSegmentedPager, viewForPageAt index: Int) -> UIView {
//        let page = segmentedPager.pager.dequeueReusablePage(withIdentifier: pageId) as! HomeCategoryCell
//
//        page.backgroundColor = .red
//        return page
//    }
}

extension HomePageVC: NSFetchedResultsControllerDelegate {
//    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
//
//        if type == NSFetchedResultsChangeType.insert {
//            blockOperations.append(
//                BlockOperation(block: { [weak self] in
//                    if let this = self {
//                        self?.page?.collectionView.insertItems(at: [newIndexPath!])
//                    }
//                })
//            )
//        }
//        else if type == NSFetchedResultsChangeType.update {
//            blockOperations.append(
//                BlockOperation(block: { [weak self] in
//                    if let this = self {
//                        self?.page?.collectionView.reloadItems(at: [indexPath!])
//                    }
//                })
//            )
//        }
//        else if type == NSFetchedResultsChangeType.move {
//            
//            blockOperations.append(
//                BlockOperation(block: { [weak self] in
//                    if let this = self {
//                        self?.page?.collectionView.moveItem(at: indexPath!, to: newIndexPath!)
//                    }
//                })
//            )
//        }
//        else if type == NSFetchedResultsChangeType.delete {
//            
//            blockOperations.append(
//                BlockOperation(block: { [weak self] in
//                    if let this = self {
//                        self?.page?.collectionView.deleteItems(at: [indexPath!])
//                    }
//                })
//            )
//        }
//    }
//
//    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
//
//        
//        if type == NSFetchedResultsChangeType.insert {
//            blockOperations.append(
//                BlockOperation(block: { [weak self] in
//                    if let this = self {
//                        self?.page?.collectionView.insertSections(NSIndexSet(index: sectionIndex) as IndexSet)
//                    }
//                })
//            )
//        }
//        else if type == NSFetchedResultsChangeType.update {
//            print("Update Section: \(sectionIndex)")
//            blockOperations.append(
//                BlockOperation(block: { [weak self] in
//                    if let this = self {
//                        self?.page?.collectionView.reloadSections(NSIndexSet(index: sectionIndex) as IndexSet)
//                    }
//                })
//            )
//        }
//        else if type == NSFetchedResultsChangeType.delete {
//            print("Delete Section: \(sectionIndex)")
//            
//            blockOperations.append(
//                BlockOperation(block: { [weak self] in
//                    if let this = self {
//                        self?.page?.collectionView.deleteSections(NSIndexSet(index: sectionIndex) as IndexSet)
//                    }
//                })
//            )
//        }
//    }
//
//    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        page?.collectionView.performBatchUpdates({ () -> Void in
//            for operation: BlockOperation in self.blockOperations {
//                operation.start()
//            }
//        }, completion: { (finished) -> Void in
//            self.blockOperations.removeAll(keepingCapacity: false)
//        })
//    }
   

}

var hasTopNotch: Bool {
    if #available(iOS 11.0,  *) {
        return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
    }
    
    return false
}

extension Bundle {
    var releaseVersionNumber: Float? {
        return Float((infoDictionary?["CFBundleShortVersionString"] as? String)!)
    }
    var buildVersionNumber: Float? {
        return Float((infoDictionary?["CFBundleVersion"] as? String)!)

    }
}
