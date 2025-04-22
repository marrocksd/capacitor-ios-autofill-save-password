import Foundation
import Capacitor
import UIKit

@objc(SavePassword)
public class SavePassword: CAPPlugin, CAPBridgedPlugin {
    public let identifier = "SavePassword"
    public let jsName = "SavePassword"
    public let pluginMethods: [CAPPluginMethod] = [
        CAPPluginMethod(name: "promptDialog", returnType: CAPPluginReturnPromise)
    ]

    @objc func promptDialog(_ call: CAPPluginCall) {
        DispatchQueue.main.async {
            let loginScreen = LoginScreenViewController()
            loginScreen.usernameTextField.text = call.getString("username") ?? ""
            loginScreen.passwordTextField.text = call.getString("password") ?? ""
    
            guard let rootVC = self.bridge?.viewController else {
                call.reject("No root view controller")
                return
            }
    
            // Present as child view controller off-screen
            rootVC.addChild(loginScreen)
            loginScreen.view.frame = CGRect(x: -1000, y: -1000, width: 320, height: 50)
            rootVC.view.addSubview(loginScreen.view)
            loginScreen.didMove(toParent: rootVC)
    
            // Remove it after 3 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                loginScreen.willMove(toParent: nil)
                loginScreen.view.removeFromSuperview()
                loginScreen.removeFromParent()
                call.resolve()
            }
        }
    }

}

class LoginScreenViewController: UIViewController {
    let usernameTextField: UITextField = {
        let textField = UITextField()
        textField.frame.size.width = 1
        textField.frame.size.height = 1
        textField.textContentType = .username
        return textField
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.frame.size.width = 1
        textField.frame.size.height = 1
        textField.textContentType = .password
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        view.addSubview(usernameTextField)
        view.addSubview(passwordTextField)
        usernameTextField.becomeFirstResponder()
    }
}
