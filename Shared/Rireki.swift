import SwiftUI
import RealmSwift
import GoogleMobileAds


struct NavigationConfigurator: UIViewControllerRepresentable {
    var configure: (UINavigationController) -> Void = { _ in }
    func makeUIViewController(context: UIViewControllerRepresentableContext<NavigationConfigurator>) -> UIViewController {
        UIViewController()
    }
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<NavigationConfigurator>) {
        if let nc = uiViewController.navigationController {
            self.configure(nc)
        }
    }
}
struct ContentViewCellModel {
    let id: String
    let condition : Bool
    let kirokuday : Date
    let lapsuu : Int
    let Rirekitotal : String
    let finalLap : String
    let tickets : RealmSwift.List<String>
    let ticketsTotal : RealmSwift.List<String>
}

class Model: Object {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var condition = false
    @objc dynamic var kirokuday = Date()
    @objc dynamic var lapsuu = 0
    @objc dynamic var Rirekitotal = ""
    @objc dynamic var finalLap = ""
    var tickets = RealmSwift.List<String>()                  // Listの定義？
    var ticketsTotal = RealmSwift.List<String>()                  // Listの定義？
}

class LapArray: Object {                                        //Listのためのclassを作成？
    @objc dynamic var lapArray: String = ""
    
    var memos: LinkingObjects<Model> {
        return LinkingObjects(fromType: Model.self, property: "tickets")}
}

class viewModel: ObservableObject {
    
    private var ArrayCount :Int = 0
    private var intArray = [Int]()
    
    private var token: NotificationToken?
    private var myModelResults = try? Realm().objects(Model.self).sorted(byKeyPath: "kirokuday", ascending: false)
    @Published var cellModels: [ContentViewCellModel] = []
    
    init() {
        token = myModelResults?.observe { [weak self] _ in
            self?.cellModels = self?.myModelResults?.map {ContentViewCellModel(id: $0.id, condition: $0.condition, kirokuday: $0.kirokuday, lapsuu: $0.lapsuu, Rirekitotal: $0.Rirekitotal, finalLap: $0.finalLap, tickets: $0.tickets, ticketsTotal: $0.ticketsTotal) } ?? []
        }
        
        self.cellModels = self.myModelResults?.map {ContentViewCellModel(id: $0.id, condition: $0.condition, kirokuday: $0.kirokuday, lapsuu: $0.lapsuu, Rirekitotal: $0.Rirekitotal, finalLap: $0.finalLap, tickets: $0.tickets, ticketsTotal: $0.ticketsTotal) } ?? []
    }
    
    deinit {
    }
}


struct Rireki: View {
    
    @State var lap234Purchase2 : String = "false"
    @ObservedObject var model = viewModel()
    @State private var idDetail = ""
    @State private var conditionDetail : Bool = false
    @State private var lapsuuDetail : Int = 0
    @State private var RirekitotalDetail : String = ""
    @State private var finalLaplDetail : String = ""
    @State private var kirokudayDetail = Date()
    @State private var ticketsDetail = RealmSwift.List<String>()
    @State private var ticketsTotalDetail = RealmSwift.List<String>()
    
    @State private var isShown: Bool = false
    @State private var isShown2: Bool = false
    @State private var showingAlert = false
    @State private var showAlert = false
    
    var dateFormat: DateFormatter {
        let dformat = DateFormatter()
        dformat.dateFormat = "yyyy/M/d"
        return dformat
    }
    
    var dateFormat2: DateFormatter {
        let dformat = DateFormatter()
        dformat.dateFormat = "HH時mm分"
        return dformat
    }
    
    
    init() {
        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        NavigationView {
            ZStack{
                LinearGradient(gradient: Gradient(colors: [Color("akaruiYellow") , .pink.opacity(0.4)]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                VStack{
                    List{
                        ForEach(model.cellModels, id: \.id) {
                            cellModel in
                            Button(action: {
                                idDetail = cellModel.id
                                conditionDetail = cellModel.condition
                                lapsuuDetail = cellModel.lapsuu
                                RirekitotalDetail = cellModel.Rirekitotal
                                finalLaplDetail = cellModel.finalLap
                                kirokudayDetail = cellModel.kirokuday
                                ticketsDetail = cellModel.tickets
                                ticketsTotalDetail = cellModel.ticketsTotal
                                self.showAlert = true
                            }, label: {
                                NavigationLink(destination: RirekiView(condition : conditionDetail, id: idDetail, lapsuu : lapsuuDetail, kirokuday : kirokudayDetail, Rirekitotal : RirekitotalDetail, finalLap : finalLaplDetail, tickets : ticketsDetail, ticketsTotal : ticketsTotalDetail), isActive: $showAlert) {
                                    HStack{
                                        VStack{
                                            HStack{
                                                Spacer().frame(width: 10)
                                                Text("\(dateFormat.string(from: cellModel.kirokuday))")
                                                    .font(.title)
                                                Spacer()
                                                Text("\(dateFormat2.string(from: cellModel.kirokuday))")
                                                    .font(.title)
                                            }
                                            HStack{
                                                Spacer().frame(width: 10)
                                                Text("記録数:\(cellModel.lapsuu)")
                                                    .font(.title2)
                                                    .foregroundColor(.orange)
                                                Spacer()
                                                Text("Total Time:")
                                                    .font(.title2)
                                            }
                                        }.frame(width: 300)
                                        Spacer()
                                        VStack{
                                            Spacer()
                                        Text("\(cellModel.Rirekitotal)")
                                                .font(.system(size: 40, design: .monospaced))
                                    }
                                        Spacer().frame(width: 100)
                                        if cellModel.condition == true {
                                            Image(systemName: "heart.fill")
                                                .foregroundColor(.pink)
                                        } else {
                                            Image(systemName: "heart.fill")
                                                .foregroundColor(.secondary)
                                        }
                                        Spacer().frame(width: 10)
                                    }.frame(height: 80)
                                }
                                .listRowBackground(Color.clear)
                            })
                            .buttonStyle(MyButtonStylelap())
                        }
                        .onDelete { indexSet in
                            let realm = try? Realm()
                            let index = indexSet.first
                            let target = realm?.objects(Model.self).filter("id = %@", self.model.cellModels[index!].id).first
                            try? realm?.write {
                                realm?.delete(target!)
                            }
                        }
                    .listRowInsets(EdgeInsets(top: 3, leading: 0, bottom: 3, trailing: 0))
                    .listRowBackground(Color.clear)
                }
                if lap234Purchase2 == "false"{
                    AdView()
                        .frame(width:700, height: 100)
                    Spacer().frame(height:10)
                }
            }            .frame(width: 700)

            .background(NavigationConfigurator { nc in
                nc.navigationBar.barTintColor = #colorLiteral(red: 0.9033463001, green: 0.9756388068, blue: 0.9194290638, alpha: 1)
                nc.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.white]
            })
        }
        .onAppear {
            let userDefaults = UserDefaults.standard
            if let value2 = userDefaults.string(forKey: "lap234") {
                print("lap234:\(value2)")
                lap234Purchase2 = value2
            }
        }
        .navigationBarHidden(true)
    }
}
}

struct MyButtonStylelap: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity, minHeight: 60)
            .background(Color.white.opacity(0.9))
            .cornerRadius(8)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .opacity(configuration.isPressed ? 0.4 : 1)
    }
}
