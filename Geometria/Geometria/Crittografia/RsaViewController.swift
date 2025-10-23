//
//  RsaViewController.swift
//  Geometria e Crittografia
//
//  Created by Pietro Calamusa on 01/04/25.
//

import Foundation
import UIKit

class RsaViewController: UIViewController {

    // Dichiarazione dei campi di input e delle etichette
    let pText = UITextField()        // Campo di input per il primo numero primo P
    let qText = UITextField()        // Campo di input per il secondo numero primo Q
    let eText = UITextField()        // Campo di input per l'esponente pubblico E
    let mText = UITextField()        // Campo di input per il messaggio M
    
    let label = UILabel()            // Etichetta per il titolo della schermata
    let resultLabel = UILabel()      // Etichetta per mostrare il risultato cifrato
    let resultchiaviLabel = UILabel() // Etichetta per visualizzare le chiavi pubbliche e private
    let resultmLabel = UILabel()    // Etichetta per visualizzare il risultato del messaggio decifrato
    
    let calculateButton = UIButton(type: .system)
    let closeButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configurazioni iniziali della view
        view.backgroundColor = .lightGray
        
        setupUI()
        setupConstraints()
       
        enableSwipeToPop()
    }
    
    func setupUI() {
        // Etichetta del titolo
        label.text = "Schermata Rsa"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 24, weight: .bold)
        
        // Configurazione dei campi di testo per P, Q, E e M
        pText.textAlignment = .center
        pText.placeholder = "P"
        pText.borderStyle = .roundedRect
        pText.keyboardType = .numberPad
        
        qText.textAlignment = .center
        qText.placeholder = "Q"
        qText.borderStyle = .roundedRect
        qText.keyboardType = .numberPad
        
        eText.textAlignment = .center
        eText.placeholder = "E"
        eText.borderStyle = .roundedRect
        eText.keyboardType = .numberPad
        
        mText.textAlignment = .center
        mText.placeholder = "M"
        mText.borderStyle = .roundedRect
        mText.keyboardType = .numberPad
        
        // Pulsante per calcolare il messaggio cifrato
        calculateButton.setTitle("Calcola Messaggio Privato", for: .normal)
        calculateButton.addTarget(self, action: #selector(calculateRsa), for: .touchUpInside)
        
        // Etichetta per visualizzare le chiavi pubbliche e private
        resultchiaviLabel.textAlignment = .center
        
        // Etichetta per visualizzare il risultato cifrato
        resultLabel.textAlignment = .center
        
        // Etichetta per visualizzare il messaggio decifrato
        resultmLabel.textAlignment = .center
        
        // Pulsante per chiudere la schermata
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
        
        [label, pText, qText, eText, mText, calculateButton, resultchiaviLabel, resultLabel, resultmLabel, closeButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview($0)
        }
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            pText.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20),
            pText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100),
            pText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100),
            
            qText.topAnchor.constraint(equalTo: pText.bottomAnchor, constant: 20),
            qText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100),
            qText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100),
            
            eText.topAnchor.constraint(equalTo: qText.bottomAnchor, constant: 20),
            eText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100),
            eText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100),
            
            mText.topAnchor.constraint(equalTo: eText.bottomAnchor, constant: 20),
            mText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100),
            mText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100),
            
            calculateButton.topAnchor.constraint(equalTo: mText.bottomAnchor, constant: 20),
            calculateButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            calculateButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            resultchiaviLabel.topAnchor.constraint(equalTo: calculateButton.bottomAnchor, constant: 20),
            resultchiaviLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            resultchiaviLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            resultLabel.topAnchor.constraint(equalTo: resultchiaviLabel.bottomAnchor, constant: 10),
            resultLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            resultLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            resultmLabel.topAnchor.constraint(equalTo: resultLabel.bottomAnchor, constant: 20),
            resultmLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            resultmLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            ])
    }
    
    // Funzione per calcolare la cifratura e decifratura RSA
    @objc func calculateRsa() {
        // Recupera i valori inseriti nei campi di testo
        if let pValue = pText.text, let p = Int(pValue),let qValue = qText.text, let q = Int(qValue), let eValue = eText.text, let e = Int(eValue), let mValue = mText.text, let m = Int(mValue) {
            
            // Calcola phi(n) dove n = p * q
            let phin = (p - 1) * (q - 1)
            
            // Calcola d come inverso modulo di e
            guard let d = moduloInverso(a: e, m: phin) else { return }
            
            // Calcola n come il prodotto di p e q
            let n = p * q
            
            // Cifra il messaggio
            let mc = modulo(m, e, n) % n
            resultchiaviLabel.text = "La PU è (\(e),\(n)) e il PR è (\(d),\(n))"
            resultLabel.text = "Il messaggio cifrato è: \(mc)"
            
            // Decifra il messaggio
            let md = modulo(mc, d, n) % n
            resultmLabel.text = "Il messaggio decifrato è: \(md)"
        } else {
            resultLabel.text = "Inserisci dei numeri validi"
        }
    }
    
    // Funzione per calcolare la potenza modulare (m^e) % n usando esponenziazione rapida
    func modulo(_ m: Int, _ e: Int, _ n: Int) -> Int {
        // Decomposizione in binario dell'esponente
        let arrayBinaryDecomposition = binaryDecompositionArray(e)
        var risultato: Int = 0
        var temp: Int = 1
        
        // Calcola la potenza modulare usando la decomposizione binaria
        for i in arrayBinaryDecomposition {
            if i == 1 {
                risultato = m
                temp *= risultato
            } else if i == 0 {
                risultato = (risultato * risultato) % n
            } else {
                risultato = (risultato * risultato) % n
                temp *= risultato
            }
        }
        return temp
    }
    
    // Funzione per decomporre un numero in binario
    func binaryDecompositionArray(_ n: Int) -> [Int] {
        var result: [Int] = []
        var num = n
        var power = 1
        
        while num > 0 {
            if num & 1 == 1 {
                result.append(power)  // Aggiungi la potenza di 2 se il bit è 1
            } else {
                result.append(0)  // Aggiungi uno zero se il bit è 0
            }
            power *= 2
            num >>= 1
        }
        
        return result
    }
    
    // Funzione per calcolare l'inverso modulo di a rispetto a m usando l'algoritmo di Euclide esteso
    func moduloInverso(a: Int, m: Int) -> Int? {
        var m0 = m, y = 0, x = 1
        var a = a

        if m == 1 { return nil }

        while a > 1 {
            let q = a / m0
            var t = m0

            m0 = a % m0
            a = t
            t = y

            y = x - q * y
            x = t
        }

        return x < 0 ? x + m : x
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
