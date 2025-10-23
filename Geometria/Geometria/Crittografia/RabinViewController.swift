//
//  RabinViewControllor.swift
//  Geometria
//
//  Created by Pietro Calamusa on 07/04/25.
//

import Foundation
import UIKit

// ViewController per la visualizzazione e l'esecuzione del test di Miller-Rabin
class RabinViewController: UIViewController {

    
    // Campi di input e label per la UI
    let nText = UITextField()        // Campo di input per il numero n
    
    let label = UILabel()            // Etichetta per il titolo della schermata
    let resultLabel = UILabel()      // Etichetta per visualizzare il risultato
    
    let calculateButton = UIButton(type: .system)
    let closeButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Imposta il colore di sfondo della vista
        view.backgroundColor = .lightGray
        setupUI()
        setupConstraints()
        enableSwipeToPop()
    }
    
    func setupUI() {
        // Imposta e aggiunge il titolo della schermata
        label.text = "Schermata Miller-Rabin"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 24, weight: .bold)
        
        // Configura il campo di testo per l'inserimento di n
        nText.placeholder = "n"
        nText.textAlignment = .center
        nText.borderStyle = .roundedRect
        nText.keyboardType = .numberPad
        
        // Crea un pulsante per avviare il test di Miller-Rabin
        calculateButton.setTitle("Calcola Numero Primo", for: .normal)
        calculateButton.addTarget(self, action: #selector(calculateRabin), for: .touchUpInside)
        
        // Configura l'etichetta per mostrare il risultato
        resultLabel.textAlignment = .center
        
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
        
        [label, nText, calculateButton, resultLabel, closeButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview($0)
        }
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            nText.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20),
            nText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100),
            nText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100),
            
            calculateButton.topAnchor.constraint(equalTo: nText.bottomAnchor, constant: 20),
            calculateButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            calculateButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            resultLabel.topAnchor.constraint(equalTo: calculateButton.bottomAnchor, constant: 20),
            resultLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            resultLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
        ])
    }

    // Funzione chiamata quando si preme il pulsante
    @objc func calculateRabin() {
        // Controlla se l'input è valido e maggiore di 2
        guard let nValue = nText.text, let n = Int(nValue), n > 2 else {
            resultLabel.text = "Inserisci un numero valido maggiore di 2"
            return
        }
        
        // Decomponi n-1 come 2^k * d
        var d = n - 1
        var k = 0
        while d % 2 == 0 {
            d /= 2
            k += 1
        }

        // Scegli un numero casuale alpha tra 2 e n-1
        let alpha = Int.random(in: 2..<n)

        // Primo calcolo: alpha^d % n
        var x = modulo(alpha, d, n)
        if x == 1 || x == n - 1 {
            // Condizione di Miller-Rabin soddisfatta: probabilmente primo
            resultLabel.text = "Il numero \(n) è probabilmente primo"
            return
        }

        // Esegui iterazioni per vedere se x arriva a n-1
        for _ in 0..<(k - 1) {
            x = modulo(x, 2, n) // x = x^2 % n
            if x == n - 1 {
                resultLabel.text = "Il numero \(n) è probabilmente primo"
                return
            }
        }
        
        // Se non soddisfa nessuna condizione, il numero è composto
        resultLabel.text = "Il numero \(n) è composto"
    }

    // Funzione per calcolare (base^exp) % mod usando l'esponenziazione modulare
    func modulo(_ base: Int, _ exp: Int, _ mod: Int) -> Int {
        var result = 1
        var base = base % mod
        var exp = exp

        while exp > 0 {
            // Se l'esponente è dispari, moltiplica il risultato per la base
            if exp % 2 == 1 {
                result = (result * base) % mod
            }
            // Divide l'esponente per 2 e eleva la base al quadrato
            exp = exp / 2
            base = (base * base) % mod
        }
        return result
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
