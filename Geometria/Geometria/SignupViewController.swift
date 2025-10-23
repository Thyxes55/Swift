//
//  SignupViewController.swift
//  Geometria
//
//  Created by Pietro Calamusa on 25/04/25.
//

import UIKit
import SwiftKeychainWrapper

class SignupViewController: UIViewController {
    
    let introLabel = UILabel()
    
    let usernameTextField = UITextField() // Campo di testo per inserire l'username
    let passwordTextField = UITextField() // Campo di testo per inserire la password
    
    let loginButton = UIButton(type: .system) // Bottone per il login
    let signUpButton = UIButton(type: .system) // Bottone per il signUp
    
    // Stack Views per i bottoni
    let buttonStackView1 = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray // Imposta lo sfondo della vista su bianco.
        
        setupUI()               // Configura le proprietà degli elementi UI.
        setupConstraints()      // Aggiunge i vincoli per il layout.
    }
    
    func setupUI() {
        
        introLabel.text = "Sign Up"
        introLabel.font = .systemFont(ofSize: 24, weight: .bold)
        introLabel.textAlignment = .center
        
        usernameTextField.placeholder = "Enter your username"
        usernameTextField.textContentType = .username  // 🔑 fondamentale per autofill
        
        
        passwordTextField.placeholder = "Enter your password"
        passwordTextField.isSecureTextEntry = true
        passwordTextField.textContentType = .password  // 🔑 fondamentale per autofill
        
        // Configura i campi di testo
        [usernameTextField, passwordTextField].forEach {
            $0.borderStyle = .roundedRect           // Aggiunge un bordo arrotondato
            $0.textAlignment = .center              // Allineare tutti al centro
            $0.autocapitalizationType = .none       // Disabilita la capitalizzazione automatica
        }
        
        // Configura il bottone di login
        loginButton.setTitle("Torna al login", for: .normal) // Imposta il titolo del bottone
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside) // Collega l'azione al bottone
        
        signUpButton.setTitle("Sign Up", for: .normal)
        signUpButton.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
        
        // Configura StackView 1
        buttonStackView1.axis = .horizontal
        buttonStackView1.distribution = .fillEqually // O .equalSpacing
        buttonStackView1.spacing = 10 // Spazio tra i bottoni
        buttonStackView1.translatesAutoresizingMaskIntoConstraints = false
        [loginButton, signUpButton].forEach {
            buttonStackView1.addArrangedSubview($0)
        }
        
        [loginButton, signUpButton].forEach {
            $0.layer.cornerRadius = 10
            $0.layer.borderWidth = 1
            $0.titleLabel?.textAlignment = .center
            $0.tintColor = .blue
            $0.backgroundColor = .lightGray
            $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
            $0.layer.shadowOpacity = 0.5
            $0.layer.shadowOffset = CGSize(width: 0, height: 5)
            $0.layer.shadowRadius = 5
        }
        
        // Aggiunge tutti gli elementi alla vista e disattiva l'autoresizing
        [usernameTextField, passwordTextField, introLabel, buttonStackView1].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            // Intro label
            introLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            introLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // Username text field
            usernameTextField.topAnchor.constraint(equalTo: introLabel.bottomAnchor, constant: 30),
            usernameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            usernameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // Password text field
            passwordTextField.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 10),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // StackView 1 (prima riga di bottoni)
            buttonStackView1.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 30), // Spazio sopra la prima riga
            buttonStackView1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonStackView1.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }
    
    @objc func signUpTapped() {

        let username = usernameTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        /*
            let saveSuccessfully: Bool = KeychainWrapper.standard.set(password, forKey: username)
            if saveSuccessfully {
                print("Password salvata con successo!")
                // Esegui qui le azioni da intraprendere in caso di successo
            } else {
                print("Errore durante il salvataggio della password.")
                // Esegui qui le azioni da intraprendere in caso di fallimento
            }
        */
        
        let controlUser = KeychainWrapper.standard.string(forKey: username)
        
        // Controllo se l'username già esiste oppure no
        if controlUser != username {
            KeychainWrapper.standard.set(password, forKey: username)
            let alert = UIAlertController(title: "Success", message: "User Signup Successful!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        } else {
            // Se le credenziali non sono corrette, mostra un messaggio di errore
            let alert = UIAlertController(title: "Errore", message: "Username already exists!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func loginTapped() {
        let loginVC = LoginViewController()
        loginVC.modalPresentationStyle = .fullScreen
        loginVC.modalTransitionStyle = .crossDissolve
        present(loginVC, animated: true, completion: nil)
        
    }
}
