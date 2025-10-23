//
//  GenericMangaDetailViewController.swift
//  Geometria
//
//  Created by Pietro Calamusa on 15/04/25.
//

import UIKit
import CoreData

class MangaDetailViewController: UIViewController, MangaDataReceivable, UITableViewDataSource, UITableViewDelegate {
    var manga: NSManagedObject?
    
    let infoLabel = UILabel()
    
    let introImageView = UIImageView()
    
    let volumeTextField = UITextField()
    
    let tableView = UITableView()
    
    let addButton = UIButton(type: .system)
    let fetchButton = UIButton(type: .system)
    let closeButton = UIButton(type: .system)
    
    var fetchedVolumes: [NSManagedObject] = [] // Array per contenere i volumi recuperati
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray

        setupUI()
        setupConstraints()
        
        fetchManga() // Carica i volumi all'avvio
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "VolumeCell")
        
        enableSwipeToPop()

    }

    func setupUI() {
        guard let manga = manga else { return }

        let nome = manga.value(forKey: "nome") as? String ?? "Sconosciuto"
        let capitolo = manga.value(forKey: "capitolo") as? Int32 ?? 0
        let stagione = manga.value(forKey: "stagione") as? Int32 ?? 0
        let episodio = manga.value(forKey: "episodio") as? Int32 ?? 0

        // Esempio base: una label con tutte le info
        infoLabel.numberOfLines = 0
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.text = """
        Nome: \(nome) 
        Capitolo: \(capitolo) 
        Stagione: \(stagione) 
        Episodio: \(episodio)
        """
        infoLabel.textAlignment = .center

        if let image = UIImage(named: "\(nome).png") {
            introImageView.image = image
            // Imposta il content mode per controllare come l'immagine viene ridimensionata
            introImageView.contentMode = .scaleAspectFit // O altre opzioni come .scaleAspectFill, .center, ecc.
        } else {
            print("Errore: immagine '\(nome).png' non trovata negli assets.")
            // Potresti voler mostrare un'immagine di placeholder o un messaggio di errore qui
        }
        
        volumeTextField.placeholder = "Volume"
        volumeTextField.borderStyle = .roundedRect
        volumeTextField.keyboardType = .numberPad
        volumeTextField.textAlignment = .center
        volumeTextField.layer.cornerRadius = 4
        volumeTextField.layer.borderWidth = 1

        addButton.setTitle("Aggiungi ", for: .normal)
        addButton.addTarget(self, action: #selector(addVolumeButtonTapped), for: .touchUpInside) // Rinominato per chiarezza

        fetchButton.setTitle("Aggiorna Volumi ", for: .normal)
        fetchButton.addTarget(self, action: #selector(fetchButtonPressed), for: .touchUpInside)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.borderWidth = 1
        tableView.layer.cornerRadius = 10
        
        // --- Configurazione CloseButton ---
        closeButton.setTitle("Chiudi ", for: .normal)
        closeButton.addTarget(self, action: #selector(closeButtonPressed), for: .touchUpInside)
        closeButton.tintColor = .red
        // --- Fine Configurazione CloseButton ---
        
        [addButton, fetchButton].forEach {
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
        
        [introImageView, infoLabel, closeButton, volumeTextField, addButton, fetchButton, tableView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview($0)
        }
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            
            introImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            introImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            introImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            introImageView.heightAnchor.constraint(equalToConstant: 150),

            infoLabel.topAnchor.constraint(equalTo: introImageView.bottomAnchor, constant: 20),
            infoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            infoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            volumeTextField.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 20),
            volumeTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100),
            volumeTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100),
            
            addButton.topAnchor.constraint(equalTo: volumeTextField.bottomAnchor, constant: 20),
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            fetchButton.topAnchor.constraint(equalTo: addButton.bottomAnchor, constant: 10),
            fetchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            tableView.topAnchor.constraint(equalTo: fetchButton.bottomAnchor, constant: 10), // Sposta la tableView sotto la volumesLabel
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tableView.bottomAnchor.constraint(equalTo: closeButton.topAnchor, constant: -20), // Assicurati che la tableView abbia un vincolo al bottom
            
            // --- Constraint per CloseButton ---
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            ])
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
    
    // MARK: - Actions
    @objc func addVolumeButtonTapped() { // Rinominato per chiarezza
        guard let text = volumeTextField.text, !text.isEmpty else {
            showAlert(title: "Errore", message: "Il campo volume non può essere vuoto.")
            return
        }

        guard let vol = Int(text) else {
            showAlert(title: "Errore", message: "Inserisci un numero valido per il volume.")
            return
        }

        // Procedi con il salvataggio/aggiornamento
        saveOrUpdateVolume(volume: vol)

        // Pulisci i campi dopo il salvataggio
        volumeTextField.text = ""
    }

    @objc func fetchButtonPressed() {
        fetchManga()
    }
    
    // MARK: - Core Data Operations
    func saveOrUpdateVolume(volume: Int) { // Cambiato Int? a Int, perché hai già validato
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("Errore: Impossibile ottenere AppDelegate")
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext

        // 1. Ottieni il nome del manga corrente con sicurezza
        guard let currentManga = self.manga, // Assicurati che il manga esista
              let currentMangaName = currentManga.value(forKey: "nome") as? String,
              !currentMangaName.isEmpty else {
            print("Errore: Impossibile determinare il nome del manga corrente.")
            showAlert(title: "Errore Interno", message: "Impossibile associare il volume al manga.")
            return
        }

        // 2. Recupera l'entità "Volumi"
        guard let entity = NSEntityDescription.entity(forEntityName: "Volumi", in: managedContext) else {
            print("Errore: Impossibile trovare l'entità Volumi.")
            showAlert(title: "Errore CoreData", message: "Configurazione del modello dati corrotta.")
            return
        }

        // 3. Crea la Fetch Request con il predicato CORRETTO
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Volumi")
        // --- MODIFICA CHIAVE ---
        // Cerca un volume con lo stesso numero E lo stesso nome del manga
        fetchRequest.predicate = NSPredicate(format: "nome == %@ AND numeri == %d", currentMangaName, volume)
        // -----------------------

        do {
            let results = try managedContext.fetch(fetchRequest)
            if results.first != nil {
                // Volume GIÀ ESISTENTE per QUESTO manga specifico
                print("Volume \(volume) per \(currentMangaName) già esistente.")
                showAlert(title: "Info", message: "Il volume \(volume) per \(currentMangaName) esiste già.")
            } else {
                // Crea un NUOVO oggetto Volume perché non esiste per questo manga
                print("Creazione nuovo Volume \(volume) per \(currentMangaName)...")
                let volumeObject = NSManagedObject(entity: entity, insertInto: managedContext)

                // Imposta i valori sul nuovo oggetto
                volumeObject.setValue(currentMangaName, forKey: "nome") // Nome del manga
                volumeObject.setValue(Int32(volume), forKeyPath: "numeri") // Numero volume (assicurati che il tipo corrisponda al modello, es. Int32)

                // Salva il contesto
                try managedContext.save()
                print("Volume \(volume) per \(currentMangaName) salvato.")

                // Aggiorna l'array locale e la tabella (opzionale ma consigliato qui)
                // fetchManga() // Richiama fetch per aggiornare l'UI completa
                // Oppure, aggiungi manualmente all'array e alla tabella per performance
                fetchedVolumes.append(volumeObject)
                // Riordina l'array se vuoi mantenerlo ordinato
                fetchedVolumes.sort { ($0.value(forKey: "numeri") as? Int32 ?? 0) < ($1.value(forKey: "numeri") as? Int32 ?? 0) }
                tableView.reloadData() // Ricarica per mostrare il nuovo volume

            }
        } catch let error as NSError {
            print("Errore CoreData durante il fetch/save del volume: \(error), \(error.userInfo)")
            showAlert(title: "Errore CoreData", message: "Impossibile salvare o verificare il volume: \(error.localizedDescription)")
        }
    }

    func fetchManga() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Volumi")
        
        guard let manga = manga else { return }

        let currentManga = manga.value(forKey: "nome") as? String ?? "Sconosciuto"
        // *IMPORTANTE:* Filtra i volumi in base al manga corrente
        fetchRequest.predicate = NSPredicate(format: "nome == %@", currentManga)
    
        // Aggiungi un Sort Descriptor per ordinare per il campo "numeri" in modo crescente
        let sortDescriptor = NSSortDescriptor(key: "numeri", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]

        do {
            fetchedVolumes = try managedContext.fetch(fetchRequest)

            // Formatta i numeri dei volumi in una stringa
            let volumeNumbers = fetchedVolumes.compactMap { $0.value(forKeyPath: "numeri") as? Int }.sorted()
            _ = volumeNumbers.map { String($0) }.joined(separator: ", ")

            tableView.reloadData() // Continua a ricaricare la tableView se vuoi ancora visualizzare i volumi individualmente
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            showAlert(title: "Errore di Fetch", message: "Impossibile recuperare i volumi.")
        }
    }

    // MARK: - Helper Methods
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedVolumes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VolumeCell", for: indexPath)
        let volume = fetchedVolumes[indexPath.row]
        if let volumeNumber = volume.value(forKeyPath: "numeri") as? Int {
            cell.textLabel?.text = "Volume: \(volumeNumber)"
        }
        return cell
    }
    
    // MARK: - UITableViewDelegate
    // Implementa questo metodo per abilitare l'eliminazione tramite swipe
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            let managedContext = appDelegate.persistentContainer.viewContext
            
            // Ottieni l'oggetto volume da eliminare
            let volumeToDelete = fetchedVolumes[indexPath.row]
            
            // Rimuovi l'oggetto dal managed context
            managedContext.delete(volumeToDelete)
            
            do {
                // Salva le modifiche nel Core Data
                try managedContext.save()
                
                // Rimuovi l'oggetto dall'array locale e aggiorna la tableView
                fetchedVolumes.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                
                // Ricarica i volumi per aggiornare la volumesLabel
                fetchManga()
            } catch let error as NSError {
                print("Could not delete. \(error), \(error.userInfo)")
                showAlert(title: "Errore di Eliminazione", message: "Impossibile eliminare il volume.")
            }
        }
    }
}
