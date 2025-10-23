# 🧭 Swift Utility App (Geometria)

Un progetto personale scritto in **Swift**, che raccoglie diverse funzionalità legate a **crittografia, geometria, gestione di manga, conversioni** e **magazzino**.  
L’obiettivo è sperimentare e approfondire diversi concetti di programmazione in Swift, dall’uso della logica matematica all’organizzazione dei dati.

---

## 🚀 Funzionalità principali

### 🔐 Crittografia

Tre moduli interattivi che permettono di esplorare e comprendere i principali algoritmi di **crittografia asimmetrica e a chiave condivisa**, ciascuno con un’interfaccia grafica sviluppata in **UIKit**.

---

#### 🔸 RSA

##### 🧱 Interfaccia
- **UITextField**
  - `pText` → primo numero primo (P)  
  - `qText` → secondo numero primo (Q)  
  - `eText` → esponente pubblico (E)  
  - `mText` → messaggio da cifrare (M)  
- **UILabel**
  - `label` → titolo o descrizione del modulo  
  - `resultLabel` → mostra il risultato cifrato  
  - `resultchiaviLabel` → visualizza le chiavi pubblica e privata generate  
  - `resultmLabel` → mostra il messaggio decifrato  
- **UIButton**
  - `calculateButton` → avvia il calcolo di chiavi, cifratura e decifratura  
  - `closeButton` → chiude la schermata  

##### ⚙️ Funzionalità
- Generazione chiavi RSA (pubblica e privata)  
- Cifratura e decifratura del messaggio M  
- Visualizzazione dei risultati in modo chiaro e immediato  
- Gestione errori e input validation  

---

#### 🔸 Rabin

##### 🧱 Interfaccia
- **UITextField**
  - `nText` → numero n da utilizzare per la cifratura  
- **UILabel**
  - `label` → titolo della schermata  
  - `resultLabel` → mostra il risultato cifrato o decifrato  
- **UIButton**
  - `calculateButton` → esegue il calcolo  
  - `closeButton` → chiude la schermata  

##### ⚙️ Funzionalità
- Implementazione base dell’algoritmo di **Rabin**  
- Calcolo dei valori crittografici passo per passo  
- Interfaccia semplice per visualizzare il risultato  

---

#### 🔸 Diffie-Hellman

##### 🧱 Interfaccia
- **UITextField**
  - `qText` → numero primo q (base per la generazione delle chiavi)  
- **UILabel**
  - `introlabel` → titolo della schermata  
  - `resultLabel` → mostra la radice primitiva  
  - `result2Label` → visualizza la chiave di sessione condivisa  
- **UIButton**
  - `calculateButton` → calcola la chiave di sessione K  
  - `closeButton` → chiude la schermata  

##### ⚙️ Funzionalità
- Calcolo della radice primitiva e della chiave condivisa K  
- Simulazione dello scambio di chiavi Diffie-Hellman  
- Interfaccia educativa per comprendere i passaggi dell’algoritmo  

---

#### 💡 Obiettivo
Sperimentare e visualizzare in modo interattivo gli algoritmi di base della **crittografia moderna**, combinando:
- logica matematica e teoria dei numeri  
- progettazione di interfacce **UIKit**  
- elaborazione e visualizzazione di risultati in tempo reale

---

### 📐 Forme Geometriche

Due moduli interattivi con interfaccia grafica **UIKit** dedicati alle principali forme geometriche: **Rettangolo** e **Quadrato**.  
Consentono all’utente di inserire i valori, visualizzare la forma e calcolare area e perimetro.

---

#### 🟦 Rettangolo

##### 🧱 Interfaccia
- **UITextField**
  - `baseText` → base del rettangolo  
  - `altezzaText` → altezza del rettangolo  
- **UILabel**
  - `intro` → testo introduttivo o istruzioni  
  - `resultArea` → mostra l’area calcolata  
  - `resultPerimeter` → mostra il perimetro calcolato  
- **UIView**
  - `rettangolo` → rappresentazione grafica del rettangolo  
- **UIButton**
  - `calculateAreaButton` → calcola l’area  
  - `calculatePerimeterButton` → calcola il perimetro  
  - `updateButton` → aggiorna la forma con i nuovi valori  
  - `closeButton` → chiude la schermata  

##### ⚙️ Funzionalità
- Calcolo area e perimetro  
- Aggiornamento grafico del rettangolo in base ai dati inseriti  
- Controllo degli input e gestione errori  
- Chiusura o reset della schermata

---

#### ⬛ Quadrato

##### 🧱 Interfaccia
- **UITextField**
  - `latoText` → lato del quadrato  
- **UILabel**
  - `intro` → testo introduttivo  
  - `resultAreaLabel` → mostra l’area calcolata  
  - `resultPerimeterLabel` → mostra il perimetro calcolato  
- **UIView**
  - `quadrato` → rappresentazione grafica del quadrato  
- **UIButton**
  - `calculateAreaButton` → calcola l’area  
  - `calculatePerimeterButton` → calcola il perimetro  
  - `updateButton` → aggiorna la forma  
  - `closeButton` → chiude la schermata  

##### ⚙️ Funzionalità
- Calcolo area e perimetro in tempo reale  
- Aggiornamento dinamico della forma  
- Input validation e UI aggiornata con i risultati  

#### 💡 Obiettivo
Mostrare in modo interattivo le formule geometriche base e sperimentare:
- Event handling con **UIButton**  
- Aggiornamento dinamico delle **UIView**  
- Gestione e validazione degli input utente

---

### 📚 Gestionale Manga

Un modulo con **interfaccia grafica UIKit** per gestire e monitorare i manga e gli episodi visti o letti.

#### 🧱 Interfaccia
- **UILabel**
  - `introLabel` → testo introduttivo o titolo della schermata  
- **UITextField**
  - `nameTextField` → nome del manga o serie  
  - `capTextField` → numero di capitoli letti  
  - `episodeTextField` → numero di episodi visti  
  - `seasonTextField` → stagione attuale o totale  
- **UIButton**
  - `saveButton` → salva un nuovo record (manga o aggiornamento progresso)  
  - `fetchButton` → mostra tutti i manga salvati  
  - `eraseButton` → elimina un elemento selezionato  
  - `closeButton` → chiude la schermata o torna al menu principale  
- **UITableView**
  - `tableView` → elenca i manga registrati con i rispettivi progressi  

#### ⚙️ Funzionalità principali
- Aggiunta, visualizzazione ed eliminazione di record manga  
- Memorizzazione dei dati (es. tramite `UserDefaults` o `CoreData`)  
- Interfaccia grafica reattiva con **UITableView** per la lista dei titoli  
- Validazione dell’input e aggiornamento dinamico dell’elenco  

#### 💡 Obiettivo
Fornire un semplice gestionale per manga e anime, utile per esercitarsi con:
- UIKit (campi di testo, pulsanti, tabelle)
- Persistenza dei dati locali
- Strutture Swift orientate agli oggetti
  
---

### 🌡️ Convertitore di Temperatura

Un modulo con **interfaccia grafica UIKit** che consente di convertire facilmente una temperatura da una scala all’altra.

#### 🧱 Interfaccia
- **UITextField**
  - `tText` → campo di input per inserire la temperatura da convertire  
- **UILabel**
  - `label` → titolo o istruzioni nella parte superiore della schermata  
  - `resultLabel` → mostra il risultato della conversione  
- **UISegmentedControl**
  - `switchControl` → permette di scegliere il tipo di conversione (es. Celsius ↔ Fahrenheit ↔ Kelvin)  
- **UIProgressView**
  - `progressView` → rappresenta graficamente la temperatura su una scala progressiva  
- **UIImageView**
  - `iconImageView`, `icon2ImageView` → icone illustrative (es. sole e neve)  
- **UIButton**
  - `calculateButton` → avvia la conversione  

#### ⚙️ Funzionalità principali
- Conversione tra:
  - Celsius ↔ Fahrenheit  
  - Fahrenheit ↔ Celsius
- Aggiornamento dinamico della UI con il risultato
- Barra di progresso che varia in base alla temperatura
- Validazione dell’input (solo numeri, gestione errori)

#### 💡 Obiettivo
Offrire un’interfaccia intuitiva per comprendere le relazioni tra diverse scale termiche, unendo logica matematica e design UIKit.

---

### 📦 Magazzino

Un modulo con interfaccia grafica per la **gestione del magazzino**, sviluppato con **UIKit**.

#### 🧱 Interfaccia
L’utente può interagire tramite i seguenti elementi:
- **UITextField**
  - `nomeTextField` → nome del prodotto  
  - `categoriaTextField` → categoria merceologica  
  - `prezzoTextField` → prezzo unitario  
  - `quantitaTextField` → quantità disponibile  
  - `codiceIdentificativoTextField` → codice univoco del prodotto  
- **UIButton**
  - `addButton` → aggiunge un nuovo prodotto  
  - `searchButton` → cerca un prodotto nel magazzino  
  - `deleteButton` → elimina un prodotto esistente  
  - `showButton` → mostra tutti i prodotti in elenco  
  - `groupButton` → raggruppa i prodotti per categoria  
  - `saveInventoryButton` → salva l’inventario su file o memoria locale  
  - `loadInventoryButton` → carica l’inventario salvato  

#### ⚙️ Funzionalità principali
- Aggiunta, ricerca, eliminazione e visualizzazione dei prodotti  
- Raggruppamento per categoria  
- Salvataggio e caricamento dei dati (es. con `UserDefaults` o file locale)  
- Validazione degli input (controllo campi vuoti o dati non validi)

#### 💡 Obiettivo
Permettere una gestione semplice e intuitiva del magazzino, sfruttando UIKit per l’interfaccia e strutture Swift per la logica.


