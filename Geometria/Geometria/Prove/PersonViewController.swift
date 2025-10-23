//
//  PersonViewController.swift
//  Geometria
//
//  Created by Pietro Calamusa on 12/04/25.
//

import UIKit
import CoreData

class PersonViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let introLabel = UILabel()

    // Collega i tuoi UITextField tramite IBOutlet
    let nameTextField = UITextField()
    let ageTextField = UITextField()

    // Riferimento al contesto di Core Data
    var context: NSManagedObjectContext!
    var people: [NSManagedObject] = [] // Array per contenere le persone recuperate
    
    let buttonStackView1 = UIStackView()
    
    let saveButton = UIButton(type: .system)
    let eraseButton = UIButton(type: .system)
    let fetchButton = UIButton(type: .system)
    let closeButton = UIButton(type: .system)
    
    // Dichiarazione della UITableView
    let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Imposta il colore di sfondo della schermata
        view.backgroundColor = .lightGray
        
        setupCoreData()
        setupUI()
        setupConstraints()
        fetchManga()
        
    }
    
    // MARK: - Setup Methods
    func setupCoreData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Could not get AppDelegate") // Meglio usare fatalError se l'app non può funzionare senza
        }
        context = appDelegate.persistentContainer.viewContext
    }
    
    func setupUI() {
        
        introLabel.text = "Persone"
        introLabel.font = .systemFont(ofSize: 24, weight: .bold)
        introLabel.textAlignment = .center
        
        
        nameTextField.placeholder = "Nome"
        nameTextField.borderStyle = .roundedRect
        nameTextField.textAlignment = .center
        
        ageTextField.placeholder = "Età"
        ageTextField.borderStyle = .roundedRect
        ageTextField.textAlignment = .center
        
        
        // Crea il pulsante di salvataggio programmaticamente
        saveButton.setTitle("Save", for: .normal)
        saveButton.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        
        eraseButton.setTitle("Delete", for: .normal)
        eraseButton.addTarget(self, action: #selector(eraseButtonPressed), for: .touchUpInside)
        
        // Crea il pulsante di recupero persone programmaticamente
        fetchButton.setTitle("Show", for: .normal)
        fetchButton.addTarget(self, action: #selector(fetchButtonPressed), for: .touchUpInside)
        
        buttonStackView1.axis = .horizontal
        buttonStackView1.distribution = .fillEqually // O .equalSpacing
        buttonStackView1.spacing = 10 // Spazio tra i bottoni
        buttonStackView1.translatesAutoresizingMaskIntoConstraints = false
        [eraseButton, saveButton, fetchButton].forEach {
            buttonStackView1.addArrangedSubview($0)
        }
        
        // Crea e configura la UITableView programmaticamente
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "personCell")  // Registra la cella
        tableView.dataSource = self
        tableView.delegate = self
        tableView.layer.cornerRadius = 5 // Angoli arrotondati (opzionale)
        
        closeButton.setTitle("Close", for: .normal)
        closeButton.addTarget(self, action: #selector(closeScreen), for: .touchUpInside)
        
        [eraseButton, saveButton, fetchButton].forEach {
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
        
        [introLabel, nameTextField, ageTextField, tableView, closeButton, buttonStackView1].forEach {
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
            
            ageTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20),
            ageTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            ageTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            buttonStackView1.topAnchor.constraint(equalTo: ageTextField.bottomAnchor, constant: 20),
            buttonStackView1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonStackView1.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            
            tableView.topAnchor.constraint(equalTo: buttonStackView1.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
        ])
    }

    func savePerson(name: String, age: Int) {
        // Controlla se la persona esiste già nel contesto
        let fetchRequest: NSFetchRequest<Person> = Person.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        
        do {
            let results = try context.fetch(fetchRequest)
            if results.isEmpty {
                // Se non esiste, salviamo la nuova persona
                let entity = NSEntityDescription.entity(forEntityName: "Person", in: context)!
                let person = NSManagedObject(entity: entity, insertInto: context)
                
                person.setValue(name, forKey: "name")
                person.setValue(age, forKey: "age")
                
                try context.save()
                print("Persona salvata con successo!")
                // Dopo aver salvato, aggiorna la lista
                fetchManga()
            } else {
                print("La persona con nome \(name) esiste già.")
            }
        } catch let error as NSError {
            print("Errore durante la verifica o il salvataggio: \(error), \(error.userInfo)")
        }
    }
    
    func erasePeople(name: String) {
        // Controlla se la persona esiste già nel contesto
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person") // Cambiato il tipo qui
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)

        do {
            let peopleToDelete = try context.fetch(fetchRequest)
            if peopleToDelete.isEmpty {
                // Se non esiste
                print("La persona con nome \(name) non esiste.")
            } else {
                for person in peopleToDelete {
                    context.delete(person) // Usa context.delete per eliminare l'oggetto
                }
                try context.save() // Salva le modifiche dopo l'eliminazione
                fetchManga() // Aggiorna la tabella
                print("Persone con nome \(name) eliminate.")
            }
        } catch let error as NSError {
            print("Errore durante l'eliminazione: \(error), \(error.userInfo)")
        }
    }


    // Funzione per recuperare tutte le persone da Core Data
    func fetchManga() {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")
        
        // Aggiungi un ordinamento (opzionale, ma utile)
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true, selector: #selector(NSString.caseInsensitiveCompare))
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            people = try context.fetch(fetchRequest)
            tableView.reloadData()  // Ricarica la tabella con i dati aggiornati
        } catch let error as NSError {
            print("Errore durante il recupero: \(error), \(error.userInfo)")
        }
    }

    // Funzione chiamata quando premi il pulsante per salvare una persona
    @objc func saveButtonPressed(_ sender: UIButton) {
        guard let name = nameTextField.text, !name.isEmpty else {
            print("Nome mancante!")
            return
        }

        guard let ageText = ageTextField.text, let age = Int(ageText), age > 0 else {
            print("Età non valida!")
            return
        }
        // Salva la persona con il nome e l'età inseriti
        savePerson(name: name, age: age)
    }

    // Funzione chiamata quando premi un pulsante per recuperare le persone salvate
    @objc func fetchButtonPressed(_ sender: UIButton) {
        fetchManga()
    }
    
    @objc func eraseButtonPressed(_ sender: UIButton) {
        guard let name = nameTextField.text, !name.isEmpty else {
            print("Nome mancante!")
            return
        }
        erasePeople(name: name)
    }

    
    // MARK: - UITableView DataSource

    // Numero di righe nella tabella
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }

    // Configura le celle della tabella
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "personCell", for: indexPath)
        
        // Recupera la persona dalla lista
        let person = people[indexPath.row]
        
        // Ottieni il nome e visualizzalo nella cella
        if let name = person.value(forKey: "name") as? String {
            cell.textLabel?.text = name
        }
        
        return cell
    }

    // MARK: - UITableView Delegate

    // Opzionale: Puoi gestire azioni quando selezioni una riga della tabella
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let person = people[indexPath.row]
        if let name = person.value(forKey: "name") as? String {
            print("Hai selezionato \(name)")
        }
    }
    
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
