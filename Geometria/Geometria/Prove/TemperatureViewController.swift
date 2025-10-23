//
//  TemperatureViewController.swift
//  Geometria
//
//  Created by Pietro Calamusa on 08/04/25.
//

import UIKit

// Questa classe rappresenta una schermata per convertire temperature (es. Celsius ↔ Fahrenheit)
class TemperatureViewController: UIViewController {

    // Campo di input per inserire la temperatura da convertire
    let tText = UITextField()

    // Etichetta in alto con il titolo della schermata
    let label = UILabel()

    // Etichetta che mostra il risultato della conversione
    let resultLabel = UILabel()

    // UISegmentedControl per scegliere il tipo di conversione
    let switchControl = UISegmentedControl()
    
    // UIProgressView per vedere una barra progressiva
    let progressView = UIProgressView(progressViewStyle: .default)
    
    let iconImageView = UIImageView()
    let icon2ImageView = UIImageView()
    
    let calculateButton = UIButton(type: .system)
    let closeButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Imposta il colore di sfondo della schermata
        view.backgroundColor = .lightGray

        setupUI()
        setupConstrains()
        enableSwipeToPop()
    }
    
    func setupUI() {
        iconImageView.image = UIImage(systemName: "thermometer.sun") // SF Symbol
        iconImageView.tintColor = .systemRed
        iconImageView.contentMode = .scaleAspectFit
        
        
        icon2ImageView.image = UIImage(systemName: "thermometer.snowflake") // SF Symbol
        icon2ImageView.tintColor = .systemBlue
        icon2ImageView.contentMode = .scaleAspectFit
        
        // --- Configura la label del titolo ---
        label.text = "Schermata Conversione Temperature"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 15, weight: .bold)
        
        // --- Configura il campo di testo per inserire la temperatura ---
        tText.placeholder = "Temperatura"  // Testo segnaposto
        tText.textAlignment = .center

        // --- Segment Control per scegliere il tipo di conversione ---
        switchControl.insertSegment(withTitle: "Celsius a Fahrenheit", at: 0, animated: false)
        switchControl.insertSegment(withTitle: "Fahrenheit a Celsius", at: 1, animated: false)
        
        // --- Pulsante per avviare la conversione ---
        calculateButton.setTitle("Converti", for: .normal)
        calculateButton.addTarget(self, action: #selector(convertion), for: .touchUpInside)

        // --- Label che mostrerà il risultato ---
        resultLabel.textAlignment = .center
        
        // Configura la progress bar
        progressView.progress = 0
        progressView.tintColor = .systemBlue

        // --- Pulsante per chiudere la schermata ---
        closeButton.setTitle("Chiudi", for: .normal)
        closeButton.addTarget(self, action: #selector(closeScreen), for: .touchUpInside)
        
        [tText].forEach {
            $0.layer.cornerRadius = 4
            $0.layer.borderWidth = 1
        }
        
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
        
        [iconImageView, icon2ImageView, label, tText, calculateButton, switchControl, resultLabel, closeButton, progressView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview($0)
        }
    }
    
    func setupConstrains() {
        let iconSize: CGFloat = 80
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            iconImageView.widthAnchor.constraint(equalToConstant: iconSize),
            iconImageView.heightAnchor.constraint(equalToConstant: iconSize),
            iconImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            iconImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            iconImageView.bottomAnchor.constraint(equalTo: label.topAnchor, constant: -20),
            
            icon2ImageView.widthAnchor.constraint(equalToConstant: iconSize),
            icon2ImageView.heightAnchor.constraint(equalToConstant: iconSize),
            icon2ImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            icon2ImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -0),
            icon2ImageView.bottomAnchor.constraint(equalTo: label.topAnchor, constant: -20),
            
            tText.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20),
            tText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            switchControl.topAnchor.constraint(equalTo: tText.bottomAnchor, constant: 20),
            switchControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            switchControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            calculateButton.topAnchor.constraint(equalTo: switchControl.bottomAnchor, constant: 20),
            calculateButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            calculateButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            resultLabel.topAnchor.constraint(equalTo: calculateButton.bottomAnchor, constant: 20),
            resultLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            resultLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            progressView.topAnchor.constraint(equalTo: resultLabel.bottomAnchor, constant: 20),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
        ])
    }
    
    // Funzione eseguita quando si preme "Converti"
    @objc func convertion() {
        // Reset iniziale
        resultLabel.text = ""
        progressView.progress = 0

        guard let tempText = tText.text, let tvalue = Double(tempText) else {
            resultLabel.text = "Inserisci un numero valido"
            return
        }

        // Simula avanzamento della progress bar
        Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
            self.progressView.progress += 0.1
            self.progressView.progressTintColor = .systemRed
            if self.progressView.progress >= 1.0 {
                timer.invalidate() // Ferma il timer
                let c = self.switchControl.selectedSegmentIndex
                if c == 0 {
                    self.progressView.progressTintColor = .systemGreen
                    let fahrenheit = (tvalue * (9/5)) + 32
                    self.resultLabel.text = "Gradi fahrenheit: \(String(format: "%.1f", fahrenheit))"
                } else if c == 1 {
                    self.progressView.progressTintColor = .systemGreen
                    let celsius = ((tvalue - 32) * (5/9))
                    self.resultLabel.text = "Gradi celsius: \(String(format: "%.1f", celsius))"
                } else {
                    self.resultLabel.text = "Seleziona una tipologia di conversione"
                }

                // Animazione finale del risultato
                self.resultLabel.alpha = 0
                self.resultLabel.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                UIView.animate(withDuration: 0.5) {
                    self.resultLabel.alpha = 1
                    self.resultLabel.transform = .identity
                }
            }
        }
    }

    // Funzione per chiudere la schermata e tornare indietro
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
