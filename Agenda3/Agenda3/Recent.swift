//
//  Recent.swift
//  Agenda3
//
//  Created by Naoki Matsumoto on 2020/05/11.
//  Copyright © 2020 Naoki Matsumoto. All rights reserved.
//

import SwiftUI
import CoreData

struct Recent: View {
    @Environment(\.managedObjectContext) var context
    @FetchRequest(
        entity: Agenda.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Agenda.date, ascending: false)]
    ) var titleList:FetchedResults<Agenda>
    @State private var searchText:String=""
    var body: some View {
        NavigationView{
            ZStack{
                VStack{
                 SearchBar(text: $searchText, placeholder: "Search Agenda")
                List{
                    ForEach(titleList.filter {
                        self.searchText.isEmpty ? true : $0.title!.lowercased().contains(self.searchText.lowercased())}){title in AgendaRow(agenda: title)
                    }.onDelete(perform: delete)
                }.navigationBarTitle("議事録一覧")}
                .navigationBarItems(leading:
                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                        Image(systemName: "gear").imageScale(.large)
                    },trailing: EditButton())
        VStack{
            Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        self.addAgenda()
                    }, label: {
                        Text("+")
                        .font(.system(.largeTitle))
                        .frame(width: 77, height: 70)
                        .foregroundColor(Color.white)
                        .padding(.bottom, 7)
                    })
                    .background(Color.blue)
                    .cornerRadius(38.5)
                    .padding()
                    .shadow(color: Color.black.opacity(0.3),
                            radius: 3,
                            x: 3,
                            y: 3)
                }
            }
            }
        }
    }
    func addAgenda(){
        let newAgenda=Agenda(context:context)
        newAgenda.title=searchText
        newAgenda.id=UUID()
        newAgenda.date=Date()
        do{
            try context.save()
        }catch{
            print(error)
        }
    }
    func delete(at offset:IndexSet){
        guard let idx=offset.first
            else{return}
        let dagenda=titleList[idx]
      context.delete(dagenda)
}
}
struct AgendaRow :View {
    var agenda:Agenda
    var body:some View{
        Text(agenda.title ?? "NO name given")
    }
}

struct SearchBar: UIViewRepresentable {

    @Binding var text: String
    var placeholder: String

    class Coordinator: NSObject, UISearchBarDelegate {

        @Binding var text: String

        init(text: Binding<String>) {
            _text = text
        }

        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
        }
    }

    func makeCoordinator() -> SearchBar.Coordinator {
        return Coordinator(text: $text)
    }

    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        searchBar.placeholder = placeholder
        searchBar.searchBarStyle = .minimal
        searchBar.autocapitalizationType = .none
        return searchBar
    }

    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
        uiView.text = text
    }
}


struct Recent_Previews: PreviewProvider {
    static var previews: some View {
      let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

       return Recent().environment(\.managedObjectContext, context)
    }
}
