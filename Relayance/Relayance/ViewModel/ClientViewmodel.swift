//
//  ClientViewmodel.swift
//  Relayance
//
//  Created by Alassane Der on 29/05/2025.
//

import Foundation

class ClientViewmodel: ObservableObject {
    @Published var clients: [Client] = [] {
        didSet {
            print("changement détectée, sauvegarde des clients...")
            PersistenceService.save(clients: clients)
        }
    }/// le didset rend la sauvegarde automatique
    
    @Published var message: String = ""
    
    init() {
        chargerClients()
        print("clients chargés depuis persistance doc folder.)")
    }
    
    func chargerClients() {
        self.clients = PersistenceService.load()
    }
    
    func creerNouveauClient(nom: String, email: String) {
        /// verifier email avant de créer
        /// verifier existance du client avant de créer...eviter duplicat
        guard email.isEmail() else {
            message = "L'email n'est pas valide."
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        
        let newClient = Client(
            nom: nom,
            email: email,
            dateCreationString: dateFormatter.string(from: Date.now)
        )
        
        if !clientExist(client: newClient) {
            clients.append(newClient)
        } else {
            message = "Le client existe déjà."
        }
        
    }
    
    func estNouveauClient(client: Client) -> Bool {
        let today = Date.now
        let dateCreation = client.dateCreation
        
        if today.getDay() != dateCreation.getDay() ||
            today.getMonth() != dateCreation.getMonth() ||
            today.getDay() != dateCreation.getDay() {
            return false
        }
        return true
    }
    
    func clientExist(client: Client) -> Bool {
        clients.contains { $0.email == client.email }
    }
    
    func formatDateVersString(client: Client) -> String {
        return Date.stringFromDate(client.dateCreation) ?? client.dateCreationString
    }
    
    func supprimerClient(client: Client) {
        if let index = clients.firstIndex(where: { $0.id == client.id }) {
            clients.remove(at: index)
        }
    }
}
