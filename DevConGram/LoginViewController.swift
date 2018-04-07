//
//  LoginViewController.swift
//  RWDevConGram
//
//  Created by Antoine Bellanger on 06.04.18.
//  Copyright © 2018 Antoine Bellanger. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var mainButton: UIButton!
    @IBOutlet var secondaryButton: UIButton!
    @IBOutlet var loginBackgroundImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        emailTextField.placeholder = "Email"
        emailTextField.delegate = self
        
        passwordTextField.placeholder = "Password"
        passwordTextField.isSecureTextEntry = true
        passwordTextField.delegate = self
        
        mainButton.setTitle("Log In", for: .normal)
        
        secondaryButton.setTitle("Sign Up", for: .normal)
        
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        blurView.frame = loginBackgroundImage.frame
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        loginBackgroundImage.addSubview(blurView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    //MARK: IBAction
    
    @IBAction func mainAction(_ sender: UIButton) {
        if mainButton.titleLabel?.text == "Log In" {
            print("Log In")
            //LogIn method
            
            guard emailTextField.text != "" else { self.showFieldAlert(); return }
            
            guard passwordTextField.text != "" else { self.showFieldAlert(); return }
            
            guard isValidEmail(emailTextField.text!) != false else { self.showEmailAlert(); return }
            
            Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { user, error in
                if error == nil && user != nil {
                    self.performSegue(withIdentifier: "pushToMain", sender: self)
                } else {
                    let alertController = UIAlertController(title: "Sorry !", message: error?.localizedDescription, preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                }
            }

            
        } else if mainButton.titleLabel?.text == "Sign Up" {
            //SignUp method
            print("Sign up")
            
            guard emailTextField.text != "" else { self.showFieldAlert(); return }
            
            guard passwordTextField.text != "" else { self.showFieldAlert(); return }
            
            guard isValidEmail(emailTextField.text!) != false else { self.showEmailAlert(); return }
            
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { user, error in
                if error == nil && user != nil {
                    self.performSegue(withIdentifier: "pushToMain", sender: self)
                } else {
                    let alertController = UIAlertController(title: "Sorry !", message: error?.localizedDescription, preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                }
            }
            
        } else {
            //ForgotPassword method
            print("Reset")
            
            guard emailTextField.text != "" else { self.showFieldAlert(); return }
            
            guard isValidEmail(emailTextField.text!) != false else { self.showEmailAlert(); return }
            
            Auth.auth().sendPasswordReset(withEmail: emailTextField.text!, completion: { (error) in
                
                if error != nil {
                    print("No error")
                } else {
                    print("error", error, error?.localizedDescription)
                }

            })
            
        }
    }
    
    @IBAction func forgotPassword(_ sender: UIButton) {
        mainButton.setTitle("Reset", for: .normal)
        secondaryButton.setTitle("Cancel", for: .normal)
        
        UIView.animate(withDuration: 0.5) {
            self.emailTextField.frame.origin.y = 30
            self.passwordTextField.frame.origin.x = -600
        }
    }
    
    @IBAction func toggleLoginSignUp(_ sender: UIButton) {
        if mainButton.titleLabel?.text == "Log In"{
            mainButton.setTitle("Sign Up", for: .normal)
            secondaryButton.setTitle("Log In", for: .normal)
        } else if mainButton.titleLabel?.text == "Sign Up" {
            mainButton.setTitle("Log In", for: .normal)
            secondaryButton.setTitle("Sign Up", for: .normal)
        } else if secondaryButton.titleLabel?.text == "Cancel" {
            mainButton.setTitle("Log In", for: .normal)
            secondaryButton.setTitle("Sign Up", for: .normal)
            UIView.animate(withDuration: 0.5) {
                self.emailTextField.frame.origin.y = 0
                self.passwordTextField.frame.origin.x = 15
            }
        } else {
            mainButton.setTitle("Reset", for: .normal)
        }
    }
    
    //MARK: Alert & Check
    
    func showFieldAlert() {
        let alertController = UIAlertController(title: "Wait !", message: "Please fill in all the fields !", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    func showEmailAlert() {
        let alertController = UIAlertController(title: "Nope", message: "Please enter a valid email address !", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let regEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let pred = NSPredicate(format:"SELF MATCHES %@", regEx)
        return pred.evaluate(with: email)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
