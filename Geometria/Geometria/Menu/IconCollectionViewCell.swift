//
//  IconCollectionViewCell.swift
//  Geometria
//
//  Created by Pietro Calamusa on 16/04/25.
//



import UIKit

class IconCollectionViewCell: UICollectionViewCell {

    // MARK: - Proprietà

    // ImageView per visualizzare l'icona
    let iconImageView = UIImageView()

    // MARK: - Inizializzatori

    // Inizializzatore chiamato quando la cella viene creata via codice
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews() // Chiama la funzione per configurare le subviews
    }

    // Inizializzatore richiesto se la cella venisse creata da uno Storyboard o da un file .xib
    // In questo caso, dato che la creiamo via codice, segnaliamo un errore se viene chiamato
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configurazione delle Viste

    // Funzione per impostare e disporre le subviews (iconImageView)
    private func setupViews() {
        // Imposta la modalità di ridimensionamento dell'immagine per adattarsi alla ImageView
        iconImageView.contentMode = .scaleAspectFit

        // Aggiunge la iconImageView alla vista del contenuto della cella
        contentView.addSubview(iconImageView)

        // MARK: - Constraints per iconImageView

        // Disabilita la traduzione automatica dei constraints per poter usare Auto Layout
        iconImageView.translatesAutoresizingMaskIntoConstraints = false

        // Attiva i seguenti constraints per definire la posizione e le dimensioni di iconImageView
        NSLayoutConstraint.activate([
            // Il bordo superiore di iconImageView è allineato al bordo superiore della contentView con una distanza di 8 punti
            iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            // Il bordo sinistro di iconImageView è allineato al bordo sinistro della contentView con una distanza di 8 punti
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            // Il bordo destro di iconImageView è allineato al bordo destro della contentView con una distanza di -8 punti
            iconImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            // Il bordo inferiore di iconImageView è allineato al bordo inferiore della contentView con una distanza di -8 punti
            iconImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
            // Puoi anche mantenere il constraint sull'altezza uguale alla larghezza se desideri icone quadrate
            // iconImageView.heightAnchor.constraint(equalTo: iconImageView.widthAnchor)
        ])

        // MARK: - Stile del Bordo della Cella

        // Imposta il colore del bordo della vista del contenuto della cella
        contentView.layer.borderColor = UIColor.black.cgColor
        // Imposta lo spessore del bordo della vista del contenuto della cella
        contentView.layer.borderWidth = 1.0
        // Imposta il raggio degli angoli della vista del contenuto della cella
        contentView.layer.cornerRadius = 8.0
        // Assicura che le subviews vengano ritagliate entro i limiti della vista del contenuto
        contentView.clipsToBounds = true
    }

    // MARK: - Gestione del Layout delle Subviews

    // Funzione chiamata quando i limiti della cella cambiano
    override func layoutSubviews() {
        super.layoutSubviews()
        // Assicura che il frame del layer del bordo sia sempre uguale ai limiti della vista del contenuto
        contentView.layer.frame = contentView.bounds
    }

    // MARK: - Preparazione per il Riutilizzo

    // Funzione chiamata quando la cella sta per essere riutilizzata
    override func prepareForReuse() {
        super.prepareForReuse()
        // Resetta l'immagine della ImageView
        iconImageView.image = nil
    }
}
