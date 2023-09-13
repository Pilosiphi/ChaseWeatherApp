import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    func displayAlertErrorMessage(with error: BaseError) {
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        displayAlertErrorMessage(with: error, and: defaultAction)
    }
    
    func displayAlertErrorMessage(with error: BaseError, and customAction: UIAlertAction) {
        let alertController = UIAlertController(title: error.title, message: error.message, preferredStyle: .alert)
        alertController.addAction(customAction)
        
        DispatchQueue.main.async { [weak self] in
            guard let weakSelf = self, weakSelf.presentedViewController == nil else {
                return
            }
            weakSelf.present(alertController, animated: true, completion: nil)
        }
    }
}
