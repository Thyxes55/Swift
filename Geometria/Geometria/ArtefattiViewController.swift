//
//  ArtefattiViewController.swift
//  Geometria
//
//  Created by Pietro Calamusa on 16/04/25.
//

import UIKit
import CoreData

class ArtefattiViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let infoLabel = UILabel()
    let tableView = UITableView()
    //let pieces = ["Pezzo 1", "Pezzo 2", "Pezzo 3"] // Esempio di 3 pezzi (corrispondenti ai tuoi TextField)
    
    let pieceTextField = UITextField()
    let critrateTextField = UITextField()
    let critdamageTextField = UITextField()
    let updateButton = UIButton(type: .system)
    let closeButton = UIButton(type: .system)
    
    var artefactStats: [String: [String: Double]] = [:]
    let initialCritRate = 5.0 // Valore iniziale di Crit Rate
    let initialCritDamage = 50.0 // Valore iniziale di Crit Damage
    
    var totalCritRate: Double = 0
    var totalCritDamage: Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        
        setupUI()
        setupConstraints()
        
        // Inizializza le statistiche dai TextField all'avvio (se hanno valori)
        updateArtefactStatsFromTextFields()
        calculateTotalStats()
        tableView.reloadData() // Aggiorna la tabella con i valori iniziali
        enableSwipeToPop()
    }

// MARK: - Funzione Setup
    func setupUI() {
        
        infoLabel.numberOfLines = 0
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.textAlignment = .center
        infoLabel.font = .systemFont(ofSize: 24, weight: .bold)
        infoLabel.text = "Statistiche Artefatti"
        
        pieceTextField.borderStyle = .roundedRect
        pieceTextField.placeholder = "Nome Pezzo"
        pieceTextField.textAlignment = .center
        pieceTextField.translatesAutoresizingMaskIntoConstraints = false
        
        critrateTextField.borderStyle = .roundedRect
        critrateTextField.placeholder = "Crit Rate"
        critrateTextField.textAlignment = .center
        critrateTextField.keyboardType = .numberPad
        critrateTextField.translatesAutoresizingMaskIntoConstraints = false
        
        critdamageTextField.borderStyle = .roundedRect
        critdamageTextField.placeholder = "Crit Damage"
        critdamageTextField.textAlignment = .center
        critdamageTextField.keyboardType = .numberPad
        critdamageTextField.translatesAutoresizingMaskIntoConstraints = false
        
        [pieceTextField, critrateTextField, critdamageTextField].forEach {
            $0.layer.cornerRadius = 4
            $0.layer.borderWidth = 1
        }
        
        updateButton.setTitle("Aggiorna ", for: .normal)
        updateButton.addTarget(self, action: #selector(updateTableData), for: .touchUpInside)
        updateButton.translatesAutoresizingMaskIntoConstraints = false
        [updateButton].forEach {
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
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ArtefactCell")
        tableView.layer.borderWidth = 1
        tableView.layer.cornerRadius = 10
        //tableView.rowHeight = UITableView.automaticDimension
        
        closeButton.setTitle("Chiudi", for: .normal)
        closeButton.addTarget(self, action: #selector(closeButtonPressed), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        [closeButton].forEach {
            $0.layer.cornerRadius = 10
            $0.titleLabel?.textAlignment = .center
            $0.layer.borderWidth = 1
            $0.tintColor = .black
            $0.backgroundColor = .red
            $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        }
        
        [infoLabel, pieceTextField, critrateTextField, critdamageTextField, updateButton, tableView, closeButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview($0)
        }
    }
    
// MARK: - Funzione Constraints
    func setupConstraints() {
        NSLayoutConstraint.activate([
            infoLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            infoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            infoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            pieceTextField.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 20),
            pieceTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100),
            pieceTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100),
            
            critrateTextField.topAnchor.constraint(equalTo: pieceTextField.bottomAnchor, constant: 20),
            critrateTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100),
            critrateTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100),
            
            critdamageTextField.topAnchor.constraint(equalTo: critrateTextField.bottomAnchor, constant: 20),
            critdamageTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100),
            critdamageTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100),
            
            updateButton.topAnchor.constraint(equalTo: critdamageTextField.bottomAnchor, constant: 20),
            updateButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            tableView.topAnchor.constraint(equalTo: updateButton.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tableView.bottomAnchor.constraint(equalTo: closeButton.topAnchor, constant: -100), // Constraint per posizionare la tabella sopra il bottone chiudi
            
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
        ])
    }
    
// MARK: - Funzioni
    // Funzione per aggiornare il dizionario delle statistiche dai TextField
    func updateArtefactStatsFromTextFields() {
        if let pieceName = pieceTextField.text, !pieceName.isEmpty,
           let critRate = Double(critrateTextField.text ?? ""),
           let critDamage = Double(critdamageTextField.text ?? "") {
            artefactStats[pieceName] = ["CritRate": critRate, "CritDamage": critDamage]
            // Se vuoi gestire più pezzi, dovresti avere più TextField o un modo per identificare a quale pezzo si riferiscono i valori inseriti.
            // Per ora, assumiamo che i TextField rappresentino un singolo pezzo da visualizzare nella tabella.
            pieceTextField.text = ""
            critrateTextField.text = ""
            critdamageTextField.text = ""
        } else {
            // Pulisci le statistiche se i campi non sono validi
            artefactStats = [:]
        }
        calculateTotalStats()
    }
    
    @objc func closeButtonPressed() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { // Ritardo di 0.3 secondi
            UIView.animate(withDuration: 0.3, animations: {
                self.view.alpha = 1 // Anima la scomparsa (fade out)
            }) { _ in
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
// MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2 // Una sezione per i pezzi, una per il totale
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return artefactStats.count // Numero di righe basato sul numero di pezzi con statistiche
        } else {
            return 1 // Una riga per mostrare il totale
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Statistiche Pezzi"
        } else {
            return "Statistiche Totali"
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArtefactCell", for: indexPath)
        
        if indexPath.section == 0 {
            let pieceName = Array(artefactStats.keys)[indexPath.row] // Ottieni il nome del pezzo dall'array delle chiavi
            if let stats = artefactStats[pieceName] {
                cell.textLabel?.text = "\(pieceName) - CR: \(stats["CritRate"] ?? 0)%, CD: \(stats["CritDamage"] ?? 0)%"
            } else {
                cell.textLabel?.text = "\(pieceName) - Nessuna statistica disponibile"
            }
        } else {
            cell.textLabel?.text = "CR Totale: \(totalCritRate)%, CD Totale: \(totalCritDamage)%"
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            cell.textLabel?.textAlignment = .center
        }
        return cell
    }
    
// MARK: - Azione per aggiornare la tabella (ad esempio, collegata a un bottone)
    @objc func updateTableData() {
        updateArtefactStatsFromTextFields()
        tableView.reloadData()
    }
    
// MARK: - Calcola le statistiche totali
    func calculateTotalStats() {
        totalCritRate = initialCritRate
        totalCritDamage = initialCritDamage
        for (_, stats) in artefactStats {
            totalCritRate += stats["CritRate"] ?? 0
            totalCritDamage += stats["CritDamage"] ?? 0
        }
    }
    
// MARK: - UITableViewDelegate
    
    // Puoi implementare metodi del delegate per gestire la selezione delle celle, ecc.
}
