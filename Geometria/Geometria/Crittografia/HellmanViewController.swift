//
//  HellmanViewController.swift
//  Geometria
//
//  Created by Pietro Calamusa on 07/04/25.
//

import UIKit

class HellmanViewController: UIViewController {

    let qText = UITextField()        // Campo di input per il numero primo q
    
    let introlabel = UILabel()       // Etichetta per il titolo della schermata
    let resultLabel = UILabel()      // Etichetta per visualizzare la radice primitiva
    let result2Label = UILabel()     // Etichetta per visualizzare la chiave di sessione
    
    let calculateButton = UIButton(type: .system)   // Pulsante per calcolare la chiave di sessione K
    let closeButton = UIButton(type: .system)       // Pulsante per chiudere la schermata
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        setupUI()
        setupConstraints()
        enableSwipeToPop()
    }
    
    func setupUI() {
        // Etichetta del titolo della schermata
        introlabel.text = "Schermata Diffie-Hellman"
        introlabel.textAlignment = .center
        introlabel.font = .systemFont(ofSize: 24, weight: .bold)
        
        // Configura il campo di testo per l'inserimento di q (numero primo)
        qText.placeholder = "q"
        qText.borderStyle = .roundedRect
        qText.keyboardType = .numberPad
        qText.textAlignment = .center

        calculateButton.setTitle("Calcola la chiave di sessione K", for: .normal)
        calculateButton.addTarget(self, action: #selector(calculateDiffie), for: .touchUpInside)
        
        // Etichetta per visualizzare la radice primitiva
        resultLabel.textAlignment = .center
        
        // Etichetta per visualizzare la chiave di sessione
        result2Label.textAlignment = .center
        
        closeButton.setTitle("Chiudi", for: .normal)
        closeButton.addTarget(self, action: #selector(closeScreen), for: .touchUpInside)
        
        [calculateButton].forEach {
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
        
        [introlabel, qText, calculateButton, resultLabel, result2Label, closeButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview($0)
        }
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            introlabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            introlabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            introlabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            qText.topAnchor.constraint(equalTo: introlabel.bottomAnchor, constant: 20),
            qText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100),
            qText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100),
            
            calculateButton.topAnchor.constraint(equalTo: qText.bottomAnchor, constant: 20),
            calculateButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            calculateButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            resultLabel.topAnchor.constraint(equalTo: calculateButton.bottomAnchor, constant: 20),
            resultLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            resultLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            result2Label.topAnchor.constraint(equalTo: resultLabel.bottomAnchor, constant: 20),
            result2Label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            result2Label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            ])
    }
    
    // Funzione chiamata quando l'utente preme il pulsante "Calcola la chiave di sessione K"
    @objc func calculateDiffie(){
        // Estrae il valore di q dall'input
        if let qtext = qText.text, let q = Int(qtext) {
            // Genera una chiave privata casuale Xa
            let Xa = Int.random(in: 1...q-1)
            
            // Calcola la radice primitiva per il valore di q
            if let root = primitiveRoot(of: q) {
                resultLabel.text = "La radice primitiva è: \(root)"
            } else {
                resultLabel.text = "Nessuna radice primitiva trovata."
            }
            
            // Genera una chiave pubblica Yb
            let Yb = Int.random(in: 1...20)
            
            // Calcola la chiave di sessione K usando l'esponenziazione modulare
            let K = modulo(base: Yb, exponent: Xa, mod: q)
            
            // Mostra la chiave di sessione
            result2Label.text = "La chiave di sessione K è: \(K)"
        }
    }
    
    // Funzione per calcolare i fattori di un numero
    func radprime(_ n: Int) -> Int {
        let x: Int = 2
        var array = [Int]()
        
        for y in 1..<n{
            if n % y == 0 {
                array.append(y)
            }
        }
        print(array[2])  // Stampa il terzo fattore (potenzialmente inutile)
        
        return x
    }
    
    // Funzione che verifica se un numero è primo
    func isPrime(_ n: Int) -> Bool {
        if n < 2 { return false }
        for i in 2...Int(sqrt(Double(n))) {
            if n % i == 0 { return false }
        }
        return true
    }
    
    // Funzione per eseguire l'esponenziazione modulare
    func modulo(base: Int, exponent: Int, mod: Int) -> Int {
        var result = 1
        var base = base % mod
        var exponent = exponent
        
        // Esponenziazione rapida per calcolare base^exponent % mod
        while exponent > 0 {
            if exponent % 2 == 1 {
                result = (result * base) % mod
            }
            exponent = exponent / 2
            base = (base * base) % mod
        }
        
        return result
    }

    // Funzione per calcolare la radice primitiva modulo q
    func primitiveRoot(of q: Int) -> Int? {
        guard q > 1, isPrime(q) else {
            print("Il numero \(q) non è primo.")
            return nil
        }
        
        let phi = q - 1  // poiché q è primo, phi(q) = q - 1
        var factors: [Int] = []
        
        // Trova i fattori primi di phi(q)
        var n = phi
        for i in 2...phi {
            while n % i == 0 {
                factors.append(i)
                n /= i
            }
        }
        
        // Cerca una radice primitiva
        for g in 2..<q {
            var isPrimitive = true
            for factor in factors {
                let power = phi / factor
                if modulo(base: g, exponent: power, mod: q) == 1 {
                    isPrimitive = false
                    break
                }
            }
            if isPrimitive {
                return g
            }
        }
        
        return nil  // Nessuna radice primitiva trovata
    }
    
    // Funzione per chiudere la schermata
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
