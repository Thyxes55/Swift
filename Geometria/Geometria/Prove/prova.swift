//
//  IconCollectionViewCell.swift
//  Geometria
//
//  Created by Pietro Calamusa on 16/04/25.
//

/*
 Punti Chiave da Implementare:
 
 Modello Dati: Definisci una struct o una classe per rappresentare un'attività con tutte le proprietà necessarie (nome, descrizione, data, categoria, stato, tempi).
 Persistenza Dati: Scegli un metodo per salvare i dati (inizia pure con UserDefaults se vuoi semplificare all'inizio, ma considera Core Data o Realm per una soluzione più robusta). Implementa le funzioni per salvare e recuperare le attività.
 Gestione Categorie: Popola l'activityCategoryPicker con delle categorie. Potresti avere un array statico all'inizio o permettere all'utente di aggiungere nuove categorie.
 Logica delle Funzioni: Implementa il codice all'interno di @objc func addActivity(), @objc func modifyActivity(), @objc func deleteActivity(), e @objc func visualizerActivity() per interagire con il modello dati e il sistema di persistenza.
 Analisi Predittiva: Nella funzione analizarPredict(), dovrai scrivere la logica per analizzare i dati delle attività completate e generare le stime, i suggerimenti di priorità e identificare i pattern.
 Visualizzazione: Nella funzione visualizerActivity(), dovrai creare un modo per mostrare le attività all'utente (probabilmente navigando a un'altra UIViewController che contiene una UITableView o una UICollectionView).
 
 */

import UIKit
import CoreData

class prova: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let intro = UILabel()
    let completation = UILabel()
    
    //Implementazione di un modello dati (strutture o classi) per rappresentare le attività (titolo, descrizione, data di scadenza, categoria, stato di completamento, tempo stimato, tempo effettivo).
    let activityName = UITextField()
    let activityDescription = UITextField()
    let activityEstimatedTimeTextField = UITextField()
    let activityElapsedTimeTextField = UITextField()
    
    let activityDatePicker = UIDatePicker()
    let activityCategoryPicker = UIPickerView() // Dovrai configurare il suo delegate e dataSource
    
    let activityCompletionSwitch = UISegmentedControl(items: ["Not Done", "Done"])
    
    let addButton = UIButton()
    let modifyButton = UIButton()
    let visualizerButton = UIButton()
    let deselectButton = UIButton()
    let analyzeButton = UIButton()
    let organizeButton = UIButton()
    let deleteButton = UIButton()
    
    let categories = ["Lavoro", "Personale", "Studio", "Hobby", "Altro"]
    
    var selectedCategory: String?
    var selectedActivityEntity: ActivityEntity?
    var context: NSManagedObjectContext!
    var activities: [NSManagedObject] = [] // Array per contenere le attività recuperate
    
    let tableView = UITableView()
    
    let buttonStackView1 = UIStackView()
    let buttonStackView2 = UIStackView()
    let buttonStackView3 = UIStackView()
    let buttonStackView4 = UIStackView()
    
    var activityNameText: String?
    var activityDescriptionText: String?
    var activityDueDate: Date?
    var activityCategoryText: String?
    var isActivityCompleted: Bool = false
    var estimatedTime: Int?
    var elapsedTime: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Imposta il colore di sfondo della vista
        view.backgroundColor = .lightGray
        setupUI()
        setupConstraints()
        
        loadActivities()
        tableView.reloadData()
        enableSwipeToPop()
        tableView.delegate = self
    }
    
    func setupUI() {
        
        // Setting per Labels
        intro.text = "Schermata Attività"
        intro.numberOfLines = 0
        intro.translatesAutoresizingMaskIntoConstraints = false
        intro.textAlignment = .center
        intro.font = .systemFont(ofSize: 24, weight: .bold)
        
        activityName.placeholder = "Nome dell'attività"
        activityDescription.placeholder = "Descrizione dell'attività"
        
        activityEstimatedTimeTextField.placeholder = "Tempo stimato (min)"
        activityElapsedTimeTextField.placeholder = "Tempo effettivo (min)"
        
        [activityName, activityDescription, activityEstimatedTimeTextField, activityElapsedTimeTextField].forEach {
            $0.keyboardType = .numberPad
            $0.textAlignment = .center
            $0.layer.cornerRadius = 4
            $0.layer.borderWidth = 1
        }
        
        addButton.setTitle("Add", for: .normal)
        addButton.addTarget(self, action: #selector(addActivity), for: .touchUpInside)
        
        modifyButton.setTitle("Modify", for: .normal)
        modifyButton.addTarget(self, action: #selector(modifyActivity), for: .touchUpInside)
        
        visualizerButton.setTitle("Visualizer", for: .normal)
        visualizerButton.addTarget(self, action: #selector(updateTableData), for: .touchUpInside)
        
        deleteButton.setTitle("Delete", for: .normal)
        deleteButton.addTarget(self, action: #selector(deleteActivity), for: .touchUpInside)
        
        deselectButton.setTitle("Deselect", for: .normal)
        deselectButton.addTarget(self, action: #selector(deselectTableData), for: .touchUpInside)
        
        analyzeButton.setTitle("Analyze", for: .normal)
        analyzeButton.addTarget(self, action: #selector(analizarPredict), for: .touchUpInside)
        
        organizeButton.setTitle("Categorize", for: .normal)
        organizeButton.addTarget(self, action: #selector(categorizeActivity), for: .touchUpInside)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ActivityCell")
        tableView.layer.borderWidth = 1
        tableView.layer.cornerRadius = 10
        
        // Configura il delegate e il dataSource per activityCategoryPicker
        activityCategoryPicker.delegate = self
        activityCategoryPicker.dataSource = self
        
        // Configura StackView 1
        buttonStackView1.axis = .horizontal
        buttonStackView1.distribution = .fillEqually // O .equalSpacing
        buttonStackView1.spacing = 10 // Spazio tra i bottoni
        buttonStackView1.translatesAutoresizingMaskIntoConstraints = false
        [addButton, modifyButton, visualizerButton, deleteButton].forEach {
            buttonStackView1.addArrangedSubview($0)
        }
        
        buttonStackView2.axis = .horizontal
        buttonStackView2.distribution = .fillEqually // O .equalSpacing
        buttonStackView2.spacing = 10 // Spazio tra i campi
        buttonStackView2.translatesAutoresizingMaskIntoConstraints = false
        [activityEstimatedTimeTextField, activityElapsedTimeTextField].forEach {
            buttonStackView2.addArrangedSubview($0)
        }
        
        activityCompletionSwitch.translatesAutoresizingMaskIntoConstraints = false
        activityCompletionSwitch.selectedSegmentIndex = 0 // Imposta "Non Completato" come predefinito
        
        buttonStackView3.axis = .horizontal
        buttonStackView3.distribution = .fillEqually
        buttonStackView3.spacing = 10
        buttonStackView3.translatesAutoresizingMaskIntoConstraints = false
        [activityCompletionSwitch, activityDatePicker].forEach {
            buttonStackView3.addArrangedSubview($0)
        }
        
        buttonStackView4.axis = .horizontal
        buttonStackView4.distribution = .fillEqually
        buttonStackView4.spacing = 10
        buttonStackView4.translatesAutoresizingMaskIntoConstraints = false
        [deselectButton, analyzeButton, organizeButton].forEach {
            buttonStackView4.addArrangedSubview($0)
        }
        
        [addButton, modifyButton, visualizerButton, deleteButton, deselectButton, analyzeButton, organizeButton].forEach {
            $0.layer.cornerRadius = 10
            $0.layer.borderWidth = 1
            $0.titleLabel?.lineBreakMode = .byTruncatingTail
            $0.setTitleColor(.systemBlue, for: .normal)
            $0.setTitleColor(.systemGray6, for: .highlighted)
            $0.backgroundColor = .systemGray3
            $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
            $0.layer.shadowOpacity = 0.5
            $0.layer.shadowOffset = CGSize(width: 0, height: 5)
            $0.layer.shadowRadius = 5
        }
        
        
        [intro, activityName, activityDescription, tableView, buttonStackView1, buttonStackView2, activityCategoryPicker, buttonStackView3, buttonStackView4].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            
            // Vincoli per le Label
            intro.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            intro.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            intro.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            activityName.topAnchor.constraint(equalTo: intro.bottomAnchor, constant: 20),
            activityName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            activityName.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            activityDescription.topAnchor.constraint(equalTo: activityName.bottomAnchor, constant: 20),
            activityDescription.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            activityDescription.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // StackView 3
            buttonStackView3.topAnchor.constraint(equalTo: activityDescription.bottomAnchor, constant: 10),
            buttonStackView3.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonStackView3.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            activityCategoryPicker.topAnchor.constraint(equalTo: buttonStackView3.bottomAnchor, constant: 10),
            activityCategoryPicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            activityCategoryPicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // StackView 2
            buttonStackView2.topAnchor.constraint(equalTo: activityCategoryPicker.bottomAnchor, constant: 20),
            buttonStackView2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonStackView2.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // StackView 1
            buttonStackView1.topAnchor.constraint(equalTo: buttonStackView2.bottomAnchor, constant: 20), // Spazio sopra la prima riga
            buttonStackView1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonStackView1.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            buttonStackView4.topAnchor.constraint(equalTo: buttonStackView1.bottomAnchor, constant: 20),
            buttonStackView4.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonStackView4.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            tableView.topAnchor.constraint(equalTo: buttonStackView4.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        ])
    }
    
    // MARK: - Azioni dei Bottoni
    
    @objc func addActivity(){
        // Recupera i valori dai campi di input
        if recoveryData() { // Potresti far restituire un Bool per indicare il successo
            // Ottieni il contesto di Core Data
            let context = getContext()
            
            // Crea una nuova entità ActivityEntity
            guard let entity = NSEntityDescription.entity(forEntityName: "ActivityEntity", in: context) else {
                fatalError("Impossibile trovare l'entità ActivityEntity")
            }
            
            let newActivityEntity = NSManagedObject(entity: entity, insertInto: context) as! ActivityEntity
            newActivityEntity.name = activityNameText
            newActivityEntity.descript = activityDescriptionText
            newActivityEntity.date = activityDueDate
            newActivityEntity.category = activityCategoryText
            newActivityEntity.state = isActivityCompleted
            newActivityEntity.timeEstimed = Int64(estimatedTime ?? 0) // Usa un valore di default se nil
            newActivityEntity.timeSpent = Int64(elapsedTime ?? 0)   // Usa un valore di default se nil
            
            // Salva il contesto
            do {
                try context.save()
                print("Attività salvata in Core Data con successo!")
                loadActivities()
                activityName.text = ""
                activityDescription.text = ""
                activityEstimatedTimeTextField.text = ""
                activityElapsedTimeTextField.text = ""
            } catch let error as NSError {
                print("Errore nel salvataggio dell'attività: \(error), \(error.userInfo)")
            }
        }
    }
    
    @objc func modifyActivity() {
        // 1. Dovrai avere un modo per identificare quale attività vuoi modificare
        //    (in questo caso, l'attività selezionata nella tabella e memorizzata in `selectedActivityEntity`).
        
        // 2. Recupera i valori aggiornati dai campi di input.
        guard let name = activityName.text, !name.isEmpty else {
            print("Nome attività vuoto")
            return
        }
        activityNameText = name
        
        guard let description = activityDescription.text, !description.isEmpty else {
            print ("Descrizione attività vuota")
            return
        }
        activityDescriptionText = description
        
        activityDueDate = activityDatePicker.date
        
        // 3. Recupera la categoria aggiornata.
        guard let category = selectedCategory else {
            print ("Categoria attività non valida")
            return
        }
        activityCategoryText = category
        
        // 4. Recupera lo stato di completamento aggiornato.
        isActivityCompleted = activityCompletionSwitch.selectedSegmentIndex == 1
        
        // 5. Recupera i tempi aggiornati.
        guard let estimatedTimeStr = activityEstimatedTimeTextField.text, !estimatedTimeStr.isEmpty, let estimated = Int(estimatedTimeStr) else {
            print("Tempo stimato attività non valido")
            return
        }
        estimatedTime = estimated
        
        guard let elapsedTimeStr = activityElapsedTimeTextField.text, !elapsedTimeStr.isEmpty, let elapsed = Int(elapsedTimeStr) else {
            print("Tempo effettivo attività non valido")
            return
        }
        elapsedTime = elapsed
        
        // 6. Aggiorna l'attività esistente nel tuo modello dati con i nuovi valori.
        if let activityToUpdate = self.selectedActivityEntity {
            activityToUpdate.name = activityNameText
            activityToUpdate.descript = activityDescriptionText
            activityToUpdate.date = activityDueDate
            activityToUpdate.category = activityCategoryText
            activityToUpdate.state = isActivityCompleted
            activityToUpdate.timeEstimed = Int64(estimatedTime ?? 0)
            activityToUpdate.timeSpent = Int64(elapsedTime ?? 0)
            
            // 7. Salva le modifiche nel sistema di persistenza.
            let context = getContext()
            do {
                try context.save()
                print("Attività modificata con successo!")
                loadActivities() // Ricarica la tabella per mostrare le modifiche
                // Resetta i campi di input (opzionale)
                activityName.text = ""
                activityDescription.text = ""
                activityEstimatedTimeTextField.text = ""
                activityElapsedTimeTextField.text = ""
            } catch let error as NSError {
                print("Errore durante la modifica dell'attività: \(error), \(error.userInfo)")
                // Potresti mostrare un alert all'utente sull'errore
            }
            
            // 8. Mostra un feedback all'utente che la modifica è stata completata.
            print("Modifica Attività completata")
            
        } else {
            print("Nessuna attività selezionata per la modifica.")
            // Potresti mostrare un alert all'utente che deve prima selezionare un'attività
        }
    }
    
    // MARK: - Funzioni Mancanti
    
    @objc func deleteActivity(){
        // 1. Similmente alla modifica, avrai bisogno di identificare quale attività eliminare.
        guard let name = activityName.text, !name.isEmpty else {
            print("Nome attività vuoto")
            return
        }
        activityNameText = name
        
        guard let description = activityDescription.text, !description.isEmpty else {
            print ("Descrizione attività vuota")
            return
        }
        activityDescriptionText = description
        
        activityDueDate = activityDatePicker.date
        
        // 3. Recupera la categoria aggiornata.
        guard let category = selectedCategory else {
            print ("Categoria attività non valida")
            return
        }
        activityCategoryText = category
        isActivityCompleted = activityCompletionSwitch.selectedSegmentIndex == 1
        
        guard let estimatedTimeStr = activityEstimatedTimeTextField.text, !estimatedTimeStr.isEmpty, let estimated = Int(estimatedTimeStr) else {
            print("Tempo stimato attività non valido")
            return
        }
        estimatedTime = estimated
        
        guard let elapsedTimeStr = activityElapsedTimeTextField.text, !elapsedTimeStr.isEmpty, let elapsed = Int(elapsedTimeStr) else {
            print("Tempo effettivo attività non valido")
            return
        }
        elapsedTime = elapsed

        // 2. Rimuovi l'attività dal tuo modello dati.
        if let activityToUpdate = self.selectedActivityEntity{
            activityToUpdate.name = activityNameText
            activityToUpdate.descript = activityDescriptionText
            activityToUpdate.date = activityDueDate
            activityToUpdate.category = activityCategoryText
            activityToUpdate.state = isActivityCompleted
            activityToUpdate.timeEstimed = Int64(estimatedTime ?? 0)
            activityToUpdate.timeSpent = Int64(elapsedTime ?? 0)
            let context = getContext()
        // 3. Aggiorna il sistema di persistenza rimuovendo l'attività.
            context.delete(activityToUpdate)
            print("Attività eliminata con successo!")
        // 4. Aggiorna l'interfaccia utente se stai visualizzando le attività (es. ricaricare una tabella).
            loadActivities() // Ricarica la tabella per mostrare le modifiche
            // Resetta i campi di input (opzionale)
            activityName.text = ""
            activityDescription.text = ""
            activityEstimatedTimeTextField.text = ""
            activityElapsedTimeTextField.text = ""
        }
        // 5. Mostra un feedback all'utente che l'attività è stata eliminata.
        print("Elimina Attività")
    }
    
    @objc func categorizeActivity(){
        // Questa funzione potrebbe non essere direttamente collegata a un bottone.
        // La logica per gestire la selezione della categoria avverrà probabilmente nei metodi del delegate del `activityCategoryPicker`
        let context = getContext()
        let fetchRequest: NSFetchRequest<ActivityEntity> = ActivityEntity.fetchRequest()
        
        //sorter category
        let sortDescriptor = NSSortDescriptor(key: "category", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        var arrayAlert: [String] = []
        
        //visulizer table sorted by category
        do {
            let fetchedCategory = try context.fetch(fetchRequest)
            fetchedCategory.forEach {
                arrayAlert += [$0.value(forKey: "category") as! String, $0.value(forKey: "name") as! String]
                //print($0.value(forKey: "category") as! String, $0.value(forKey: "name") as! String)
            }
            //show all category and name in one alert
            showAlert(title: "Categorie Attività", message: arrayAlert.joined(separator: "\n"))
            //loadActivities()
            //tableView.reloadData()
        } catch {
            print("Fetch failed: \(error)")
        }

        // Tuttavia, potresti avere bisogno di una funzione per:
        // 1. Caricare le categorie esistenti (se le stai gestendo in modo persistente).
        // 2. Permettere all'utente di aggiungere nuove categorie (potrebbe essere un'altra schermata o un alert).
        print("Categorizza Attività")
    }
    
    @objc func analizarPredict(){
        // 1. Recupera la cronologia delle attività completate (dal sistema di persistenza).
        guard let category = selectedCategory else {
            print ("Categoria attività non valida")
            return
        }
        activityCategoryText = category
        let context = getContext()
        let fetchRequest: NSFetchRequest<ActivityEntity> = ActivityEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "category == %@", category)
        
        // 2. Implementa la logica per l'analisi predittiva:
        //    - Stime di tempo: Calcola la media dei tempi di completamento per attività simili o della stessa categoria.
            do{
                let result = try context.fetch(fetchRequest)
                //print("fetchRequest: \(result)")
                // Prendo i tempi di completamento della categoria
                print("timeSpent of \(result.map(\.timeSpent))")
                
                //Sommo i tempi di completamento
                let sumTimeSpent: Int64 = result.reduce(0) { $0 + $1.timeSpent }
                print("sumTimeEstimated: \(sumTimeSpent)")
                
                //Conto quante attività ci sono
                let count = result.count
                print("count: \(count)")
                
                //Calcolo la media
                let media: Int64 = sumTimeSpent / Int64(count)
                print("media: \(media)")
                
                //Imposto il campo di tempo stimato
                activityEstimatedTimeTextField.text = "\(media)"
                
            } catch let error as NSError {
                print("Errore CoreData: \(error), \(error.userInfo)")
                showAlert(title: "Errore Salvataggio", message: "Impossibile salvare i dati: \(error.localizedDescription)")
            }
        //    - Priorità suggerite: Definisci una logica basata sulle scadenze e sui tempi stimati/effettivi.
        //    - Pattern di produttività: Analizza i dati di completamento per identificare i momenti o i giorni più produttivi.
        // 3. Potresti voler memorizzare o visualizzare questi risultati da qualche parte nell'app.
        print("Analisi Predittiva")
    }
    
    func recoveryData() -> Bool {
        guard let name = activityName.text, !name.isEmpty else {
            print("Nome attività vuoto")
            return false
        }
        activityNameText = name
        
        guard let description = activityDescription.text, !description.isEmpty else {
            print ("Descrizione attività vuota")
            return false
        }
        activityDescriptionText = description
        
        activityDueDate = activityDatePicker.date
        
        guard let category = selectedCategory else {
            print ("Categoria attività non valida")
            return false
        }
        activityCategoryText = category
        
        isActivityCompleted = activityCompletionSwitch.selectedSegmentIndex == 1
        
        guard let estimatedTimeStr = activityEstimatedTimeTextField.text, !estimatedTimeStr.isEmpty, let estimated = Int(estimatedTimeStr) else {
            print("Tempo stimato attività non valido")
            return false
        }
        estimatedTime = estimated
        
        if !activityCompletionSwitch.isEnabled {
            guard let elapsedTimeStr = activityElapsedTimeTextField.text, !elapsedTimeStr.isEmpty, let elapsed = Int(elapsedTimeStr) else {
                print("Tempo effettivo attività non valido")
                return false
            }
            elapsedTime = elapsed
        }
        
        return true
    }
    
    // Funzione per ottenere il contesto di Core Data
    func getContext() -> NSManagedObjectContext {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Impossibile ottenere l'AppDelegate")
        }
        return appDelegate.persistentContainer.viewContext
    }
    
    // Funzione per caricare le attività da Core Data (ora semplicemente ricarica la tabella)
    func loadActivities() {
        print("Ricarica dati tabella da Core Data")
        tableView.reloadData()
    }
    
    // MARK: - Azione per aggiornare la tabella
    @objc func updateTableData() {
        print("Richiesta di aggiornamento tabella")
        loadActivities() // Assicura che la tabella venga ricaricata
    }
    
    @objc func deselectTableData() {
        activityName.text = ""
        activityDescription.text = ""
        activityEstimatedTimeTextField.text = ""
        activityElapsedTimeTextField.text = ""
    }
}

// MARK: - Estensioni per UIPickerView (Delegate e DataSource)

// MARK: - UITableViewDataSource

extension prova: UIPickerViewDelegate, UIPickerViewDataSource  {
    // Dovrai definire un array di categorie
    //let categories = ["Lavoro", "Personale", "Studio", "Hobby", "Altro"] // Esempio
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1 // Di solito un solo componente per una lista semplice
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCategory = categories[row]
        print("Categoria selezionata: \(selectedCategory ?? "Nessuna")")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let context = getContext()
        let fetchRequest: NSFetchRequest<ActivityEntity> = ActivityEntity.fetchRequest()
        do {
            return try context.count(for: fetchRequest)
        } catch let error as NSError {
            print("Errore nel conteggio delle attività: \(error), \(error.userInfo)")
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityCell", for: indexPath)
        let context = getContext()
        let fetchRequest: NSFetchRequest<ActivityEntity> = ActivityEntity.fetchRequest()
        fetchRequest.fetchOffset = indexPath.row
        fetchRequest.fetchLimit = 1
        
        do {
            let results = try context.fetch(fetchRequest)
            if let activityEntity = results.first {
                cell.textLabel?.text = "Name: \(activityEntity.name ?? "") Categoria: \(activityEntity.category ?? "")"
                cell.detailTextLabel?.numberOfLines = 0
                cell.detailTextLabel?.text = "Description: \(activityEntity.descript ?? "")\nData: \(activityEntity.date ?? Date())\nCompletata: \(activityEntity.state ? "Sì" : "No")\nTempo Stimato: \(activityEntity.timeEstimed)\nTempo Speso: \(activityEntity.timeSpent)"
            } else {
                cell.textLabel?.text = "Errore nel caricamento dell'attività"
                cell.detailTextLabel?.text = ""
            }
        } catch let error as NSError {
            print("Errore nel caricamento dell'attività per la cella: \(error), \(error.userInfo)")
            cell.textLabel?.text = "Errore di caricamento"
            cell.detailTextLabel?.text = ""
        }
        return cell
    }
    
    
    // MARK: - UITableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let context = getContext()
        let fetchRequest: NSFetchRequest<ActivityEntity> = ActivityEntity.fetchRequest()
        fetchRequest.fetchOffset = indexPath.row
        fetchRequest.fetchLimit = 1
        
        do {
            let results = try context.fetch(fetchRequest)
            if let selectedActivity = results.first {
                print("Hai selezionato l'attività: \(selectedActivity.name ?? "Nessun nome")")
                
                // Memorizza l'entità selezionata
                self.selectedActivityEntity = selectedActivity
                
                // Popola i campi di input con i dati dell'attività selezionata
                activityName.text = selectedActivity.name
                activityDescription.text = selectedActivity.descript
                activityDatePicker.date = selectedActivity.date ?? Date()
                
                if let category = selectedActivity.category, let categoryIndex = categories.firstIndex(of: category) {
                    activityCategoryPicker.selectRow(categoryIndex, inComponent: 0, animated: true)
                    selectedCategory = category // Aggiorna la variabile selectedCategory
                }
                
                activityCompletionSwitch.selectedSegmentIndex = selectedActivity.state ? 1 : 0 // 1 per "Completato", 0 per "Non Completato"
                
                activityEstimatedTimeTextField.text = "\(selectedActivity.timeEstimed)"
                activityElapsedTimeTextField.text = "\(selectedActivity.timeSpent)"
                
                showAlert(title: "ActivityName: \(selectedActivity.name ?? "N/A")", message: "Description: \(selectedActivity.descript ?? "N/A")\nDate: \(selectedActivity.date ?? Date())\nCategory: \(selectedActivity.category ?? "N/A")\nState: \(selectedActivity.state)\nTimeEstimed: \(selectedActivity.timeEstimed)\nTimeSpent: \(selectedActivity.timeSpent)")
                
                // Deseleziona la riga per evitare che rimanga evidenziata
                tableView.deselectRow(at: indexPath, animated: true)
            }
        } catch let error as NSError {
            print("Errore nel recupero dell'attività selezionata: \(error), \(error.userInfo)")
        }
    }
    // MARK: - Helper Methods
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
