import Cocoa

class ViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {

    @IBOutlet weak var myTableView: NSTableView!
    @IBOutlet weak var titoloTextField: NSTextField!
    @IBOutlet weak var capitoloTextField: NSTextField!
    
    // Dizionario per gestire i dati (inizialmente vuoto)
    var titolo: [String: Int] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Imposta il dataSource e il delegate per la tableView
        myTableView.dataSource = self
        myTableView.delegate = self
    
        // Carica i dati dal file (o copia il file dal bundle, se necessario)
        copiaFileDalBundleSeNecessario()
        caricaDati()
        
        // Ricarica la tabella con i dati caricati
        myTableView.reloadData()
    }
    
    // Numero di righe nella tabella
    func numberOfRows(in tableView: NSTableView) -> Int {
        return titolo.count
    }
    
    // Contenuto delle celle
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let keys = Array(titolo.keys) // Ottieni un array delle chiavi
        let key = keys[row] // Chiave per la riga corrente
        let value = titolo[key]! // Valore associato alla chiave
        
        // Identifica la colonna
        if let identifier = tableColumn?.identifier {
            if identifier.rawValue == "TitoloColumn" {
                // Colonna del titolo
                if let cell = tableView.makeView(withIdentifier: identifier, owner: self) as? NSTableCellView {
                    cell.textField?.stringValue = key
                    return cell
                }
            } else if identifier.rawValue == "CapitoloColumn" {
                // Colonna del capitolo
                if let cell = tableView.makeView(withIdentifier: identifier, owner: self) as? NSTableCellView {
                    cell.textField?.stringValue = String(value)
                    return cell
                }
            }
        }
        return nil
    }
    
    // Aggiungi capitolo alla tabella
    @IBAction func aggiungiCapitolo(_ sender: NSButton) {
        guard !titoloTextField.stringValue.isEmpty, !capitoloTextField.stringValue.isEmpty else {
            print("Uno o entrambi i campi sono vuoti.")
            return
        }
        
        let titoloKey = titoloTextField.stringValue
        guard let capitoloValue = Int(capitoloTextField.stringValue) else {
            print("Valore non valido per il capitolo.")
            return
        }
        
        // Aggiorna o aggiungi il valore nel dizionario
        titolo[titoloKey] = capitoloValue
        
        // Salva i dati
        salvaDati()
        
        // Ricarica la tabella
        myTableView.reloadData()
        
        // Pulisci i campi di testo
        titoloTextField.stringValue = ""
        capitoloTextField.stringValue = ""
    }
    
    // Salva i dati su un file
    func salvaDati() {
        if let fileURL = ottieniPercorsoFile() {
            do {
                let jsonData = try JSONEncoder().encode(titolo)
                try jsonData.write(to: fileURL)
                print("Dati salvati correttamente!")
            } catch {
                print("Errore durante il salvataggio dei dati: \(error)")
            }
        }
    }
    
    // Carica i dati da un file
    func caricaDati() {
        if let fileURL = ottieniPercorsoFile() {
            do {
                let jsonData = try Data(contentsOf: fileURL)
                titolo = try JSONDecoder().decode([String: Int].self, from: jsonData)
                print("Dati caricati correttamente!")
            } catch {
                print("Errore durante il caricamento dei dati: \(error)")
            }
        }
    }
    
    // Ottieni il percorso del file
    func ottieniPercorsoFile() -> URL? {
        let fileManager = FileManager.default
        let currentDirectory = fileManager.currentDirectoryPath
        return URL(fileURLWithPath: "\(currentDirectory)/dati.json")
    }
    
    // Copia il file dati.json dal bundle alla directory di lavoro, se non esiste
    func copiaFileDalBundleSeNecessario() {
        let fileManager = FileManager.default
        if let destinationURL = ottieniPercorsoFile() {
            if !fileManager.fileExists(atPath: destinationURL.path) {
                if let bundleFileURL = Bundle.main.url(forResource: "dati", withExtension: "json") {
                    do {
                        try fileManager.copyItem(at: bundleFileURL, to: destinationURL)
                        print("File copiato nella directory: \(destinationURL.path)")
                    } catch {
                        print("Errore durante la copia del file: \(error)")
                    }
                } else {
                    // Se il file non esiste nel bundle, creiamolo vuoto
                    let datiVuoti: [String: Int] = [:]
                    do {
                        let jsonData = try JSONEncoder().encode(datiVuoti)
                        try jsonData.write(to: destinationURL)
                        print("File dati.json creato vuoto nella directory: \(destinationURL.path)")
                    } catch {
                        print("Errore durante la creazione del file: \(error)")
                    }
                }
            }
        }
    }

}
