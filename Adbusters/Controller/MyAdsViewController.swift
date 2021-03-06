//
//  MyAdsViewController.swift
//  Adbusters
//
//  Created by MacBookAir on 10/17/18.
//  Copyright © 2018 MacBookAir. All rights reserved.
//

import UIKit
import Kingfisher
import SVProgressHUD

class MyAdsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var imageUrlString: String?
    
    @IBOutlet var loader: UIActivityIndicatorView!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.separatorColor = UIColor.white
        currentAdsImageUrls = [AdImage]()
        // Do any additional setup after loading the view.
        loadAds()
    }
    
    @IBAction func goBackTapped(_ sender: Any) {
        KingfisherManager.shared.cache.clearMemoryCache()
        KingfisherManager.shared.cache.clearDiskCache()
        KingfisherManager.shared.cache.cleanExpiredDiskCache()
        
        if getAdstask != nil {
            getAdstask!.cancel()
        }
        ads = nil
        dismiss(animated: true, completion: nil)
    }
    
    
    func loadAds() {
        if ads != nil {
            return
        }
        DispatchQueue.main.async {
            showIndicator(true, indicator: self.loader)
        }
        
        getAds(url: API_URL + "/ads_read/?my=True") { (json, error) in
            if let error = error {
                showIndicator(false, indicator: self.loader)
                print("ERROR WAR", error)
                error.alert(with: self, title: "Помилка завантаження", message: "Проблеми з сервером або iнтернетом")
                return
            }
            
            if let jsonData = json {
                
                ads = jsonData
                loadedAds = true
                if jsonData.count == 0 {
                    Toast().alert(with: self, title: "Завантажено", message: "Список пустий")
                }
                DispatchQueue.main.async {
                    showIndicator(false, indicator: self.loader)
                    self.tableView.reloadData()
                }
            } else {
                showIndicator(false, indicator: self.loader)
                Toast().alert(with: self, title: "Помилка завантаження", message: "Пошкодженi данi")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ads?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyAdsViewTableViewCell
        cell.selectionStyle = .none
        cell.title.text = ads?[indexPath.row].party?.name ?? ""
        cell.type.text = getTypeText(ads![indexPath.row].type!)
        cell.politician.text = ads?[indexPath.row].person?.name ?? ""
        cell.date.text = convertDate(dateStr: ads![indexPath.row].created_date!)
        cell.tag = ads![indexPath.row].id!
        cell.deleteAdClb = {() in
                currentAdId = cell.tag
                SVProgressHUD.show()
                deleteAd(completion: { (error) in
                    if let error = error {
                        print("Didn't delete")
                        SVProgressHUD.dismiss()
                        error.alert(with: self, title: "Помилка", message: "Проблеми з сервером або iнтернетом")
                    } else {
                        getGarlics { () -> () in
                           print("Update Rating")
                        }
                        for (i, ad) in ads!.enumerated() {
                            if ad.id == currentAdId {
                                ads?.remove(at: i)
                            }
                        }
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                            SVProgressHUD.dismiss()
                        }
                    }
            })
        }
        
        let images = ads![indexPath.row].images!
        
        if (images.count > 0) {
            let urlString = images[0].image!
                if let url = URL(string: urlString) {
                    cell.adImageView.kf.indicatorType = .activity
                    cell.adImageView.kf.setImage(with: url, placeholder: UIImage(named: "logo_violet"))
                }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let selectedCell:UITableViewCell = tableView.cellForRow(at: indexPath as IndexPath)!
//        selectedCell.contentView.backgroundColor = UIColor(white: 1, alpha: 0.3)
        
        setCurrent(index: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180.0
    }
    
    func setCurrent(index: Int) {
        isAddAdsView = false
        currentAdsImageUrls = ads?[index].images!
        currentParty = ads?[index].party?.name ?? ""
        currentPolitician = ads?[index].person?.name ?? ""
        currentType = getTypeText(ads![index].type!)
        currentComment = ads?[index].comment ?? ""
        currentDate = convertDate(dateStr: ads![index].created_date!)
        performSegue(withIdentifier: "goToSingleAd", sender: nil)
    }
}
