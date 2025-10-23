//
//  MagazzinoViewController.swift
//  Geometria
//
//  Created by Pietro Calamusa on 17/04/25.
//

/*
 */

import UIKit
import Foundation

struct Prodotto: Codable {
    var nome: String
    var categoria: String
    var prezzo: Double
    var quantita: Int
    var codiceIdentificativo: String
}

class MagazzinoViewController: UIViewController {
    
    var prodotti: [Prodotto] = []
    var temp = 0 // Considera se questa variabile 'temp' è ancora necessaria
    
    let infoLabel = UILabel()
    let inventarioLabel = UILabel()
    let inventoryviewLabel = UILabel()
    
    let nomeTextField = UITextField()
    let categoriaTextField = UITextField()
    let prezzoTextField = UITextField()
    let quantitaTextField = UITextField()
    let codiceIdentificativoTextField = UITextField()
    
    let addButton = UIButton(type: .system)
    let searchButton = UIButton(type: .system)
    let deleteButton = UIButton(type: .system)
    let showButton = UIButton(type: .system)
    let groupButton = UIButton(type: .system)
    let saveInventoryButton = UIButton(type: .system)
    let loadInventoryButton = UIButton(type: .system)
    let sortButton = UIButton(type: .system)
    let closeButton = UIButton(type: .system)
    
    // Stack Views per i bottoni
    let buttonStackView1 = UIStackView()
    let buttonStackView2 = UIStackView()
    
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
        infoLabel.text = "Schermata Inventario"
        
        nomeTextField.borderStyle = .roundedRect
        nomeTextField.placeholder = "Nome"
        nomeTextField.translatesAutoresizingMaskIntoConstraints = false
        
        categoriaTextField.borderStyle = .roundedRect
        categoriaTextField.placeholder = "Categoria"
        categoriaTextField.translatesAutoresizingMaskIntoConstraints = false
        
        prezzoTextField.borderStyle = .roundedRect
        prezzoTextField.placeholder = "Prezzo"
        prezzoTextField.keyboardType = .decimalPad // Usa .decimalPad per i prezzi
        prezzoTextField.translatesAutoresizingMaskIntoConstraints = false
        
        quantitaTextField.borderStyle = .roundedRect
        quantitaTextField.placeholder = "Quantità"
        quantitaTextField.keyboardType = .numberPad
        quantitaTextField.translatesAutoresizingMaskIntoConstraints = false
        
        codiceIdentificativoTextField.borderStyle = .roundedRect
        codiceIdentificativoTextField.placeholder = "Codice Identificativo"
        codiceIdentificativoTextField.translatesAutoresizingMaskIntoConstraints = false
        
        [nomeTextField, categoriaTextField, prezzoTextField, quantitaTextField, codiceIdentificativoTextField].forEach {
            $0.textAlignment = .center
        }
        
        addButton.setTitle("Add", for: .normal)
        addButton.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
        addButton.translatesAutoresizingMaskIntoConstraints = false // Necessario per stackview
        
        deleteButton.setTitle("Delete", for: .normal)
        deleteButton.addTarget(self, action: #selector(deleteButtonPressed), for: .touchUpInside)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false // Necessario per stackview
        
        searchButton.setTitle("Search", for: .normal)
        searchButton.addTarget(self, action: #selector(searchButtonPressed), for: .touchUpInside)
        searchButton.translatesAutoresizingMaskIntoConstraints = false // Necessario per stackview
        
        showButton.setTitle("Show", for: .normal)
        showButton.addTarget(self, action: #selector(showButtonPressed), for: .touchUpInside)
        showButton.translatesAutoresizingMaskIntoConstraints = false // Necessario per stackview
        
        saveInventoryButton.setTitle("Save", for: .normal) // Titolo abbreviato
        saveInventoryButton.addTarget(self, action: #selector(saveInventoryButtonPressed), for: .touchUpInside)
        saveInventoryButton.translatesAutoresizingMaskIntoConstraints = false // Necessario per stackview
        
        loadInventoryButton.setTitle("Upload", for: .normal) // Titolo abbreviato
        loadInventoryButton.addTarget(self, action: #selector(loadInventoryButtonPressed), for: .touchUpInside)
        loadInventoryButton.translatesAutoresizingMaskIntoConstraints = false // Necessario per stackview
        
        groupButton.setTitle("GroupBy", for: .normal) // Titolo abbreviato
        groupButton.addTarget(self, action: #selector(groupButtonPressed), for: .touchUpInside)
        groupButton.translatesAutoresizingMaskIntoConstraints = false // Necessario per stackview
        
        sortButton.setTitle("Order", for: .normal) // Titolo abbreviato
        sortButton.addTarget(self, action: #selector(sortButtonPressed), for: .touchUpInside)
        sortButton.translatesAutoresizingMaskIntoConstraints = false // Necessario per stackview
        
        // Configura StackView 1
        buttonStackView1.axis = .horizontal
        buttonStackView1.distribution = .fillEqually // O .equalSpacing
        buttonStackView1.spacing = 10 // Spazio tra i bottoni
        buttonStackView1.translatesAutoresizingMaskIntoConstraints = false
        [addButton, deleteButton, searchButton, showButton].forEach { buttonStackView1.addArrangedSubview($0) }
        
        // Configura StackView 2
        buttonStackView2.axis = .horizontal
        buttonStackView2.distribution = .fillEqually // O .equalSpacing
        buttonStackView2.spacing = 10 // Spazio tra i bottoni
        buttonStackView2.translatesAutoresizingMaskIntoConstraints = false
        [groupButton, sortButton, saveInventoryButton, loadInventoryButton].forEach { buttonStackView2.addArrangedSubview($0) }
        
        inventarioLabel.numberOfLines = 0
        inventarioLabel.translatesAutoresizingMaskIntoConstraints = false
        inventarioLabel.textAlignment = .center
        inventarioLabel.font = .systemFont(ofSize: 24, weight: .bold)
        inventarioLabel.text = "Inventario"
        
        inventoryviewLabel.numberOfLines = 0
        inventoryviewLabel.translatesAutoresizingMaskIntoConstraints = false
        inventoryviewLabel.textAlignment = .center
        inventoryviewLabel.text = ""
        
        [groupButton, sortButton, saveInventoryButton, loadInventoryButton, addButton, deleteButton, searchButton, showButton].forEach {
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
        
        
        // Aggiungi tutti gli elementi alla view
        [infoLabel, nomeTextField, categoriaTextField, prezzoTextField, quantitaTextField, codiceIdentificativoTextField, buttonStackView1, buttonStackView2, inventarioLabel, inventoryviewLabel, closeButton].forEach {
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
            
            // Codice Identificativo TextField
            codiceIdentificativoTextField.topAnchor.constraint(equalTo: quantitaTextField.bottomAnchor, constant: 20),
            codiceIdentificativoTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            codiceIdentificativoTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // --- Nuovi Constraints per i Bottoni ---
            // StackView 1 (prima riga di bottoni)
            buttonStackView1.topAnchor.constraint(equalTo: codiceIdentificativoTextField.bottomAnchor, constant: 30), // Spazio sopra la prima riga
            buttonStackView1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonStackView1.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // StackView 2 (seconda riga di bottoni)
            buttonStackView2.topAnchor.constraint(equalTo: buttonStackView1.bottomAnchor, constant: 15), // Spazio tra le due righe
            buttonStackView2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonStackView2.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            inventarioLabel.topAnchor.constraint(equalTo: buttonStackView2.bottomAnchor, constant: 20),
            inventarioLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            inventarioLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            inventoryviewLabel.topAnchor.constraint(equalTo: inventarioLabel.bottomAnchor, constant: 5),
            inventoryviewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            inventoryviewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // Close button (agganciato sotto la seconda riga di bottoni)
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
        ])
    }
    
    func aggiungiProdotto(nome: String, categoria: String, prezzo: Double, quantita: Int, codiceIdentificativo: String) {
        // Controllo esistenza migliorato
        if prodotti.contains(where: { $0.codiceIdentificativo.caseInsensitiveCompare(codiceIdentificativo) == .orderedSame }) {
            print("Prodotto con codice \(codiceIdentificativo) già esistente.")
            showAlert(title: "Attenzione", message: "Prodotto con codice \(codiceIdentificativo) già presente.")
            return // Esci dalla funzione se il prodotto esiste già
        }
        prodotti.append(Prodotto(nome: nome, categoria: categoria, prezzo: prezzo, quantita: quantita, codiceIdentificativo: codiceIdentificativo))
        print("Prodotto con codice \(codiceIdentificativo) aggiunto con successo.")
        // Optional: Pulisci i campi dopo l'aggiunta
        clearTextFields()
        showAlert(title: "Successo", message: "Prodotto aggiunto.")
    }
    
    func rimuoviProdotto(codiceIdentificativo: String) {
        let initialCount = prodotti.count
        // Rimuovi tutti i prodotti che matchano il codice (anche se dovrebbe essere unico)
        prodotti.removeAll { $0.codiceIdentificativo.caseInsensitiveCompare(codiceIdentificativo) == .orderedSame }
        
        if prodotti.count < initialCount {
            print("Prodotto con codice \(codiceIdentificativo) rimosso con successo")
            showAlert(title: "Successo", message: "Prodotto con codice \(codiceIdentificativo) rimosso.")
            clearTextFields()
        } else {
            print("Prodotto non trovato")
            showAlert(title: "Errore", message: "Prodotto con codice \(codiceIdentificativo) non trovato.")
        }
    }
    
    func visualizzaInventario() {
        if prodotti.isEmpty {
            print("Inventario vuoto.")
            showAlert(title: "Attenzione", message: "Inventario vuoto.")
            return
        }
        
        var inventoryString = "\n"
        for prodotto in prodotti {
            let productInfo = "Cod: \(prodotto.codiceIdentificativo), Nome: \(prodotto.nome), Cat: \(prodotto.categoria), Prezzo: \(prodotto.prezzo), Qta: \(prodotto.quantita)\n"
            print(productInfo)
            inventoryString += productInfo
        }
        // Mostra l'inventario in un Alert o aggiorna una TextView/Label
        // Per ora, aggiorniamo infoLabel (potrebbe diventare lungo)
        inventoryviewLabel.text = inventoryString // Attenzione: potrebbe non essere l'ideale per molti prodotti
        showAlert(title: "Inventario Attuale", message: inventoryString) // Mostra in un alert
    }
    
    func cercaProdotti(nome: String) {
        let risultati = prodotti.filter { $0.nome.range(of: nome, options: .caseInsensitive) != nil }
        
        if risultati.isEmpty {
            print("Nessun prodotto trovato con nome contenente '\(nome)'.")
            showAlert(title: "Ricerca", message: "Nessun prodotto trovato con nome contenente '\(nome)'.")
        } else {
            var resultString = "Risultati Ricerca per '\(nome)':\n"
            for prodotto in risultati {
                let productInfo = "Cod: \(prodotto.codiceIdentificativo), Nome: \(prodotto.nome), Cat: \(prodotto.categoria), Prezzo: \(prodotto.prezzo), Qta: \(prodotto.quantita)\n"
                print(productInfo)
                resultString += productInfo
            }
            showAlert(title: "Risultati Ricerca", message: resultString)
        }
    }
    
    func raggruppaPerCategoria() { // Modificato per mostrare i risultati
        if prodotti.isEmpty {
            showAlert(title: "Raggruppamento", message: "Inventario vuoto.")
            return
        }
        
        let inventarioRaggruppato = Dictionary(grouping: prodotti, by: { $0.categoria })
        
        var groupedString = "Prodotti Raggruppati per Categoria:\n\n"
        for (categoria, prodottiCategoria) in inventarioRaggruppato.sorted(by: { $0.key < $1.key }) { // Ordina per nome categoria
            groupedString += "--- \(categoria) ---\n"
            for prodotto in prodottiCategoria {
                groupedString += "  Cod: \(prodotto.codiceIdentificativo), Nome: \(prodotto.nome), Prezzo: \(prodotto.prezzo), Qta: \(prodotto.quantita)\n"
            }
            groupedString += "\n"
        }
        print(groupedString)
        showAlert(title: "Inventario Raggruppato", message: groupedString)
        // La funzione originale ritornava il dizionario, ma non veniva usato.
        // Ora stampa e mostra un alert. Se devi usare il dizionario, ripristina il return type.
    }
    
    
    func ordinaPerNome() { // Aggiunta funzione per ordinare per nome
        prodotti.sort { $0.nome.localizedCaseInsensitiveCompare($1.nome) == .orderedAscending }
        print("Inventario ordinato per nome.")
        showAlert(title: "Ordinamento", message: "Inventario ordinato per nome.")
        visualizzaInventario() // Mostra l'inventario ordinato
    }
    
    func ordinaPerPrezzo(crescente: Bool) { // Modificato per chiarezza e feedback
        if crescente {
            prodotti.sort { $0.prezzo < $1.prezzo }
            print("Inventario ordinato per prezzo crescente.")
            showAlert(title: "Ordinamento", message: "Inventario ordinato per prezzo crescente.")
        } else {
            prodotti.sort { $0.prezzo > $1.prezzo }
            print("Inventario ordinato per prezzo decrescente.")
            showAlert(title: "Ordinamento", message: "Inventario ordinato per prezzo decrescente.")
        }
        visualizzaInventario() // Mostra l'inventario ordinato
    }
    
    
    func salvaInventario(nomeFile: String) {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Errore: Impossibile accedere alla directory Documents.")
            showAlert(title: "Errore Salvataggio", message: "Impossibile accedere alla directory Documents.")
            return
        }
        let fileURL = documentsDirectory.appendingPathComponent(nomeFile).appendingPathExtension("json")
        
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted // Rende il JSON più leggibile
            let data = try encoder.encode(prodotti)
            
            try data.write(to: fileURL, options: [.atomicWrite]) // atomicWrite è più sicuro
            print("Inventario salvato con successo in: \(fileURL.path)") // Mostra il percorso
            showAlert(title: "Salvataggio", message: "Inventario salvato con successo.")
            
        } catch {
            print("Errore durante il salvataggio dell'inventario: \(error)")
            showAlert(title: "Errore Salvataggio", message: "Errore: \(error.localizedDescription)")
        }
    }
    
    func caricaInventario(nomeFile: String) {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Errore: Impossibile accedere alla directory Documents.")
            showAlert(title: "Errore Caricamento", message: "Impossibile accedere alla directory Documents.")
            return
        }
        let fileURL = documentsDirectory.appendingPathComponent(nomeFile).appendingPathExtension("json")
        
        // Controlla se il file esiste prima di tentare di caricarlo
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            print("Errore: File inventario non trovato in \(fileURL.path)")
            showAlert(title: "Errore Caricamento", message: "File inventario '\(nomeFile).json' non trovato.")
            // Non svuotare l'inventario se il file non esiste, potresti voler mantenere i dati attuali
            // prodotti = [] // Rimuovi questa linea se vuoi mantenere i dati correnti in caso di file non trovato
            return
        }
        
        do {
            let data = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            let prodottiCaricati = try decoder.decode([Prodotto].self, from: data)
            prodotti = prodottiCaricati // Sovrascrivi l'array corrente
            print("Inventario caricato con successo da: \(fileURL.path)")
            showAlert(title: "Caricamento", message: "Inventario caricato con successo.")
            visualizzaInventario() // Mostra l'inventario caricato
            
        } catch {
            print("Errore durante il caricamento dell'inventario: \(error)")
            showAlert(title: "Errore Caricamento", message: "Errore: \(error.localizedDescription)")
            // prodotti = [] // Decidi se svuotare l'inventario in caso di errore di decodifica
        }
    }
    
    // --- Azioni dei Bottoni ---
    @objc func addButtonPressed() {
        // Validazione input migliorata
        guard let nome = nomeTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !nome.isEmpty else {
            showAlert(title: "Errore", message: "Il campo 'Nome' non può essere vuoto.")
            return
        }
        guard let categoria = categoriaTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !categoria.isEmpty else {
            showAlert(title: "Errore", message: "Il campo 'Categoria' non può essere vuoto.")
            return
        }
        guard let prezzoText = prezzoTextField.text, let prezzo = Double(prezzoText), prezzo >= 0 else {
            showAlert(title: "Errore", message: "Inserire un 'Prezzo' valido (numero maggiore o uguale a 0).")
            return
        }
        guard let quantitaText = quantitaTextField.text, let quantita = Int(quantitaText), quantita >= 0 else {
            showAlert(title: "Errore", message: "Inserire una 'Quantità' valida (numero intero maggiore o uguale a 0).")
            return
        }
        guard let codiceIdentificativo = codiceIdentificativoTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !codiceIdentificativo.isEmpty else {
            showAlert(title: "Errore", message: "Il campo 'Codice Identificativo' non può essere vuoto.")
            return
        }
        
        aggiungiProdotto(nome: nome, categoria: categoria, prezzo: prezzo, quantita: quantita, codiceIdentificativo: codiceIdentificativo)
    }
    
    @objc func deleteButtonPressed() {
        guard let codice = codiceIdentificativoTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !codice.isEmpty else {
            // Prova a usare il nome se il codice è vuoto
            guard let nome = nomeTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !nome.isEmpty else {
                showAlert(title: "Errore", message: "Inserire il 'Codice Identificativo' o il 'Nome' del prodotto da eliminare.")
                return
            }
            // Qui potresti implementare una logica per cercare per nome e chiedere conferma se ci sono più match
            showAlert(title: "Attenzione", message: "Funzione elimina per nome non implementata. Inserire il Codice Identificativo.")
            return // Per ora chiediamo il codice
        }
        rimuoviProdotto(codiceIdentificativo: codice)
    }
    
    @objc func showButtonPressed() {
        visualizzaInventario()
    }
    
    @objc func searchButtonPressed() {
        guard let nome = nomeTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !nome.isEmpty else {
            showAlert(title: "Errore", message: "Il campo 'Nome' non può essere vuoto per la ricerca.")
            return
        }
        cercaProdotti(nome: nome)
    }
    
    @objc func groupButtonPressed() {
        raggruppaPerCategoria() // La funzione ora mostra i risultati
    }
    
    @objc func sortButtonPressed() {
        // Potresti aggiungere un modo per scegliere l'ordinamento (es. un Alert con opzioni)
        // Per ora, ordina per nome come esempio alternativo o usa ordinaPerPrezzo
        // ordinaPerNome()
        ordinaPerPrezzo(crescente: true) // Ordina per prezzo crescente di default
    }
    
    @objc func saveInventoryButtonPressed(){
        salvaInventario(nomeFile: "inventario") // Usa un nome file fisso per semplicità
    }
    
    @objc func loadInventoryButtonPressed(){
        caricaInventario(nomeFile: "inventario")
    }
    
    // Funzione per chiudere la schermata
    @objc func closeButtonPressed() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { // Ritardo di 0.3 secondi
            UIView.animate(withDuration: 0.3, animations: {
                self.view.alpha = 1 // Anima la scomparsa (fade out)
            }) { _ in
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - Helper Methods
    func showAlert(title: String, message: String) {
        // Assicurati che venga eseguito sul thread principale
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func clearTextFields() {
        nomeTextField.text = ""
        categoriaTextField.text = ""
        prezzoTextField.text = ""
        quantitaTextField.text = ""
        codiceIdentificativoTextField.text = ""
    }
}
