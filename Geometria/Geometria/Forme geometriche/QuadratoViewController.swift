//
//  QuadratoViewController.swift
//  Geometria
//
//  Created by Pietro Calamusa on 31/03/25.
//

import UIKit

class QuadratoViewController: UIViewController {
    
    let latoText = UITextField()
    
    let quadrato = UIView()
    
    let intro = UILabel()
    let resultAreaLabel = UILabel()
    let resultPerimeterLabel = UILabel()
    
    let calculateAreaButton = UIButton(type: .system)
    let calculatePerimeterButton = UIButton(type: .system)
    let updateButton = UIButton(type: .system)
    let closeButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        
        setupUI()
        setupConstraints()
        enableSwipeToPop()
    }
    
// MARK: - Funzione Setup
    func setupUI() {
        
        // Per il UITest
        intro.accessibilityIdentifier = "schermataQuadratoLabel"
        latoText.accessibilityIdentifier = "latoTextField"
        calculateAreaButton.accessibilityIdentifier = "calcolaAreaButton"
        calculatePerimeterButton.accessibilityIdentifier = "calcolaPerimetroButton"
        resultAreaLabel.accessibilityIdentifier = "risultatoAreaLabel"
        resultPerimeterLabel.accessibilityIdentifier = "risultatoPerimeterLabel"
        updateButton.accessibilityIdentifier = "aggiornaQuadratoButton"
        closeButton.accessibilityIdentifier = "chiudiButton"
        quadrato.accessibilityIdentifier = "quadratoView"
        
        [latoText].forEach {
            $0.borderStyle = .roundedRect           // Aggiunge un bordo arrotondato
            $0.textAlignment = .center              // Allineare tutti al centro
            $0.autocapitalizationType = .none       // Disabilita la capitalizzazione automatica
        }
        
        [resultAreaLabel, resultPerimeterLabel].forEach {
            $0.textAlignment = .center              // Allineare tutti al centro
        }
        
        // Aggiunge tutti gli elementi alla vista e disattiva l'autoresizing
        [intro, latoText, calculateAreaButton, calculatePerimeterButton, resultAreaLabel, resultPerimeterLabel, updateButton, closeButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        // Setting per Labels
        intro.text = "Schermata Quadrato"
        intro.numberOfLines = 0
        intro.translatesAutoresizingMaskIntoConstraints = false
        intro.textAlignment = .center
        intro.font = .systemFont(ofSize: 24, weight: .bold)
        
        // Setting per TextFields
        latoText.placeholder = "Lato del Quadrato"
        latoText.keyboardType = .numberPad
        latoText.textAlignment = .center
        latoText.layer.cornerRadius = 4
        latoText.layer.borderWidth = 1
        
        //Setting per Buttons
        calculateAreaButton.setTitle("Calcola Area", for: .normal)
        calculateAreaButton.addTarget(self, action: #selector(calculateArea), for: .touchUpInside)
        
        calculatePerimeterButton.setTitle("Calcola Perimetro", for: .normal)
        calculatePerimeterButton.addTarget(self, action: #selector(calcolaPerimetro), for: .touchUpInside)
        
        updateButton.setTitle("Aggiorna Quadrato", for: .normal)
        updateButton.addTarget(self, action: #selector(updateQuadratoSize), for: .touchUpInside)
        
        closeButton.setTitle("Chiudi", for: .normal)
        closeButton.addTarget(self, action: #selector(closeScreen), for: .touchUpInside)
        //closeButton.tintColor = .black
        //closeButton.backgroundColor = .red
        //closeButton.layer.cornerRadius = 10
        
        [calculateAreaButton, calculatePerimeterButton, updateButton].forEach {
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
        
        [closeButton].forEach {
            $0.layer.cornerRadius = 10
            $0.titleLabel?.textAlignment = .center
            $0.layer.borderWidth = 1
            $0.tintColor = .black
            $0.backgroundColor = .red
            $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        }
        
        // Creazione quardrato
        quadrato.frame = CGRect(x: 150, y: 500, width: 100, height: 100)
        quadrato.backgroundColor = .blue
        view.addSubview(quadrato)
    }
    
// MARK: - Funzione Constraints
    func setupConstraints() {
        NSLayoutConstraint.activate([
            
            // Vincoli per le Label
            intro.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            intro.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            intro.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            latoText.topAnchor.constraint(equalTo: intro.bottomAnchor, constant: 20),
            latoText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100),
            latoText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100),
            
            calculateAreaButton.topAnchor.constraint(equalTo: latoText.bottomAnchor, constant: 30),
            calculateAreaButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            calculateAreaButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            resultAreaLabel.topAnchor.constraint(equalTo: calculateAreaButton.bottomAnchor, constant: 30),
            resultAreaLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            resultAreaLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            calculatePerimeterButton.topAnchor.constraint(equalTo: resultAreaLabel.bottomAnchor, constant: 30),
            calculatePerimeterButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            calculatePerimeterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            resultPerimeterLabel.topAnchor.constraint(equalTo: calculatePerimeterButton.bottomAnchor, constant: 30),
            resultPerimeterLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            resultPerimeterLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            updateButton.topAnchor.constraint(equalTo: resultPerimeterLabel.bottomAnchor, constant: 30),
            updateButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            updateButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            quadrato.topAnchor.constraint(equalTo: updateButton.bottomAnchor, constant: 20),
            quadrato.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            //closeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
// MARK: - Funzioni
    @objc func calculateArea(_ sender: UIButton) {
        animateButtonTap(sender)
        if let latoTextValue = latoText.text, let lato = Double(latoTextValue) {
            resultAreaLabel.text = ""
            let area = lato * lato
            resultAreaLabel.text = "Area: \(area)"
            
            let notifica = Notification(name: Notification.Name("Area Quadrato"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(gestnot), name: Notification.Name("updateQuadratoSize"), object: nil)
            NotificationCenter.default.post(notifica)
            
        } else {
            resultAreaLabel.text = "Inserisci un numero valido"
        }
    }
    
    @objc func calcolaPerimetro(_ sender: UIButton) {
        animateButtonTap(sender)
        if let latoTextValue = latoText.text, let lato = Double(latoTextValue) {
            resultPerimeterLabel.text = ""
            let perimetro = 4 * lato
            resultPerimeterLabel.text = "Perimetro: \(perimetro)"
        } else {
            resultPerimeterLabel.text = "Inserisci un numero valido"
        }
    }
    
    
    @objc func updateQuadratoSize(_ sender: UIButton) {
        animateButtonTap(sender)
        if let latoValue = Double(latoText.text ?? "") {
            let maxSize: Double = 300
            let limitedLatoValue = min(latoValue, maxSize)
            let newSize = CGSize(width: CGFloat(limitedLatoValue), height: CGFloat(limitedLatoValue))
            let centerX = (view.bounds.width - newSize.width) / 2
            
            // Animazione di "fade out" prima del cambio
            UIView.animate(withDuration: 0.2, animations: {
                self.quadrato.alpha = 0.0
            }) { _ in
                self.quadrato.frame = CGRect(x: centerX, y: 500, width: newSize.width, height: newSize.height)
                self.quadrato.backgroundColor = .orange
                // Animazione di "fade in" dopo il cambio
                UIView.animate(withDuration: 0.2) {
                    self.quadrato.alpha = 1.0
                }
            }
        }
    }
    
    /*
     @objc func updateQuadratoSize() {
     if let latoValue = Double(latoText.text ?? "") {
     // Definisci la grandezza massima
     let maxSize: Double = 300 // Imposta qui il valore massimo che desideri
     
     // Limita il lato a non superare la grandezza massima
     let limitedLatoValue = min(latoValue, maxSize)
     
     // Calcola la nuova larghezza e altezza con il lato limitato
     let newSize = CGSize(width: CGFloat(limitedLatoValue), height: CGFloat(limitedLatoValue))
     
     // Calcola la posizione centrata
     let centerX = (view.bounds.width - newSize.width) / 2
     //let centerY = (view.bounds.height - newSize.height) / 2
     
     UIView.animate(withDuration: 0.3) {
     self.quadrato.frame = CGRect(x: centerX, y: 500, width: newSize.width, height: newSize.height)
     self.quadrato.backgroundColor = .orange
     }
     }
     }
     */
    
    @objc func gestnot(_ notification: Notification){
        print("Ricevuta notifica: \(notification.name)")
    }
    
    @objc func closeScreen() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { // Ritardo di 0.3 secondi
            UIView.animate(withDuration: 0.3, animations: {
                self.view.alpha = 1 // Anima la scomparsa (fade out)
            }) { _ in
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func animateButtonTap(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                sender.transform = CGAffineTransform.identity
            }
        }
    }
}
