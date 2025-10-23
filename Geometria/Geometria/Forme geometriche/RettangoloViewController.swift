//
//  RettangoloViewController.swift
//  Geometria e Crittografia
//
//  Created by Pietro Calamusa on 31/03/25.
//

import UIKit

class RettangoloViewController: UIViewController {
    
    let baseText = UITextField()
    let altezzaText = UITextField()
    
    let resultArea = UILabel()
    let resultPerimeter = UILabel()
    let intro = UILabel()
    
    let rettangolo = UIView()
    
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
    
    func setupUI() {
        
        intro.text = "Schermata Rettangolo"
        intro.numberOfLines = 0
        intro.translatesAutoresizingMaskIntoConstraints = false
        intro.textAlignment = .center
        intro.font = .systemFont(ofSize: 24, weight: .bold)
        
        baseText.placeholder = "Base"
        
        altezzaText.placeholder = "Altezza"
        
        calculateAreaButton.setTitle("Calcola Area", for: .normal)
        calculateAreaButton.addTarget(self, action: #selector(calculateAreaRettangolo), for: .touchUpInside)
        
        calculatePerimeterButton.setTitle("Calcola Perimetro", for: .normal)
        calculatePerimeterButton.addTarget(self, action: #selector(calculatePerimetroRettangolo), for: .touchUpInside)
        
        updateButton.setTitle("Aggiorna Rettangolo", for: .normal)
        updateButton.addTarget(self, action: #selector(updateRectangleSize), for: .touchUpInside)
    
        // Creazione rettangolo
        rettangolo.frame = CGRect(x: 100, y: 550, width: 200, height: 100)
        rettangolo.backgroundColor = .blue
        view.addSubview(rettangolo)
        
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
        
        [intro, resultArea, resultPerimeter].forEach {
            $0.textAlignment = .center
        }
        
        [baseText, altezzaText].forEach {
            $0.textAlignment = .center
            $0.borderStyle = .roundedRect
            $0.keyboardType = .numberPad
        }
        
        [intro, baseText, altezzaText, resultArea, resultPerimeter, calculateAreaButton, calculatePerimeterButton, updateButton, closeButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        closeButton.setTitle("Chiudi", for: .normal)
        closeButton.addTarget(self, action: #selector(closeScreen), for: .touchUpInside)
        [closeButton].forEach {
            $0.layer.cornerRadius = 10
            $0.titleLabel?.textAlignment = .center
            $0.layer.borderWidth = 1
            $0.tintColor = .black
            $0.backgroundColor = .red
            $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        }
        
    }
    
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            
            // Vincoli per le Label
            intro.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            intro.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            intro.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            baseText.topAnchor.constraint(equalTo: intro.bottomAnchor, constant: 20),
            baseText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100),
            baseText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100),
            
            altezzaText.topAnchor.constraint(equalTo: baseText.bottomAnchor, constant: 20),
            altezzaText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100),
            altezzaText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100),
            
            calculateAreaButton.topAnchor.constraint(equalTo: altezzaText.bottomAnchor, constant: 40),
            calculateAreaButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            calculateAreaButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            resultArea.topAnchor.constraint(equalTo: calculateAreaButton.bottomAnchor, constant: 20),
            resultArea.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            resultArea.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            calculatePerimeterButton.topAnchor.constraint(equalTo: resultArea.bottomAnchor, constant: 20),
            calculatePerimeterButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            calculatePerimeterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            resultPerimeter.topAnchor.constraint(equalTo: calculatePerimeterButton.bottomAnchor, constant: 20),
            resultPerimeter.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            resultPerimeter.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            updateButton.topAnchor.constraint(equalTo: resultPerimeter.bottomAnchor, constant: 30),
            updateButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            updateButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            // Vincoli per le UIView
            rettangolo.topAnchor.constraint(equalTo: updateButton.bottomAnchor, constant: 20),
            rettangolo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    @objc func calculateAreaRettangolo() {
        if let baseTextValue = baseText.text, let base = Double(baseTextValue),let altezzaTextValue = altezzaText.text, let altezza = Double(altezzaTextValue) {
            resultArea.text = ""
            let area = base * altezza
            resultArea.text = "Area: \(area)"
        } else {
            resultArea.text = "Inserisci un numero valido"
        }
    }
    
    @objc func calculatePerimetroRettangolo() {
        if let baseTextValue = baseText.text, let base = Double(baseTextValue),let altezzaTextValue = altezzaText.text, let altezza = Double(altezzaTextValue) {
            resultPerimeter.text = ""
            let perimetro = 2 * (base + altezza)
            resultPerimeter.text = "Perimetro: \(perimetro)"
        } else {
            resultPerimeter.text = "Inserisci un numero valido"
        }
    }
    
    @objc func updateRectangleSize() {
            // Conversione valori
            if let baseValue = Double(baseText.text ?? ""),
               let altezzaValue = Double(altezzaText.text ?? "") {
                
                let maxbase: Double = 300
                let maxaltezza: Double = 150
                
                let limitedbase = min(baseValue, maxbase)
                let limitedaltezza = min(altezzaValue, maxaltezza)
                
                // Calcola la nuova larghezza e altezza
                let newSize = CGSize(width: CGFloat(limitedbase), height: CGFloat(limitedaltezza))
                
                // Calcola la posizione centrata
                let centerX = (view.bounds.width - newSize.width) / 2
                //let centerY = (view.bounds.height - newSize.height) / 2
                
                UIView.animate(withDuration: 0.3) {
                    self.rettangolo.frame = CGRect(x: centerX, y: 550, width: newSize.width, height: newSize.height)
                    self.rettangolo.backgroundColor = .orange
                }
            }
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
}
