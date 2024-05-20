//
//  ViewController.swift
//  DowloadDemo
//
//  Created by Ongraph Technologies on 25/04/24.
//

import UIKit
import PDFKit

class ViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    var arr = ["https://web.archive.org/web/20110918100215/http://www.irs.gov/pub/irs-pdf/f1040.pdf" , "http://www.africau.edu/images/default/sample.pdf","https://www.clickdimensions.com/links/TestPDFfile.pdf","https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf"]

    @IBOutlet weak var dataTV: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataTV.delegate = self
        dataTV.dataSource = self
        dataTV.register(UINib(nibName: "ListTVC", bundle: nil), forCellReuseIdentifier: "ListTVC")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListTVC", for: indexPath) as! ListTVC
        cell.lbl.text = arr[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(indexPath.row)")
        let url = URL(string: arr[indexPath.row])
        FileDownloader.loadFileAsync(url: url!) { path, errors , status in
            if (errors != nil) {

            }
            else{
              
                    

                            if let url = URL(string: path ?? "" ){
                                
                                UIApplication.shared.open(url)
                                let urlWithoutFileExtension: URL =  url.deletingPathExtension()
                                let fileNameWithoutExtension: String = urlWithoutFileExtension.lastPathComponent
//                                let pdfView = PDFView(frame: self.view.bounds)
//                                self.view.addSubview(pdfView)
//                                pdfView.document = PDFDocument(url: url)
                            }
                }
                
            }
    
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        116
    }
    
    
}




class FileDownloader {

    static func loadFileSync(url: URL, completion: @escaping (String?, Error? , Bool) -> Void)
    {
        let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

        let destinationUrl = documentsUrl.appendingPathComponent(url.lastPathComponent)

        if FileManager().fileExists(atPath: destinationUrl.path)
        {
            print("File already exists [\(destinationUrl.path)]")
            completion(destinationUrl.path, nil , true)
        }
        else if let dataFromURL = NSData(contentsOf: url)
        {
            if dataFromURL.write(to: destinationUrl, atomically: true)
            {
                print("file saved [\(destinationUrl.path)]")
                completion(destinationUrl.path, nil , false)
            }
            else
            {
                print("error saving file")
                let error = NSError(domain:"Error saving file", code:1001, userInfo:nil)
                completion(destinationUrl.path, error , false)
            }
        }
        else
        {
            let error = NSError(domain:"Error downloading file", code:1002, userInfo:nil)
            completion(destinationUrl.path, error,false)
        }
    }

    static func loadFileAsync(url: URL, completion: @escaping (String?, Error? , Bool?) -> Void)
    {
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

        let destinationUrl = documentsUrl.appendingPathComponent(url.lastPathComponent)

        if FileManager().fileExists(atPath: destinationUrl.path)
        {
            print("File already exists [\(destinationUrl.path)]")
            completion("\(destinationUrl)", nil , true)
        }
        else
        {
            let session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: nil)
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            let task = session.dataTask(with: request, completionHandler:
            {
                data, response, error in
                if error == nil
                {
                    if let response = response as? HTTPURLResponse
                    {
                        if response.statusCode == 200
                        {
                            if let data = data
                            {
                                if let _ = try? data.write(to: destinationUrl, options: Data.WritingOptions.atomic)
                                {
                                    completion("\(destinationUrl)", error , false)
                                }
                                else
                                {
                                    completion("\(destinationUrl)", error ,false)
                                }
                            }
                            else
                            {
                                completion("\(destinationUrl)", error, false)
                            }
                        }
                    }
                }
                else
                {
                    completion("\(destinationUrl)", error, false)
                }
            })
            task.resume()
        }
    }
}

