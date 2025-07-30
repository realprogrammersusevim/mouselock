import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    @StateObject var appState: AppState
    @State private var isImporting: Bool = false

    var body: some View {
        VStack(alignment: .leading) {
            Text("Resolution").font(.title2).padding(.bottom, 3)
            HStack() {
                VStack(alignment: .leading) {
                    Text("Width").padding(.bottom, -4)
                    TextField("Width", text: $appState.width)
                }
                VStack(alignment: .leading) {
                    Text("Height").padding(.bottom, -4)
                    TextField("Height", text: $appState.height)
                }
            }.padding(.bottom)
            Text("Activate").font(.title2).padding(.bottom, 3)
            VStack(alignment: .leading) {
                Text("Activate only when one of these apps are in focus or always.").fixedSize(horizontal: false, vertical: true)
                ForEach(self.appState.games.sorted(by: {$0.value < $1.value}), id: \.key) { key, value in
                    let name = value.components(separatedBy: "/").last ?? value
                    Toggle(name, isOn: Binding(
                        get: {self.appState.activegames[key] ?? false},
                        set: {value in self.appState.activegames[key] = value}
                    )).disabled(self.appState.active)
                }
                Button("Add App…") { isImporting.toggle() }
                Toggle("Always", isOn: $appState.active)
            }
        }.padding(30).padding(.top, -5).frame(width: 340)
        .fileImporter(isPresented: $isImporting, allowedContentTypes: [.application], allowsMultipleSelection: false) { result in
            switch result {
            case .success(let urls):
                if let url = urls.first {
                    appState.addGame(url: url)
                }
            case .failure(let error):
                print("Import failed: \(error.localizedDescription)")
            }
        }
    }
}
