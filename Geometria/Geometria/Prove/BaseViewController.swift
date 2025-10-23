//
//  MagazzinoViewController.swift
//  Geometria
//
//  Created by Pietro Calamusa on 17/04/25.
//

import UIKit
import Foundation
import SQLite



class BaseViewController: UIViewController {
    
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
    }
    
    func setupUI() {
        // Imposta e aggiunge il titolo della schermata
        label.text = "Pass Search"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 24, weight: .bold)
        
        // Configura il campo di testo per l'inserimento di n
        nText.placeholder = "Password"
        nText.textAlignment = .center
        nText.borderStyle = .roundedRect
        nText.keyboardType = .numberPad
        
        // Crea un pulsante per avviare il test di Miller-Rabin
        calculateButton.setTitle("Cerca la password", for: .normal)
        calculateButton.addTarget(self, action: #selector(dataBase), for: .touchUpInside)
        
        // Configura l'etichetta per mostrare il risultato
        resultLabel.textAlignment = .center
        
        // Pulsante per chiudere la schermata
        closeButton.setTitle("Chiudi", for: .normal)
        closeButton.addTarget(self, action: #selector(closeScreen), for: .touchUpInside)
        closeButton.tintColor = .red
        
        [label, nText, calculateButton, resultLabel, closeButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview($0)
        }
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            nText.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20),
            nText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            calculateButton.topAnchor.constraint(equalTo: nText.bottomAnchor, constant: 20),
            calculateButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            calculateButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            resultLabel.topAnchor.constraint(equalTo: calculateButton.bottomAnchor, constant: 20),
            resultLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            resultLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
        ])
    }
    
    @objc func dataBase() {
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileURL = documentDirectory.appendingPathComponent("mydatabase").appendingPathExtension("sqlite3")
            let db = try Connection(fileURL.path)
            
            let users = Table("users")
            let id = Expression<Int64>(value: 1)
            let name = Expression<String>(value: "name")
            let age = Expression<Int?>(value: 30)
            
            print ("Database aperto con successo!")
            do {
                try db.run(users.create(ifNotExists: true) {
                    t in
                    t.column(id, primaryKey: .autoincrement)
                    t.column(name)
                    t.column(age)
                })
            } catch {
                print("Errore durante la creazione della tabella: \(error)")
            }
            resultLabel.text = "\(users[age])"
        } catch {
            print("Errore durante l'apertura del database: \(error)")
        }
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


/*

import UIKit
import Foundation

struct Prodotto: Codable {
    var nome: String
    var categoria: String
    var prezzo: Double
    var quantita: Int
    var codiceIdentificativo: String
}

class baseViewController: UIViewController {
    
    var prodotti: [Prodotto] = []
    var temp = 0
    
    let infoLabel = UILabel()
    
    let nomeTextField = UITextField()
    let categoriaTextField = UITextField()
    let prezzoTextField = UITextField()
    let quantitaTextField = UITextField()
    let codiceIdentificativoTextField = UITextField()
    
    let firstRowStack = UIStackView()
    let secondRowStack = UIStackView()
    let buttonsStack = UIStackView()
    
    let addButton = UIButton(type: .system)
    let searchButton = UIButton(type: .system)
    let deleteButton = UIButton(type: .system)
    let showButton = UIButton(type: .system)
    let groupButton = UIButton(type: .system)
    let saveInventoryButton = UIButton(type: .system)
    let loadInventoryButton = UIButton(type: .system)
    let sortButton = UIButton(type: .system)
    let closeButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        setupUI()
        setupConstraints()
    }
    
    func setupUI() {
        infoLabel.numberOfLines = 0
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.textAlignment = .center
        infoLabel.font = .systemFont(ofSize: 24, weight: .bold)
        infoLabel.text = "Inventario"

        nomeTextField.borderStyle = .roundedRect
        nomeTextField.placeholder = "Nome"
        nomeTextField.translatesAutoresizingMaskIntoConstraints = false

        categoriaTextField.borderStyle = .roundedRect
        categoriaTextField.placeholder = "Categoria"
        categoriaTextField.translatesAutoresizingMaskIntoConstraints = false

        prezzoTextField.borderStyle = .roundedRect
        prezzoTextField.placeholder = "Prezzo"
        prezzoTextField.keyboardType = .numberPad
        prezzoTextField.translatesAutoresizingMaskIntoConstraints = false

        quantitaTextField.borderStyle = .roundedRect
        quantitaTextField.placeholder = "Quantità"
        quantitaTextField.keyboardType = .numberPad
        quantitaTextField.translatesAutoresizingMaskIntoConstraints = false

        codiceIdentificativoTextField.borderStyle = .roundedRect
        codiceIdentificativoTextField.placeholder = "Codice Identificativo"
        codiceIdentificativoTextField.translatesAutoresizingMaskIntoConstraints = false

        addButton.setTitle("Aggiungi", for: .normal)
        addButton.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
        addButton.translatesAutoresizingMaskIntoConstraints = false

        deleteButton.setTitle("Elimina", for: .normal)
        deleteButton.addTarget(self, action: #selector(deleteButtonPressed), for: .touchUpInside)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false

        searchButton.setTitle("Cerca", for: .normal)
        searchButton.addTarget(self, action: #selector(searchButtonPressed), for: .touchUpInside)
        searchButton.translatesAutoresizingMaskIntoConstraints = false

        showButton.setTitle("Mostra", for: .normal)
        showButton.addTarget(self, action: #selector(showButtonPressed), for: .touchUpInside)
        showButton.translatesAutoresizingMaskIntoConstraints = false

        saveInventoryButton.setTitle("Salva Inventario", for: .normal)
        saveInventoryButton.addTarget(self, action: #selector(saveInventoryButtonPressed), for: .touchUpInside)
        saveInventoryButton.translatesAutoresizingMaskIntoConstraints = false

        loadInventoryButton.setTitle("Carica Inventario", for: .normal)
        loadInventoryButton.addTarget(self, action: #selector(loadInventoryButtonPressed), for: .touchUpInside)
        loadInventoryButton.translatesAutoresizingMaskIntoConstraints = false

        groupButton.setTitle("Raggruppa Per Categoria", for: .normal)
        groupButton.addTarget(self, action: #selector(groupButtonPressed), for: .touchUpInside)
        groupButton.translatesAutoresizingMaskIntoConstraints = false

        sortButton.setTitle("Ordina Per Nome", for: .normal)
        sortButton.addTarget(self, action: #selector(sortButtonPressed), for: .touchUpInside)
        sortButton.translatesAutoresizingMaskIntoConstraints = false

        closeButton.setTitle("Chiudi", for: .normal)
        closeButton.addTarget(self, action: #selector(closeButtonPressed), for: .touchUpInside)
        closeButton.tintColor = .red

        let firstRowStack = UIStackView(arrangedSubviews: [addButton, deleteButton, searchButton, showButton])
        firstRowStack.axis = .horizontal
        firstRowStack.distribution = .fillEqually
        firstRowStack.spacing = 10
        firstRowStack.translatesAutoresizingMaskIntoConstraints = false

        let secondRowStack = UIStackView(arrangedSubviews: [saveInventoryButton, loadInventoryButton, groupButton, sortButton])
        secondRowStack.axis = .horizontal
        secondRowStack.distribution = .fillEqually
        secondRowStack.spacing = 10
        secondRowStack.translatesAutoresizingMaskIntoConstraints = false

        let buttonsStack = UIStackView(arrangedSubviews: [firstRowStack, secondRowStack])
        buttonsStack.axis = .vertical
        buttonsStack.spacing = 10
        buttonsStack.translatesAutoresizingMaskIntoConstraints = false
        buttonsStack.translatesAutoresizingMaskIntoConstraints = false // Add this line

        [infoLabel, nomeTextField, categoriaTextField, prezzoTextField, quantitaTextField, codiceIdentificativoTextField, closeButton, buttonsStack].forEach { // Include buttonsStack here
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview($0)
        }
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            infoLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            infoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            infoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            nomeTextField.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 20),
            nomeTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nomeTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            categoriaTextField.topAnchor.constraint(equalTo: nomeTextField.bottomAnchor, constant: 20),
            categoriaTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            categoriaTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            prezzoTextField.topAnchor.constraint(equalTo: categoriaTextField.bottomAnchor, constant: 20),
            prezzoTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            prezzoTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            quantitaTextField.topAnchor.constraint(equalTo: prezzoTextField.bottomAnchor, constant: 20),
            quantitaTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            quantitaTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            codiceIdentificativoTextField.topAnchor.constraint(equalTo: quantitaTextField.bottomAnchor, constant: 20),
            codiceIdentificativoTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            codiceIdentificativoTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            buttonsStack.topAnchor.constraint(equalTo: codiceIdentificativoTextField.bottomAnchor, constant: 30),
            buttonsStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonsStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            closeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            closeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            closeButton.heightAnchor.constraint(equalToConstant: 44),
        ])
    }
    
    func aggiungiProdotto(nome: String, categoria: String, prezzo: Double, quantita: Int, codiceIdentificativo: String) {
        for prodotto in prodotti {
            if prodotto.codiceIdentificativo == codiceIdentificativo {
                print("Prodotto con codice \(codiceIdentificativo) già esistente.")
                return // Esci dalla funzione se il prodotto esiste già
            }
        }
        prodotti.append(Prodotto(nome: nome, categoria: categoria, prezzo: prezzo, quantita: quantita, codiceIdentificativo: codiceIdentificativo))
        print("Prodotto con codice \(codiceIdentificativo) aggiunto con successo.")
    }
    
    func rimuoviProdotto(codiceIdentificativo: String) {
        for (index, prodotto) in prodotti.enumerated() {
            if (prodotti[index].codiceIdentificativo == codiceIdentificativo) {
                prodotti.remove(at: index)
                print("Prodotto con codice \(codiceIdentificativo) rimosso con successo")
                break
            }
        }
        print("Prodotto non trovato")
    }
    
    func visualizzaInventario() {
        for prodotto in prodotti {
            print("Codice: \(prodotto.codiceIdentificativo), Nome: \(prodotto.nome), Categoria: \(prodotto.categoria), Prezzo: \(prodotto.prezzo), Quantità: \(prodotto.quantita)")
        }
    }
    
    func cercaProdotti(nome: String){
        for prodotto in prodotti {
            if prodotto.nome.range(of: nome, options: .caseInsensitive) != nil {
                print("Codice: \(prodotto.codiceIdentificativo), Nome: \(prodotto.nome), Categoria: \(prodotto.categoria), Prezzo: \(prodotto.prezzo), Quantità: \(prodotto.quantita)")
            }
        }
        // Potrebbe essere utile stampare "Prodotto non trovato" solo se non sono stati trovati risultati
        if !prodotti.contains(where: { $0.nome.range(of: nome, options: .caseInsensitive) != nil }) {
            print("Prodotto non trovato.")
        }
    }
    
    func raggruppaPerCategoria() -> [String: [Prodotto]] {
        var inventarioRaggruppato: [String: [Prodotto]] = [:]
        for prodotto in prodotti {
            if inventarioRaggruppato[prodotto.categoria] == nil {
                inventarioRaggruppato[prodotto.categoria] = [prodotto]
            } else {
                inventarioRaggruppato[prodotto.categoria]?.append(prodotto)
            }
        }
        return inventarioRaggruppato
    }
    
    func ordinaPerPrezzo(Ordine: Bool) -> [Prodotto] {
        
        if Ordine == true {
            // ordinamento decrescente
            return prodotti.sorted { $0.prezzo > $1.prezzo }
        }else {
            // ordinamento crescente
            return prodotti.sorted { $0.prezzo < $1.prezzo }
        }
    }
    
    func salvaInventario(nomeFile: String) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent(nomeFile).appendingPathExtension("json")
        
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(prodotti) // 'prodotti' è l'array di Prodotto nell'Inventario
            
            try data.write(to: fileURL)
            print("Inventario salvato con successo in: \(fileURL)")
            
        } catch {
            print("Errore durante il salvataggio dell'inventario: \(error)")
        }
    }
    
    func caricaInventario(nomeFile: String) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent(nomeFile).appendingPathExtension("json")
        
        do {
            let data = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            prodotti = try decoder.decode([Prodotto].self, from: data)
            print("Inventario caricato con successo da: \(fileURL)")
            
        } catch {
            print("Errore durante il caricamento dell'inventario: \(error)")
            prodotti = [] // In caso di errore, inizializza l'inventario come vuoto (o gestisci l'errore come preferisci)
        }
    }
    
    
    @objc func addButtonPressed() {
        guard let nome = nomeTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !nome.isEmpty,
              let categoria = categoriaTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !categoria.isEmpty,
              let prezzo = Double(prezzoTextField.text ?? "0"),
              let quantita = Int(quantitaTextField.text ?? "0"),
              let codiceIdentificativo = codiceIdentificativoTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !codiceIdentificativo.isEmpty else {
            showAlert(title: "Errore", message: "I campi non possono essere vuoti.")
            return
        }
        aggiungiProdotto(nome: nome, categoria: categoria, prezzo: prezzo, quantita: quantita, codiceIdentificativo: codiceIdentificativo)
    }
    
    @objc func deleteButtonPressed() {
        guard let codice = codiceIdentificativoTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !codice.isEmpty else {
            showAlert(title: "Errore", message: "Il codice non può essere vuoto.")
            return
        }
        rimuoviProdotto(codiceIdentificativo: codice)
    }
    
    @objc func showButtonPressed() {
        visualizzaInventario()
    }
    
    @objc func searchButtonPressed() {
        guard let nome = nomeTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !nome.isEmpty else {
            showAlert(title: "Errore", message: "Il nome non può essere vuoto.")
            return
        }
        cercaProdotti(nome: nome)
    }
    
    @objc func groupButtonPressed() {
        raggruppaPerCategoria()
    }
    
    @objc func sortButtonPressed() {
        ordinaPerPrezzo(Ordine: true)
    }
    
    @objc func saveInventoryButtonPressed(){
        salvaInventario(nomeFile: "inventario")
    }
    
    @objc func loadInventoryButtonPressed(){
        caricaInventario(nomeFile: "inventario")
    }
    
    // Funzione per chiudere la schermata
    @objc func closeButtonPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Helper Methods
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

 */
