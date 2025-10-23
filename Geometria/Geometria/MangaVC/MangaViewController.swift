//
//  MangaViewController.swift
//  Geometria
//
//  Created by Pietro Calamusa on 12/04/25.
//

import UIKit
import CoreData

protocol MangaDataReceivable {
    var manga: NSManagedObject? { get set }
}

class MangaViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - UI Elements
    let introLabel = UILabel()
    
    let nameTextField = UITextField()
    let capTextField = UITextField()
    let episodeTextField = UITextField()
    let seasonTextField = UITextField()
    
    let saveButton = UIButton(type: .system)
    let fetchButton = UIButton(type: .system)
    let eraseButton = UIButton(type: .system)
    let closeButton = UIButton(type: .system)
    
    let tableView = UITableView()

    // MARK: - Core Data Properties
    var context: NSManagedObjectContext!
    var collection: [NSManagedObject] = []

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        setupCoreData()
        setupUI()
        setupConstraints()
        fetchManga() // Carica i dati iniziali se presenti
        enableSwipeToPop()
    }

    // MARK: - Setup Methods
    func setupCoreData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Could not get AppDelegate") // Meglio usare fatalError se l'app non può funzionare senza
        }
        context = appDelegate.persistentContainer.viewContext
    }

    func setupUI() {
        introLabel.text = "Gestore Manga/Anime"
        introLabel.font = .systemFont(ofSize: 24, weight: .bold)
        introLabel.textAlignment = .center

        nameTextField.placeholder = "Nome"
        nameTextField.borderStyle = .roundedRect
        nameTextField.autocorrectionType = .no // Disabilita correzione automatica se non desiderata

        capTextField.placeholder = "Capitolo"
        capTextField.borderStyle = .roundedRect
        capTextField.keyboardType = .numberPad

        episodeTextField.placeholder = "Episodio"
        episodeTextField.borderStyle = .roundedRect
        episodeTextField.keyboardType = .numberPad

        seasonTextField.placeholder = "Stagione"
        seasonTextField.borderStyle = .roundedRect
        seasonTextField.keyboardType = .numberPad
        
        [nameTextField, capTextField, episodeTextField, seasonTextField].forEach {
            $0.textAlignment = .center
            $0.layer.cornerRadius = 4
            $0.layer.borderWidth = 1
        }

        saveButton.setTitle("Salva/Aggiorna ", for: .normal)
        saveButton.addTarget(self, action: #selector(saveMangaButtonTapped), for: .touchUpInside) // Rinominato per chiarezza
        
        eraseButton.setTitle("Elimina Manga/Anime ", for: .normal)
        eraseButton.addTarget(self, action: #selector(eraseButtonPressed), for: .touchUpInside)

        fetchButton.setTitle("Mostra/Aggiorna Collezione ", for: .normal)
        fetchButton.addTarget(self, action: #selector(fetchButtonPressed), for: .touchUpInside)

        [saveButton, eraseButton, fetchButton].forEach {
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
        
        // --- Configurazione CloseButton ---
        closeButton.setTitle("Chiudi", for: .normal)
        closeButton.addTarget(self, action: #selector(closeButtonPressed), for: .touchUpInside)
        [closeButton].forEach {
            $0.layer.cornerRadius = 10
            $0.titleLabel?.textAlignment = .center
            $0.layer.borderWidth = 1
            $0.tintColor = .black
            $0.backgroundColor = .red
            $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        }
        // --- Fine Configurazione CloseButton ---

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "mangaCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.layer.borderWidth = 1
        tableView.layer.cornerRadius = 10   // Angoli arrotondati
        
        // Aggiungere tutte le viste alla view principale
        [introLabel, nameTextField, capTextField, episodeTextField, seasonTextField, saveButton, fetchButton, tableView, closeButton, eraseButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview($0)
        }
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            introLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            introLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            introLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            nameTextField.topAnchor.constraint(equalTo: introLabel.bottomAnchor, constant: 20),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            // Layout orizzontale per i campi numerici
            capTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 15),
            capTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),

            seasonTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 15),
            seasonTextField.leadingAnchor.constraint(equalTo: capTextField.trailingAnchor, constant: 10),

            episodeTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 15),
            episodeTextField.leadingAnchor.constraint(equalTo: seasonTextField.trailingAnchor, constant: 10),
            episodeTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            // Assicura che i campi numerici abbiano la stessa larghezza
            capTextField.widthAnchor.constraint(equalTo: seasonTextField.widthAnchor),
            seasonTextField.widthAnchor.constraint(equalTo: episodeTextField.widthAnchor),

            saveButton.topAnchor.constraint(equalTo: episodeTextField.bottomAnchor, constant: 20),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            eraseButton.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 20),
            eraseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            fetchButton.topAnchor.constraint(equalTo: eraseButton.bottomAnchor, constant: 20),
            fetchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            tableView.topAnchor.constraint(equalTo: fetchButton.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80),

            // --- Constraint per CloseButton ---
            closeButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 20), // Posizionato SOTTO la tableview
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40), // Aumentato padding laterale
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40), // Aumentato padding laterale
            closeButton.heightAnchor.constraint(equalToConstant: 44) // Altezza definita
            // In alternativa al topAnchor + heightAnchor, potresti fare:
            // closeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
            // --- Fine Constraint Corretti per CloseButton ---
        ])
    }

    // MARK: - Actions
    @objc func saveMangaButtonTapped() {
        // 1. Controllo Nome (invariato)
        //    Aggiunto trim per rimuovere spazi bianchi iniziali/finali
        guard let name = nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !name.isEmpty else {
            showAlert(title: "Errore", message: "Il nome non può essere vuoto.")
            return
        }

        // 2. Conversione opzionale a Int (invariato)
        //    Int(text) restituisce nil se text è vuoto o non è un numero valido
        let cap = Int(capTextField.text ?? "")
        let episode = Int(episodeTextField.text ?? "")
        let season = Int(seasonTextField.text ?? "")

        // 3. Controlla se i campi contengono testo effettivo (non solo spazi)
        let capText = capTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let episodeText = episodeTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let seasonText = seasonTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        let isCapEntered = !capText.isEmpty
        let isEpisodeEntered = !episodeText.isEmpty
        let isSeasonEntered = !seasonText.isEmpty

        // --- INIZIO LOGICA DI VALIDAZIONE MODIFICATA ---

        // Regola A: Se si inserisce stagione o episodio, devono essere inseriti entrambi (invariato)
        if (isEpisodeEntered && !isSeasonEntered) || (!isEpisodeEntered && isSeasonEntered) {
            showAlert(title: "Input non valido", message: "Se inserisci stagione o episodio, devi inserirli entrambi.")
            return
        }

        // Regola B: Almeno il capitolo OPPURE la coppia stagione/episodio deve essere inserita (invariato)
        // Questa regola permette implicitamente anche il caso in cui siano inseriti tutti.
        if !isCapEntered && !isEpisodeEntered && !isSeasonEntered {
             // Dato che la Regola A è già stata controllata, se arriviamo qui e isEpisodeEntered/isSeasonEntered
             // sono false, significa che la coppia non è stata inserita.
            showAlert(title: "Input mancante", message: "Inserisci almeno il capitolo oppure la coppia stagione/episodio.")
            return
        }

        // Regola C: (RIMOSSA!) Non impediamo più l'inserimento contemporaneo di capitolo e stagione/episodio.
        // if isCapEntered && (isEpisodeEntered || isSeasonEntered) { ... } // Questa riga è stata eliminata

        // --- FINE LOGICA DI VALIDAZIONE MODIFICATA ---

        // Controllo aggiuntivo (Opzionale ma consigliato): Verifica che se l'utente ha scritto qualcosa nei campi numerici,
        // sia effettivamente un numero valido.
        if isCapEntered && cap == nil {
            showAlert(title: "Input non valido", message: "Il valore inserito per 'Capitolo' non è un numero valido.")
            return
        }
        if isEpisodeEntered && episode == nil { // Già sappiamo da Regola A che se isEpisodeEntered è true, lo è anche isSeasonEntered
            showAlert(title: "Input non valido", message: "Il valore inserito per 'Episodio' o 'Stagione' non è un numero valido.")
            return
        }
         if isSeasonEntered && season == nil { // Controllo ridondante se quello sopra c'è già, ma per chiarezza
            showAlert(title: "Input non valido", message: "Il valore inserito per 'Stagione' non è un numero valido.")
            return
         }


        // 4. Procedi con il salvataggio/aggiornamento (invariato)
        //    La funzione saveOrUpdateManga riceve Int? quindi gestisce correttamente i nil
        saveOrUpdateManga(name: name, cap: cap, season: season, episode: episode)

        // 5. Pulisci i campi dopo il salvataggio (invariato)
        nameTextField.text = "" // Potresti voler mantenere il nome
        capTextField.text = ""
        episodeTextField.text = ""
        seasonTextField.text = ""
        // nameTextField.resignFirstResponder() // Nascondi tastiera
        view.endEditing(true) // Modo più generale per nascondere la tastiera
    }
    
    @objc func fetchButtonPressed() {
        fetchManga()
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

    @objc func eraseButtonPressed(_ sender: UIButton) {
        guard let name = nameTextField.text, !name.isEmpty else {
            print("Nome mancante!")
            return
        }
        eraseManga(name: name)
    }
    
    func eraseManga(name: String) {
        // Controlla se la persona esiste già nel contesto
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Manga")
        fetchRequest.predicate = NSPredicate(format: "nome == %@", name)

        do {
            let mangaToDelete = try context.fetch(fetchRequest)
            if mangaToDelete.isEmpty {
                // Se non esiste
                print("Il manga/anime con nome \(name) non esiste.")
            } else {
                for manga in mangaToDelete {
                    context.delete(manga) // Usa context.delete per eliminare l'oggetto
                }
                try context.save() // Salva le modifiche dopo l'eliminazione
                fetchManga() // Aggiorna la tabella
                print("Manga/Anime con nome \(name) eliminate.")
            }
        } catch let error as NSError {
            print("Errore durante l'eliminazione: \(error), \(error.userInfo)")
        }
    }
    
    // MARK: - Core Data Operations
    func saveOrUpdateManga(name: String, cap: Int?, season: Int?, episode: Int?) {
        let fetchRequest: NSFetchRequest<Manga> = Manga.fetchRequest()
        // Usa 'name' come chiave case-insensitive e senza spazi extra per evitare duplicati
        fetchRequest.predicate = NSPredicate(format: "nome ==[cd] %@", name.trimmingCharacters(in: .whitespacesAndNewlines))

        do {
            let results = try context.fetch(fetchRequest)
            let mangaToSave: Manga
            
            if let existingManga = results.first { // Aggiorna esistente
                mangaToSave = existingManga
                print("Aggiornamento manga: \(name)")
            } else { // Crea nuovo
                // Assicurati che l'Entity Description esista
                guard let entity = NSEntityDescription.entity(forEntityName: "Manga", in: context) else {
                    print("Errore: Impossibile trovare l'entità Manga.")
                    return
                }
                mangaToSave = Manga(entity: entity, insertInto: context)
                mangaToSave.nome = name.trimmingCharacters(in: .whitespacesAndNewlines) // Salva nome pulito
                print("Salvataggio nuovo manga: \(name)")
            }
            
            // Aggiorna/Imposta i valori (usa Int64 per CoreData se necessario)
            // Imposta a 0 o un valore di default se nil, o gestisci nil direttamente nel modello
            mangaToSave.capitolo = cap.map { Int32($0) } ?? 0 // Esempio: usa 0 se nil
            mangaToSave.stagione = season.map { Int32($0) } ?? 0 // Esempio: usa 0 se nil
            mangaToSave.episodio = episode.map { Int32($0) } ?? 0 // Esempio: usa 0 se nil
            // Se il tuo modello CoreData permette valori opzionali (non richiesti), puoi assegnare direttamente nil
            
            try context.save()
            print("Manga/Anime salvato/aggiornato con successo!")
            fetchManga() // Aggiorna la tabella
            
        } catch let error as NSError {
            print("Errore CoreData: \(error), \(error.userInfo)")
            showAlert(title: "Errore Salvataggio", message: "Impossibile salvare i dati: \(error.localizedDescription)")
        }
    }

    func fetchManga() {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Manga")

        // Aggiungi un ordinamento (opzionale, ma utile)
        let sortDescriptor = NSSortDescriptor(key: "nome", ascending: true, selector: #selector(NSString.caseInsensitiveCompare))
        fetchRequest.sortDescriptors = [sortDescriptor]

        do {
            collection = try context.fetch(fetchRequest)
            tableView.reloadData() // Ricarica i dati nella tabella
        } catch let error as NSError {
            print("Errore durante il recupero: \(error), \(error.userInfo)")
            showAlert(title: "Errore Caricamento", message: "Impossibile caricare la collezione.")
        }
    }

    // MARK: - UITableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collection.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mangaCell", for: indexPath)
        let manga = collection[indexPath.row]

        // Usa l'accesso tipizzato se hai generato la classe NSManagedObject subclass (Manga)
        // Altrimenti, continua con value(forKey:) ma fai attenzione ai tipi
        guard let name = manga.value(forKey: "nome") as? String else {
             cell.textLabel?.text = "Nome non disponibile"
             return cell
        }

        // Assumi che capitolo, stagione, episodio siano Int64 in CoreData se non opzionali
        let cap = manga.value(forKey: "capitolo") as? Int32
        let season = manga.value(forKey: "stagione") as? Int32
        let episode = manga.value(forKey: "episodio") as? Int32

        var detailText = ""
        // Controlla se i valori sono significativi (diversi da 0 o dal valore di default)
        if let capValue = cap, capValue > 0 {
            detailText += "Cap \(capValue)"
        }
        if let seasonValue = season, let episodeValue = episode, seasonValue > 0 || episodeValue > 0 {
            if !detailText.isEmpty { detailText += ", " } // Aggiungi separatore se c'è già il capitolo
            detailText += "S\(seasonValue) Ep\(episodeValue)"
        }

        if detailText.isEmpty {
            cell.textLabel?.text = name
        } else {
            cell.textLabel?.text = "\(name) - \(detailText)"
        }

        cell.textLabel?.numberOfLines = 0 // Permette al testo di andare a capo
        cell.textLabel?.lineBreakMode = .byWordWrapping

        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedManga = collection[indexPath.row]
        
        guard let nome = selectedManga.value(forKey: "nome") as? String else { return }
        
        if let vc = viewControllerForManga(nome) {
            // Se vuoi, passa anche i dati del manga
            // (devi aggiungere la proprietà "manga" in ogni VC che la usa)
            if var dataReceivable = vc as? MangaDataReceivable {
                dataReceivable.manga = selectedManga
            }
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
        } else {
            print("Nessuna ViewController trovata per \(nome)")
        }
    }


    func viewControllerForManga(_ nome: String) -> UIViewController? {
        
        MangaDetailViewController()
        /*
        switch nome {
        case "Blue lock":
            return BluelockViewController()
        // aggiungi altri casi qui
        default:
            return MangaDetailViewController() // oppure una VC generica
        }
        */
    }
    
    /*
    // MARK: - UITableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) // Deseleziona la cella
        let selectedManga = collection[indexPath.row]
        if let name = selectedManga.value(forKey: "nome") as? String {
            print("Hai selezionato \(name)")
            // Qui potresti, ad esempio, popolare i TextField con i dati del manga selezionato
            // per permettere una modifica rapida.
             nameTextField.text = name
             capTextField.text = (selectedManga.value(forKey: "capitolo") as? Int32 ?? 0 > 0) ? "\(selectedManga.value(forKey: "capitolo") as! Int32)" : ""
             seasonTextField.text = (selectedManga.value(forKey: "stagione") as? Int32 ?? 0 > 0) ? "\(selectedManga.value(forKey: "stagione") as! Int32)" : ""
             episodeTextField.text = (selectedManga.value(forKey: "episodio") as? Int32 ?? 0 > 0) ? "\(selectedManga.value(forKey: "episodio") as! Int32)" : ""
        }
    }
    */
    
    // Permette l'eliminazione tramite swipe sulla cella (opzionale)
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let mangaToDelete = collection[indexPath.row]
            context.delete(mangaToDelete) // Marca per l'eliminazione

            do {
                try context.save() // Salva le modifiche (eliminazione)
                collection.remove(at: indexPath.row) // Rimuovi dall'array locale
                tableView.deleteRows(at: [indexPath], with: .fade) // Rimuovi dalla tabella con animazione
                print("Manga eliminato con successo.")
            } catch let error as NSError {
                print("Errore durante l'eliminazione: \(error), \(error.userInfo)")
                showAlert(title: "Errore Eliminazione", message: "Impossibile eliminare l'elemento.")
                // Potresti voler ricaricare i dati per sicurezza se l'eliminazione fallisce
                // fetchManga()
            }
        }
    }

    // MARK: - Helper Methods
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
