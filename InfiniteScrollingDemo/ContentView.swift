//
//  ContentView.swift
//  InfiniteScrollingDemo
//
//  Created by Sharvari on 2023-11-01.
//

import SwiftUI

struct ContentView: View {
    @State var items = Array(1...15)
    @State var page = 1
    @State var loading = false
    var body: some View {
        NavigationStack{
            ZStack{
                ScrollView{
                    LazyVStack{
                        ForEach(items, id: \.self) { item in
                            HStack{
                                Image(systemName: "pencil")
                                    .imageScale(.large)
                                    .foregroundStyle(.tint)
                                    .tint(.blue)

                                Text("Item \(item)")
                                    .bold()

                                Spacer()
                            }
                            .padding()
                            .background(.blue.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                            .padding(.horizontal, 16)
                        }
                    }
                }
                .onScrolledToBottom{
                    requestItems()
                }
                .id("list")

                VStack(alignment: .center){
                    if loading {
                        ProgressView()
                            .tint(.blue)
                            .controlSize(.large)
                    }
                    Spacer()
                    HStack{
                        Spacer()
                        Text("Page \(page)")
                            .bold()
                            .padding()
                            .background(.blue)
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    }
                }
                .padding()
            }
            .navigationTitle("Infinite List")
        }
    }

    private func requestItems(){
        Task{
            loading = true
            try await Task.sleep(nanoseconds: 2_000_000_000)
            for _ in 1...10 {
                var newValue = Int.random(in: 1..<1000)
                if(items.first { $0 == newValue } != nil){
                    newValue = Int.random(in: 1..<1000)
                }
                items.append(newValue)
            }
            page += 1
            loading = false
        }
    }
}

extension ScrollView {
    func onScrolledToBottom(perform action: @escaping() -> Void) -> some View {
        return ScrollView<LazyVStack> {
            LazyVStack {
                self.content
                Rectangle().size(.zero).onAppear {
                    action()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
