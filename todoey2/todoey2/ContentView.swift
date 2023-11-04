//
//  ContentView.swift
//  todoey2
//
//  Created by Ellie Kim on 11/1/23.
//

import SwiftUI

struct ContentView: View {
    @State var newCategory: String = ""
    @State var colorCategory: String = ""
    @State var colorChoices: [String] = ["Pink", "Blue", "Green", "Yellow"]
    @State var listInformation: [ToDoList] = [ToDoList(listItems: [], color: Color.pink, listName: "Homework", image: Image(systemName: "book.fill")), ToDoList(listItems: [], color: Color.green, listName: "Gym", image: Image(systemName: "figure.run")), ToDoList(listItems: [], color: Color.yellow, listName: "App Team", image: Image(systemName: "iphone"))]
    
    var body: some View {
        NavigationView {
            ZStack {
    
                List {
                    ForEach(listInformation.indices, id: \.self) { index in
                        NavigationLink(destination: ToDoListView(list: self.$listInformation[index])) {
                            ToDoItemRow(ToDoName: self.listInformation[index].listName, listLength: self.listInformation[index].listItems.count, image: self.listInformation[index].image, color: self.listInformation[index].color)
                        }
                    }
                    Section("Add New Category"){
                        TextField("Type Here", text: $newCategory)
                        Picker("Color Choice", selection: $colorCategory) {
                            ForEach(colorChoices, id: \.self) {
                                Text($0)
                            }
                        }
                        .pickerStyle(.segmented)
                        Button(action: {
                            listInformation.append(ToDoList(listItems: [], color: stringToColor(color: colorCategory), listName: newCategory, image: Image(systemName: "circle.fill")))
                        }, label: {
                            Text("Add New Category")
                        })
                        
                    }
                }
                .navigationTitle("To Do Lists")
            }
        }
    }
}

struct ToDoItemRow: View {
    @State var ToDoName: String = ""
    var listLength: Int
    var image: Image
    var color: Color
    var body: some View {
        HStack {
            image
                .foregroundColor(color)
            TextField("Category Name", text: $ToDoName)
            Text("\(listLength)")
        }
    }
}

struct ToDoListView: View {
    @Binding var list: ToDoList
    @State var currentToDo: String = ""
    
    var body: some View {
        NavigationView {
            ZStack{
                Form {
                    TextField("Type Here", text: $currentToDo)
                    
                    Button(action: {
                        self.list.listItems.append(ToDoItem(name: self.currentToDo))
                        self.currentToDo = ""
                    }, label: {
                        Text("Add Here")
                            .foregroundColor(self.list.color)
                    })
                    
                    Section {
                        ForEach(list.listItems.indices, id: \.self) { index in
                            HStack {
                                Button(action: {
                                    self.list.listItems[index].isCompleted.toggle()
                                }) {
                                    Image(systemName: self.list.listItems[index].isCompleted ? "circle.fill" : "circle")
                                        .foregroundColor(self.list.color)
                                }
                                TextField("To Do Item", text: $list.listItems[index].name)
                                    .strikethrough(self.list.listItems[index].isCompleted ? true : false, color: self.list.color)
                            }
                        }
                    }
                }
                .navigationTitle(self.list.listName)
            }
        }
    }
}

struct ToDoItem: Identifiable, Hashable {
    var name: String
    var isCompleted: Bool = false
    let id = UUID()
}

struct ToDoList: Identifiable {
    var listItems: [ToDoItem]
    var color: Color
    var listName: String
    var image: Image
    let id = UUID()
}

func stringToColor(color: String) -> Color {
    switch (color){
    case "Pink":
        return .pink
    case "Blue":
        return .blue
    case "Green":
        return .green
    case "Yellow":
        return .yellow
    default:
        return .blue
    }
}
#Preview {
    ContentView()
}
