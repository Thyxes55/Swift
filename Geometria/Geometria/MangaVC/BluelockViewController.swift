//
//  BluelockViewController.swift
//  Geometria
//
//  Created by Pietro Calamusa on 15/04/25.
//

import UIKit
import CoreData

class BluelockViewController: UIViewController, MangaDataReceivable, UITableViewDataSource, UITableViewDelegate {
    var manga: NSManagedObject?

    // MARK: - UI Elements
    let introImageView = UIImageView()

    let nome = "Blue Lock"

    let volumeTextField = UITextField()
    let volumesLabel = UILabel()

    let addButton = UIButton(type: .system)
    let fetchButton = UIButton(type: .system)
    let closeButton = UIButton(type: .system)

    let tableView = UITableView()
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
    }

    func setupUI() {

        // Carica l'immagine dagli assets (sostituisci "logobluelock.png" con il nome della tua immagine)
        if let image = UIImage(named: "logobluelock.png") {
            introImageView.image = image
            // Imposta il content mode per controllare come l'immagine viene ridimensionata
            introImageView.contentMode = .scaleAspectFit // O altre opzioni come .scaleAspectFill, .center, ecc.
        } else {
            print("Errore: immagine 'logobluelock.png' non trovata negli assets.")
            // Potresti voler mostrare un'immagine di placeholder o un messaggio di errore qui
        }

        volumeTextField.placeholder = "Volume"
        volumeTextField.borderStyle = .roundedRect
        volumeTextField.keyboardType = .numberPad

        addButton.setTitle("Aggiungi/Aggiorna", for: .normal)
        addButton.addTarget(self, action: #selector(addVolumeButtonTapped), for: .touchUpInside) // Rinominato per chiarezza

        fetchButton.setTitle("Mostra Volumi", for: .normal)
        fetchButton.addTarget(self, action: #selector(fetchButtonPressed), for: .touchUpInside)

        volumesLabel.textAlignment = .center
        volumesLabel.numberOfLines = 0 // Permette più righe se la lista è lunga
        volumesLabel.translatesAutoresizingMaskIntoConstraints = false

        // --- Configurazione CloseButton ---
        closeButton.setTitle("Chiudi", for: .normal)
        closeButton.addTarget(self, action: #selector(closeButtonPressed), for: .touchUpInside)
        closeButton.tintColor = .red
        // --- Fine Configurazione CloseButton ---

        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)

        [introImageView, volumeTextField, addButton, fetchButton, closeButton, volumesLabel, tableView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview($0)
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
    func saveOrUpdateVolume(volume: Int?) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext

        let entity = NSEntityDescription.entity(forEntityName: "Volumi", in: managedContext)!

        // Controlla se esiste già un volume con lo stesso numero
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Volumi")
        fetchRequest.predicate = NSPredicate(format: "numeri == %d", volume!)

        do {
            let results = try managedContext.fetch(fetchRequest)
            if results.first != nil {
                // Aggiorna il volume esistente (in questo caso, il numero è lo stesso, quindi non c'è molto da aggiornare)
                print("Volume \(volume!) già esistente.")
                showAlert(title: "Info", message: "Il volume \(volume!) esiste già.")
            } else {
                // Crea un nuovo oggetto Volume
                let volumeObject = NSManagedObject(entity: entity, insertInto: managedContext)
                volumeObject.setValue(volume, forKeyPath: "numeri")

                do {
                    try managedContext.save()
                    fetchedVolumes.append(volumeObject)
                    tableView.reloadData()
                } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                    showAlert(title: "Errore di Salvataggio", message: "Impossibile salvare il volume.")
                }
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            showAlert(title: "Errore di Fetch", message: "Impossibile verificare l'esistenza del volume.")
        }
    }

    func fetchManga() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Volumi")
    
        // Aggiungi un Sort Descriptor per ordinare per il campo "numeri" in modo crescente
        let sortDescriptor = NSSortDescriptor(key: "numeri", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]

        do {
            fetchedVolumes = try managedContext.fetch(fetchRequest)

            // Formatta i numeri dei volumi in una stringa
            let volumeNumbers = fetchedVolumes.compactMap { $0.value(forKeyPath: "numeri") as? Int }.sorted()
            let volumesString = volumeNumbers.map { String($0) }.joined(separator: ", ")

            // Aggiorna il testo della volumesLabel
            if !volumesString.isEmpty {
                volumesLabel.text = "Volumi: \(volumesString)"
            } else {
                volumesLabel.text = "Nessun volume aggiunto."
            }

            tableView.reloadData() // Continua a ricaricare la tableView se vuoi ancora visualizzare i volumi individualmente
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            showAlert(title: "Errore di Fetch", message: "Impossibile recuperare i volumi.")
        }
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            introImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            introImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            introImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            introImageView.heightAnchor.constraint(equalToConstant: 150),

            volumeTextField.topAnchor.constraint(equalTo: introImageView.bottomAnchor, constant: 20),
            volumeTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            volumeTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            addButton.topAnchor.constraint(equalTo: volumeTextField.bottomAnchor, constant: 20),
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            fetchButton.topAnchor.constraint(equalTo: addButton.bottomAnchor, constant: 10),
            fetchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            // Posiziona la volumesLabel sopra la tableView o dove preferisci
            volumesLabel.topAnchor.constraint(equalTo: fetchButton.bottomAnchor, constant: 20),
            volumesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            volumesLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            tableView.topAnchor.constraint(equalTo: volumesLabel.bottomAnchor, constant: 10), // Sposta la tableView sotto la volumesLabel
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tableView.bottomAnchor.constraint(equalTo: closeButton.topAnchor, constant: -20), // Assicurati che la tableView abbia un vincolo al bottom

            closeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            closeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            closeButton.heightAnchor.constraint(equalToConstant: 44),

        ])
    }

    @objc func closeButtonPressed() {
        dismiss(animated: true, completion: nil)
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
