import Foundation
import UIKit
import MapKit
import SVProgressHUD
import ClusterKit

// USER

func setCurrentUser (token: String, email: String, name: String, pictureUrl: String, garlics: Int) {
    currentUserName = name
    currentUserGarlics = garlics

    if let currentPictureUrl = currentPictureUrl {
        if let url = NSURL(string: currentPictureUrl) {
            DispatchQueue.main.async {
                let imageData = NSData(contentsOf: url as URL)
                DispatchQueue.main.async {
                    if let imageData = imageData {
                        currentUserImage = UIImage(data: imageData as Data)
                    } else {
                        print("no photo loaded")
                        currentUserImage = UIImage(named: "icon_profile")!
                    }
                }
            }
        } else {
            print("no photo")
            currentUserImage = UIImage(named: "icon_profile")!
        }
    }
}

// UI

// Spinner, native

func showIndicator (_ show: Bool, indicator: UIActivityIndicatorView) {
    DispatchQueue.main.async {
        indicator.isHidden = !show
        
        if show {
            indicator.startAnimating()
        } else {
            indicator.stopAnimating()
        }
    }
}

/// Extending error to make it alertable
extension Error {
    
    /// displays alert from source controller
    func alert(with controller: UIViewController, title: String = "Помилка завантаження", message: String) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            controller.present(alertController, animated: true, completion: nil)
        }
    }
}

// Notifications
struct Toast {}

extension Toast {
    
    /// displays alert from source controller
    func alert(with controller: UIViewController, title: String = "Помилка завантаження", message: String) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            controller.present(alertController, animated: true, completion: nil)
        }
    }
}

// Add shadow
func addBottomShadow (_ view: UIView) {
    view.layer.masksToBounds = false
    view.layer.shadowRadius = 3
    view.layer.shadowOpacity = 1
    view.layer.shadowColor = UIColor.gray.cgColor
    view.layer.shadowOffset = CGSize(width: 0 , height: 1.5)
}

// Words ending
func getWordEnd(for count: Int, one: String = "ка", few: String = "ки", alot: String = "кiв") -> String {
    if count == 1 {
        return "ок"
    }
    if count == 0 {
        return "кiв"
    }
    let clearCount = count % 100
    let lastNumber = clearCount % 10
    if lastNumber == 1 && clearCount != 11 {
        return one;
    }
    if [2,3,4].contains(lastNumber) && ![12,13,14].contains(clearCount) {
        return few;
    }
    return alot;
}

// JSON settings
func getTypeText (_ typeInt: Int) -> String {
    if typeInt == 1 {
        return "Бігборд"
    } else if typeInt == 2 {
        return "Сітілайт"
    } else if typeInt == 3 {
        return "Газета"
    } else if typeInt == 4 {
        return "Листівка"
    } else if typeInt == 5 {
        return "Намет"
    } else if typeInt == 6 {
        return "Транспорт"
    } else {
        return "Інше"
    }
}

func getTypeInt (_ typeText: String) -> Int {
    if typeText == "Бігборд" {
        return 1
    } else if typeText == "Сітілайт" {
        return 2
    } else if typeText == "Газета" {
        return 3
    } else if typeText == "Листівка" {
        return 4
    } else if typeText == "Намет" {
        return 5
    } else if typeText == "Транспорт" {
        return 6
    } else {
        return 7
    }
}

// Date

func convertDate (dateStr : String) -> String {
    let formatter = DateFormatter()
    formatter.calendar = Calendar(identifier: .gregorian)
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
    formatter.timeZone = TimeZone(abbreviation: "UTC")
    if let date = formatter.date(from: dateStr) {
        formatter.locale = Locale(identifier: "uk_UA")
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.dateFormat = "MMM d, HH:mm"
        let string = formatter.string(from: date)
        return string.capitalized
    } else {
        return dateStr
    }
}

func getDateNow () -> String {
    let format = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
    let date = Date()
    return dateFormatter.string(from: date)
}


// VALIADATION
func isValidEmail(testStr:String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: testStr)
}

// SAVE USER
func saveUserToStorage () {
    let defaults = UserDefaults.standard
    defaults.set(isLogged, forKey: "isLogged")
    defaults.set(isFacebook, forKey: "isFacebook")
    defaults.set(currentUserName, forKey: "name")
    defaults.set(currentUserGarlics, forKey: "garlics")
    defaults.set(currentUserImage!.jpegData(compressionQuality: 1.0), forKey: "image")
    defaults.set(currentPictureUrl, forKey: "imageUrl")
}

func saveUserGarlicsToStorage () {
    let defaults = UserDefaults.standard
    defaults.set(currentUserGarlics, forKey: "garlics")
}

func setCurrentUserData () {
    currentUserName = defaults.string(forKey: "name")
    currentUserGarlics = defaults.integer(forKey: "garlics")
    let userImageUrl = defaults.string(forKey: "imageUrl")
    if let userImageUrl = userImageUrl {
        if let url = NSURL(string: userImageUrl) {
            DispatchQueue.main.async {
                let imageData = NSData(contentsOf: url as URL)
                DispatchQueue.main.async {
                    if let imageData = imageData {
                        currentUserImage = UIImage(data: imageData as Data)
                    } else {
                        print("no photo loaded")
                        currentUserImage = UIImage(named: "icon_profile")!
                    }
                }
            }
        } else {
            print("no photo")
            currentUserImage = UIImage(named: "icon_profile")!
        }
    } else {
        print("no url photo")
        currentUserImage = UIImage(named: "icon_profile")!
    }
    
    isFacebook = defaults.bool(forKey: "isFacebook")
    isLogged = defaults.bool(forKey: "isLogged")
}


// LOGINIZATION
func loginToServerEmail(email: String, password: String, completion: @escaping (()->())) {
    loginUserEmail(url: API_URL + "/login/email/", email: email, password: password) { (error) in
        if error == nil {
            loadUserData(token: "", isFacebookLogin: false, completion: { completion()} )
        } else {
            SVProgressHUD.showError(withStatus: "Помилка завантаження")
            SVProgressHUD.dismiss(withDelay: 1.5)
        }
    }
}

func loginToServerFB(token: String, email: String, name: String, pictureUrl: String, completion: @escaping (()->())) {
    loginUserFB(url: API_URL + "/login/facebook/", token: token, email: email, name: name, pictureUrl: pictureUrl) { (data, error) in
        if let error = error {
            print("ERROR WAR", error)
            SVProgressHUD.showError(withStatus: "Помилка завантаження")
            SVProgressHUD.dismiss(withDelay: 1.5)
            return
        }
        
        loadUserData(token: token, isFacebookLogin: true, completion: { completion() })
    }
}

func loadUserData (token: String, isFacebookLogin: Bool, completion: @escaping (()->())) {
    getUserData(url: API_URL + "/profile/", token: token) { (json, error) in
        SVProgressHUD.dismiss()
        if let error = error {
            print("ERROR WAR", error)
            SVProgressHUD.showError(withStatus: "Помилка завантаження")
            SVProgressHUD.dismiss(withDelay: 1.5)
            return
        }
        
        if let jsonData = json {
            if let email = jsonData.email {
                setCurrentUser(token: token, email: email, name: jsonData.name!, pictureUrl: jsonData.picture ?? "", garlics: jsonData.rating!)
                isFacebook = isFacebookLogin
                loggedSuccessfully(completion:  { completion() })
            } else {
                SVProgressHUD.showError(withStatus: "Перевірте ваші дані")
                SVProgressHUD.dismiss(withDelay: 1.5)
            }
        }
    }
}

func loggedSuccessfully (completion: @escaping (() -> ())) {
    isLogged = true
    saveUserToStorage ()
    SVProgressHUD.showSuccess(withStatus: "Ласкаво просимо")
    SVProgressHUD.dismiss(withDelay: 1.0) { completion() }
}

// Additional Types
struct UserData: Decodable {
    var email: String?
    var rating: Int?
    var name: String?
    var picture: String?
}

// Get adress
func getAdress(_ location: CLLocation?, completion: @escaping (_ address: JSONDictionary?, _ error: Error?) -> ()) {
    
    if let currentLocation = location {
        
        let geoCoder = CLGeocoder()
        
        geoCoder.reverseGeocodeLocation(currentLocation) { placemarks, error in
            
            if let e = error {
                
                completion(nil, e)
                
            } else {
                
                let placeArray = placemarks
                
                var placeMark: CLPlacemark!
                
                placeMark = placeArray?[0]
                
                guard let address = placeMark.addressDictionary as? JSONDictionary else {
                    return
                }
                
                completion(address, nil)
                
            }
            
        }
    }
}

func setCurrentAdress (_ location: CLLocation?) {
    
    getAdress (location) { address, error in
        if let a = address, let street = a["Street"] as? String, let city = a["City"] as? String, let country = a["Country"] as? String {
            currentLocation = "\(street), \(city), \(country)"
        } else {
            currentLocation = "Невiдомо"
        }
    }
}

// MARKERS // MAP
func getResizedMarker (_ image: UIImage) -> UIImage {
    var resizedImage = image
    resizedImage = image.resize(toWidth: 40.0)!
    resizedImage = image.resize(toHeight: 40.0)!
    return resizedImage
}

class MyAnnotation: NSObject, MKAnnotation {
    weak public var cluster: CKCluster?
    let title: String?
    let subtitle: String?
    let party: String?
    let images: [AdImage]
    let politician: String?
    let date: String?
    let comment: String?
    let coordinate: CLLocationCoordinate2D
    var image: UIImage? = nil
    var id: Int? = nil
    var user: Int? = nil
    var type: Int?
    //    var grouped: Bool? = nil
    
    init(id: Int, user: Int, coordinate: CLLocationCoordinate2D, party: String, politician: String, date: String, comment: String, type: Int, images: [AdImage]) {
        self.title = ""
        self.subtitle = ""
        self.id = id
        self.user = user
        self.coordinate = coordinate
        self.party = party
        self.politician = politician
        self.date = date
        self.comment = comment
        self.type = type
        self.images = images
        //        super.init()
    }
}

func setSingleMarkerData(id: Int = 0, user: Int = 0,party: String = "", politician: String = "", date: String = "", comment: String = "", type: Int = 0, images: [AdImage] = [AdImage]() ) {
    singleId = id
    singleUser = user
    singleMarkerParty = party
    singleMarkerPolitician = politician
    singleMarkerDate = date
    singleMarkerComment = comment
    singleMarkerType = getTypeText(type)
    singleMarkerAdImageArray = images
}

func resetSingleMarkerData () {
    singleMarkerParty = ""
    singleMarkerPolitician = ""
    singleMarkerDate = ""
    singleMarkerComment = ""
    singleMarkerType = ""
    singleMarkerAdImageArray = [AdImage]()
}
