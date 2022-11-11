
import SwiftUI
import RealmSwift


struct RirekiView: View {
    
    @State var screen: CGSize?
    @State var lap234Purchase3 : String = "false"
    @ObservedObject var model = viewModel()
    @State var condition : Bool = false
    var id = ""
    var lapsuu : Int = 0
    var lapcount = Array(1...99)
    var kirokuday = Date()
    var Rirekitotal : String = ""
    var finalLap : String = ""
    var tickets = RealmSwift.List<String>()
    var ticketsTotal = RealmSwift.List<String>()
    
    var dateFormat: DateFormatter {
        let dformat = DateFormatter()
        dformat.dateFormat = "yyyy/M/d"
        return dformat
    }
    
    var dateFormat2: DateFormatter {
        let dformat = DateFormatter()
        dformat.locale = NSLocale.system
        dformat.dateFormat = "HH時mm分"
        return dformat
    }
    
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [Color("akaruiYellow") , .pink.opacity(0.4)]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            VStack(spacing:5){
                HStack{
                Text("保存日時").font(.title2)
                    Spacer().frame(width: 20)
                    HStack{
                        Text("\(dateFormat.string(from: kirokuday))").font(.largeTitle)
                        Text(" \(dateFormat2.string(from: kirokuday))").font(.largeTitle)
                    }
                }
                Spacer().frame(height: 10)
                HStack{
                    VStack{
                        HStack{
                            VStack{
                                Text("Last").font(.title2)
                                Text("Time").font(.title2)
                            }
                            if Rirekitotal.count > 10 {
                                Text("\(Rirekitotal)")
                                    .font(Font.custom("HiraginoSans-W3", size: 35))
                                    .font(.system(size: 35, design: .monospaced))
                            } else if Rirekitotal.count > 9 {
                                Text("\(Rirekitotal)")
                                    .font(Font.custom("HiraginoSans-W3", size: 45))
                                    .font(.system(size: 45, design: .monospaced))
                            } else {
                                Text("\(Rirekitotal)")
                                    .font(Font.custom("HiraginoSans-W3", size: 50))
                                    .font(.system(size: 50, design: .monospaced))
                            }
                        }
                        Rectangle()
                            .foregroundColor(.orange)
                            .frame(width: 250, height: 1)
                        Spacer().frame(height: 10)
                        HStack{
                            VStack {
                                Text("Final").font(.title3)
                                Text("Lap").font(.title3)
                            }.padding(5)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.black, lineWidth: 1)
                                )
                            if finalLap.count > 10 {
                                Text("\(finalLap)")
                                    .font(Font.custom("HiraginoSans-W3", size: 35))
                                    .font(.system(size: 35, design: .monospaced))
                            } else if finalLap.count > 9 {
                                Text("\(finalLap)")
                                    .font(Font.custom("HiraginoSans-W3", size: 45))
                                    .font(.system(size: 45, design: .monospaced))
                            } else {
                                Text("\(finalLap)")
                                    .font(Font.custom("HiraginoSans-W3", size: 50))
                                    .font(.system(size: 50, design: .monospaced))
                            }
                        }}
                    Button(action: {
                        condition.toggle()
                    }){
                        VStack{
                            if condition == true {
                                Image(systemName: "heart.fill").font(.title)
                                    .foregroundColor(.pink)
                            } else {
                                Image(systemName: "heart.fill").font(.title)
                                    .foregroundColor(.secondary)
                            }
                            Text("favorite").font(.system(size: 13))
                        }}}
                
                HStack{
                    Spacer().frame(width: 10)
                    Text("順位").bold()
                    Spacer()
                    Text("測定タイム").bold()
                    Spacer()
                    Text("１つ前との差 ").bold()
                    Spacer().frame(width: 60)
                }
                if Rirekitotal.count < 9 {
                    List {
                        ForEach((0 ..< lapsuu).reversed(), id: \.self) { cellModel in
                            HStack(spacing:2){
                                Spacer().frame(width: 10)
                                VStack{
                                    Text("No.")
                                        .font(.system(size: 15, design: .monospaced))
                                    Text("\(lapsuu - lapcount[cellModel] + 1)")
                                        .font(.system(size: 25, design: .monospaced))
                                }
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.black, lineWidth: 1)
                                )
                                Spacer()
                                Text("\(ticketsTotal[cellModel])")
                                    .font(Font.custom("HiraginoSans-W3", size: (screen?.width ?? 100) * 0.06))
//                                    .font(Font.custom("HiraginoSans-W3", size: 50))
                                    .font(.system(size: 50, design: .monospaced))
                                Spacer()
                                Text("\(tickets[cellModel])")
                                    .font(Font.custom("HiraginoSans-W3", size: (screen?.width ?? 100) * 0.040))
//                                    .font(Font.custom("HiraginoSans-W3", size: 20))
                                    .font(.system(size: 20, design: .monospaced))
                            }
                            .listRowInsets(EdgeInsets())
                            .listRowBackground(Color("ColorOrange3"))
                            //                            .listRowBackground(Color.clear)
                            .listRowInsets(EdgeInsets(top: 3, leading: 0, bottom: 3, trailing: 0))
                        }
                    } .environment(\.defaultMinListRowHeight, 70)
                        .listStyle(PlainListStyle())
                        .font(.largeTitle)
                } else {
                    List {
                        ForEach((0 ..< lapsuu).reversed(), id: \.self) { cellModel in
                            HStack(spacing:2){
                                Spacer().frame(width: 10)
                                VStack{
                                    Text("No.")
                                        .font(.system(size: 15, design: .monospaced))
                                    Text("\(lapsuu - lapcount[cellModel] + 1)")
                                    //                        Text(lapNo[cellModel])
                                        .font(.system(size: 25, design: .monospaced))
                                }
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.black, lineWidth: 1)
                                )
                                Spacer()
                                Text("\(tickets[cellModel])")
                                    .font(Font.custom("HiraginoSans-W3", size: (screen?.width ?? 100) * 0.06))
//                                    .font(Font.custom("HiraginoSans-W3", size: 35))
                                    .font(.system(size: 41, design: .monospaced))
                                Spacer()
                                Text("\(ticketsTotal[cellModel])")
                                    .font(Font.custom("HiraginoSans-W3", size: (screen?.width ?? 100) * 0.04))
//                                    .font(Font.custom("HiraginoSans-W3", size: 18))
                                    .font(.system(size: 18, design: .monospaced))
                            }
                            .listRowInsets(EdgeInsets())
                            .listRowBackground(Color("ColorOrange4"))
                            //                            .listRowBackground(Color.clear)
                            .listRowInsets(EdgeInsets(top: 3, leading: 0, bottom: 3, trailing: 0))
                        }
                    }.environment(\.defaultMinListRowHeight, 70)
                        .listStyle(PlainListStyle())
                        .font(.largeTitle)
                }
                
                if lap234Purchase3 == "false"
                {                AdView()
                        .frame(width:700, height: 100)
                    Spacer().frame(height:10)
                }
            }
            .frame(width: 700)
        }.navigationBarTitleDisplayMode(.inline)
            .onAppear {
                screen = UIScreen.main.bounds.size

                let userDefaults = UserDefaults.standard
                if let value2 = userDefaults.string(forKey: "lap234") {
                    print("lap234:\(value2)")
                    lap234Purchase3 = value2
                }
            }
            .onDisappear {
                
                let realm = try! Realm()
                let predicate = NSPredicate(format: "id == %@", id as CVarArg)
                let results = realm.objects(Model.self).filter(predicate).first
                try! realm.write {
                    results?.condition = condition
                }
            }
    }}
