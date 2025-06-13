//
//  DetailClientView.swift
//  Relayance
//
//  Created by Amandine Cousin on 10/07/2024.
//

import SwiftUI

struct DetailClientView: View {
    @ObservedObject var viewmodel: ClientViewmodel
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var client: Client
    
    var body: some View {
        VStack {
            Image(systemName: "person.circle")
                .resizable()
                .frame(width: 150, height: 150)
                .foregroundStyle(.orange)
                .padding(50)
            Spacer()
            Text(client.nom)
                .font(.title)
                .padding()
            Text(client.email)
                .font(.title3)
            Text(viewmodel.formatDateToString(client: client))
                .font(.title3)
            Spacer()
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Supprimer") {
                    viewmodel.deleteClient(client: client)
                    self.presentationMode.wrappedValue.dismiss()
                }
                .foregroundStyle(.red)
                .bold()
            }
        }
    }
}

#Preview {
    DetailClientView(viewmodel: ClientViewmodel(), client: Client(nom: "Tata", email: "tata@email", dateCreationString: "20:32 Wed, 30 Oct 2019"))
}
