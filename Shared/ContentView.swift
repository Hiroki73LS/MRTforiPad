import UIKit
import SwiftUI
import RealmSwift
import GoogleMobileAds
import AppTrackingTransparency
import AdSupport
import MediaPlayer
import FirebaseCore

struct AdView: UIViewRepresentable {
    func makeUIView(context: Context) -> GADBannerView {
        let banner = GADBannerView(adSize: GADAdSizeBanner)
        banner.adUnitID = "ca-app-pub-1023155372875273/3230974128"
        
        // 以下は、バナー広告向けのテスト専用広告ユニットIDです。自身の広告ユニットIDと置き換えてください。
        //        banner.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        
        banner.rootViewController = UIApplication.shared.windows.first?.rootViewController
        banner.load(GADRequest())
        return banner
    }
    
    func updateUIView(_ uiView: GADBannerView, context: Context) {
    }
}

class UserProfile: ObservableObject {
    
    /// 振動機能のモード値
    @Published var vibrationmode: Bool {
        didSet {
            UserDefaults.standard.set(vibrationmode, forKey: "vbmode")
        }}
    @Published var level: Int {
        didSet {
            UserDefaults.standard.set(level, forKey: "level")
        }}
    /// 利き手のモード値
    @Published var mode: Bool {
        didSet {
            UserDefaults.standard.set(mode, forKey: "mode")
        }}
    /// 初期化処理
    init() {
        vibrationmode = UserDefaults.standard.object(forKey:  "vbmode") as? Bool ?? true
        level = UserDefaults.standard.object(forKey: "level") as? Int ?? 1
        mode = UserDefaults.standard.object(forKey: "mode") as? Bool ?? true
    }
}

struct ContentView: View {
    let kiroku = 40   //無課金の記録数上限
    let kiroku2 = 90  //課金済みの記録数上限
    let rireki = 30   //無課金の履歴上限数
    let rireki2 = 99  //課金済みの履歴上限数
    
    let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
    let generator = UINotificationFeedbackGenerator()
    
    @State private var lapmode = true
    @State private var jumpTo = "0"
    @State private var isActive = false
    @AppStorage("FirstLaunch") var firstLaunch = true
    @AppStorage("vbmode2") var vbmode2 = true
    
    @State var screen: CGSize?
    @ObservedObject var model = viewModel()
    @ObservedObject var profile = UserProfile()
    @ObservedObject var soundAlert = SoundAlert()
    @ObservedObject var stopWatchManeger = StopWatchManeger()
    @ObservedObject var stopWatchManeger2 = StopWatchManeger2()
    @ObservedObject var stopWatchManeger3 = StopWatchManeger3()
    @State var total : [String]
    @State var laptime : [String]
    @State var finalLap : [String]
    @State var lapNo : [String]
    @State var lapn = 1
    @State var oldMin = 0
    @State var flag = true
    @State var nowTime : Double
    @State var sheetAlert : Bool = false
    @State var sheetAlertRire : Bool = false
    @State var lap234Purchase : String = "false"
        
    var body: some View {
        
        ScrollViewReader { scrollProxy in       // ①ScrollViewProxyインスタンスを取得
            ZStack {
                
                LinearGradient(gradient: Gradient(colors: [Color("akaruiYellow") , .pink.opacity(0.4)]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                
                VStack(spacing:2) {
                    
                    if lap234Purchase == "false"
                    {                AdView()
                            .frame(height: 100)
                    }
                    Text("Total Time").font(.title2)
                    if stopWatchManeger.hour > 9 {
                        Text(String(format: "%02d:%02d:%02d.%02d", stopWatchManeger.hour, stopWatchManeger.minutes, stopWatchManeger.second, stopWatchManeger.milliSecond))
                            .font(Font.custom("HiraginoSans-W3", size: (screen?.width ?? 100) * 0.16))
                            .font(.system(size: 60, design: .monospaced))
                    } else if stopWatchManeger.hour > 0 {
                        Text(String(format: "%01d:%02d:%02d.%02d", stopWatchManeger.hour, stopWatchManeger.minutes, stopWatchManeger.second, stopWatchManeger.milliSecond))
                            .font(Font.custom("HiraginoSans-W3", size: (screen?.width ?? 100) * 0.17))
                            .font(.system(size: 65, design: .monospaced))
                    } else {
                        Text(String(format: "%02d:%02d.%02d", stopWatchManeger.minutes, stopWatchManeger.second, stopWatchManeger.milliSecond))
                            .font(Font.custom("HiraginoSans-W3", size: (screen?.width ?? 100) * 0.21))
                            .font(.system(size: 0, design: .monospaced))
                    }
                    //◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆右利きモード◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆
                    if profile.mode == true{
                        
                        HStack{
                            VStack{
                                
                                Button(action: {
                                    self.lapmode.toggle()
                                }){
                                    VStack{
                                        HStack{
                                            
                                            HStack{
                                                Text("Tap").font(.title3)
                                                Image(systemName: "arrow.triangle.2.circlepath")
                                            }.overlay(
                                                RoundedRectangle(cornerRadius: 5) //cornerRadiusに角の丸み
                                                    .stroke(Color.blue, lineWidth: 1)
                                                //第１引数に枠線の色、第２引数「lineWidth」に枠線の太さ
                                            )
                                            Spacer().frame(width:10)
                                            
                                            if lapmode {
                                                if lapn > 1 {
                                                    Text("\(lapn-1)位との差")
                                                        .font(.title)
                                                } else {
                                                    Text("＿位との差")
                                                        .font(.title)
                                                }} else {
                                                    Text("1位との差")
                                                        .font(.title)
                                                }
                                        }
                                        
                                        if lapmode {
                                            if stopWatchManeger2.hour > 0 {
                                                Text(String(format: "%01d:%02d:%02d.%02d", stopWatchManeger2.hour, stopWatchManeger2.minutes, stopWatchManeger2.second, stopWatchManeger2.milliSecond))
                                                    .font(Font.custom("HiraginoSans-W3", size: (screen?.width ?? 100) * 0.105))
                                                    .font(.system(size: 40, design: .monospaced))
                                            } else {
                                                Text(String(format: "%02d:%02d.%02d", stopWatchManeger2.minutes, stopWatchManeger2.second, stopWatchManeger2.milliSecond))
                                                    .font(Font.custom("HiraginoSans-W3", size: (screen?.width ?? 100) * 0.13))
                                                    .font(.system(size: 50, design: .monospaced))
                                            }} else {
                                                if stopWatchManeger3.hour > 0 {
                                                    Text(String(format: "%01d:%02d:%02d.%02d", stopWatchManeger3.hour, stopWatchManeger3.minutes, stopWatchManeger3.second, stopWatchManeger3.milliSecond))
                                                        .font(Font.custom("HiraginoSans-W3", size: (screen?.width ?? 100) * 0.105))
                                                        .font(.system(size: 40, design: .monospaced))
                                                } else {
                                                    Text(String(format: "%02d:%02d.%02d", stopWatchManeger3.minutes, stopWatchManeger3.second, stopWatchManeger3.milliSecond))
                                                        .font(Font.custom("HiraginoSans-W3", size: (screen?.width ?? 100) * 0.13))
                                                        .font(.system(size: 50, design: .monospaced))
                                                }
                                            }
                                    }
                                }.foregroundColor(Color.black)
                            }
                            Spacer().frame(width: 40)
                            VStack{
                                Button(action: {
                                    self.sheetAlert.toggle()
                                }) {
                                    Image(systemName: "gear")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 40, height: 40)
                                        .foregroundColor(.black)
                                        .padding(5)
                                }.sheet(isPresented: $sheetAlert) {
                                    SecondView(lap234Purchase: Binding(projectedValue: $lap234Purchase))
                                }
                                Text("設定")
                                Spacer().frame(width: 20)
                                Toggle("", isOn: $profile.mode)
                                    .labelsHidden()
                                Text(profile.mode ? "Left mode" : "Right mode")
                            }
                            Spacer().frame(width: 40)
                            if stopWatchManeger.mode == .stop{
                                VStack{
                                    Button(action: {
                                        self.stopWatchManeger.start()
                                        self.stopWatchManeger2.start()
                                        self.soundAlert.start()
                                        if vbmode2 == true{
                                            impactHeavy.impactOccurred() //■■■■■■■■■■■■■■tapticengine feedback■■■■■■■■■■■■■■
                                        }
                                    }){
                                        TextView(label : "スタート")
                                    }
                                    Spacer().frame(height: 20)
                                    Button(action: {
                                        self.sheetAlertRire.toggle()
                                        if vbmode2 == true{
                                            impactHeavy.impactOccurred() //■■■■■■■■■■■■■■tapticengine feedback■■■■■■■■■■■■■■
                                        }
                                    }){
                                        TextView(label : "りれき")
                                    }.sheet(isPresented: $sheetAlertRire) {
                                        Rireki()
                                    }
                                }
                            }
                            if stopWatchManeger.mode == .start{
                                VStack{
                                    Button(action: {
                                        self.stopWatchManeger.pause()
                                        self.stopWatchManeger2.pause()
                                        
                                        if stopWatchManeger3.mode == .start{
                                            self.stopWatchManeger3.pause()
                                        }
                                        
                                        self.soundAlert.pause()
                                        if vbmode2 == true{
                                            impactHeavy.impactOccurred() //■■■■■■■■■■■■■■tapticengine feedback■■■■■■■■■■■■■■
                                        }
                                    }){
                                        TextView(label : "ていし")
                                    }
                                    Spacer().frame(height: 20)
                                    Button(action: {
                                        
                                        if lap234Purchase == "false" {
                                            
                                            if stopWatchManeger3.mode == .stop {
                                                self.stopWatchManeger3.start()
                                            }
                                            
                                            if laptime.count < kiroku {
                                                
                                                if vbmode2 == true{
                                                    impactHeavy.impactOccurred() //■■■■■■■■■■■■■■tapticengine feedback■■■■■■■■■■■■■■
                                                }
                                                
                                                lapNo.insert(String(lapn), at: 0)
                                                if stopWatchManeger.hour > 0 {
                                                    total.insert(String(format: "%01d:%02d:%02d.%02d", stopWatchManeger.hour, stopWatchManeger.minutes, stopWatchManeger.second, stopWatchManeger.milliSecond), at: 0)
                                                } else {
                                                    total.insert(String(format: "%02d:%02d.%02d", stopWatchManeger.minutes, stopWatchManeger.second, stopWatchManeger.milliSecond), at: 0)
                                                }
                                                if stopWatchManeger2.hour > 0 {
                                                    laptime.insert(String(format: "%01d:%02d:%02d.%02d", stopWatchManeger2.hour, stopWatchManeger2.minutes, stopWatchManeger2.second, stopWatchManeger2.milliSecond), at: 0)
                                                } else {
                                                    laptime.insert(String(format: "%02d:%02d.%02d", stopWatchManeger2.minutes, stopWatchManeger2.second, stopWatchManeger2.milliSecond), at: 0)
                                                }
                                                self.stopWatchManeger2.pause()
                                                self.stopWatchManeger2.stop()
                                                self.stopWatchManeger2.start()
                                                lapn += 1
                                                
                                                //　■■■■■ ScrollView用のメソッド　■■■■■
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                                    // 0.5秒後に実行したい処理
                                                    withAnimation {
                                                        /// ③scrollToメソッドで飛び先を指定
                                                        scrollProxy.scrollTo(Int(jumpTo), anchor: UnitPoint(x: 0.5, y: 0.1))
                                                    }}
                                                //　■■■■■ ScrollView用のメソッド　■■■■■
                                                
                                            }
                                        }
                                        if lap234Purchase == "true" {
                                            
                                            if stopWatchManeger3.mode == .stop {
                                                self.stopWatchManeger3.start()
                                            }
                                            
                                            if laptime.count < kiroku2 {
                                                
                                                if vbmode2 == true{
                                                    impactHeavy.impactOccurred() //■■■■■■■■■■■■■■tapticengine feedback■■■■■■■■■■■■■■
                                                }
                                                
                                                lapNo.insert(String(lapn), at: 0)
                                                if stopWatchManeger.hour > 0 {
                                                    total.insert(String(format: "%01d:%02d:%02d.%02d", stopWatchManeger.hour, stopWatchManeger.minutes, stopWatchManeger.second, stopWatchManeger.milliSecond), at: 0)
                                                } else {
                                                    total.insert(String(format: "%02d:%02d.%02d", stopWatchManeger.minutes, stopWatchManeger.second, stopWatchManeger.milliSecond), at: 0)
                                                }
                                                if stopWatchManeger2.hour > 0 {
                                                    laptime.insert(String(format: "%01d:%02d:%02d.%02d", stopWatchManeger2.hour, stopWatchManeger2.minutes, stopWatchManeger2.second, stopWatchManeger2.milliSecond), at: 0)
                                                } else {
                                                    laptime.insert(String(format: "%02d:%02d.%02d", stopWatchManeger2.minutes, stopWatchManeger2.second, stopWatchManeger2.milliSecond), at: 0)
                                                }
                                                self.stopWatchManeger2.pause()
                                                self.stopWatchManeger2.stop()
                                                self.stopWatchManeger2.start()
                                                lapn += 1
                                                
                                                //　■■■■■ ScrollView用のメソッド　■■■■■
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                                    // 0.5秒後に実行したい処理
                                                    withAnimation {
                                                        /// ③scrollToメソッドで飛び先を指定
                                                        scrollProxy.scrollTo(Int(jumpTo), anchor: UnitPoint(x: 0.5, y: 0.1))
                                                    }}
                                                //　■■■■■ ScrollView用のメソッド　■■■■■
                                                
                                            }}
                                    }){
                                        TextView(label : "きろく")
                                    }
                                }
                            }
                            
                            if stopWatchManeger.mode == .pause{
                                VStack{
                                    Button(action: {
                                        self.stopWatchManeger.start()
                                        self.stopWatchManeger2.start()
                                        if stopWatchManeger3.mode == .pause
                                        {
                                            self.stopWatchManeger3.start()
                                        }
                                        self.soundAlert.start()
                                        
                                        if vbmode2 == true{
                                            impactHeavy.impactOccurred() //■■■■■■■■■■■■■■tapticengine feedback■■■■■■■■■■■■■■
                                        }
                                        
                                    }){
                                        TextView(label : "さいかい")
                                    }
                                    Spacer().frame(height: 20)
                                    Button(action: {
                                        if vbmode2 == true{
                                            impactHeavy.impactOccurred() //■■■■■■■■■■■■■■tapticengine feedback■■■■■■■■■■■■■■
                                        }
                                        
                                        //-書き込み---------------------------書き込み---------------------------書き込み--------------------------
                                        
                                        do {
                                            let realm = try Realm()
                                            try realm.write {
                                                let models = Model()
                                                models.condition = false
                                                models.lapsuu = laptime.count
                                                models.kirokuday = Date()
                                                
                                                if stopWatchManeger.hour > 0 {
                                                    models.Rirekitotal = String(format: "%01d:%02d:%02d.%02d", stopWatchManeger.hour, stopWatchManeger.minutes, stopWatchManeger.second, stopWatchManeger.milliSecond)
                                                } else {
                                                    models.Rirekitotal = String(format: "%02d:%02d.%02d", stopWatchManeger.minutes, stopWatchManeger.second, stopWatchManeger.milliSecond)
                                                }
                                                if stopWatchManeger2.hour > 0 {
                                                    models.finalLap = String(format: "%01d:%02d:%02d.%02d", stopWatchManeger2.hour, stopWatchManeger2.minutes, stopWatchManeger2.second, stopWatchManeger2.milliSecond)
                                                } else {
                                                    models.finalLap = String(format: "%02d:%02d.%02d", stopWatchManeger2.minutes, stopWatchManeger2.second, stopWatchManeger2.milliSecond)
                                                }
                                                
                                                //                                                print("laptime:\(laptime)")
                                                //                                                print("models.tickets:\(models.tickets)")
                                                
                                                models.tickets.append(objectsIn: laptime) //Listへの追加処理
                                                models.ticketsTotal.append(objectsIn: total) //Listへの追加処理
                                                realm.add(models) // modelsをRealmデータベースに書き込みます
                                                
                                                //                                                print(models)
                                                
                                                // 読み込み処理 ↓
                                                //                                            let targets = realm.objects(Model.self) // RealmデータベースからModelオブジェクトをすべて取得します
                                                //                                            let target = targets.first { $0.id == models.id } // 取得したModelオブジェクト群から、ほしいものを1つ取り出します
                                                //                                            print(target?.tickets.joined(separator: ", ") ?? "空") // ticketsに格納されたラップタイムを表示します
                                                // 読み込み処理 ↑
                                            }
                                            
                                        } catch {
                                            print(error)
                                        }
                                        
                                        if lap234Purchase == "false" {
                                            do {
                                                let realm = try Realm()
                                                let kazu = realm.objects(Model.self).count
                                                print("\(kazu)")
                                                if kazu > 30 {
                                                    for _ in 30..<kazu {
                                                        try realm.write {
                                                            _ = Model()
                                                            let targets = realm.objects(Model.self)
                                                            let target = targets.first
                                                            realm.delete(target!)
                                                            //                                                            print("i:\(i)")
                                                        }}}
                                            } catch {
                                                print(error)
                                            }} else {
                                                do {
                                                    let realm = try Realm()
                                                    let kazu = realm.objects(Model.self).count
                                                    print("\(kazu)")
                                                    
                                                    if kazu > 99 {
                                                        for i in 99..<kazu {
                                                            try realm.write {
                                                                _ = Model()
                                                                let targets = realm.objects(Model.self)
                                                                let target = targets.first
                                                                realm.delete(target!)
                                                                print("i:\(i)")
                                                            }}}
                                                } catch {
                                                    print(error)
                                                }
                                            }
                                        
                                        //-書き込み---------------------------書き込み---------------------------書き込み--------------------------
                                        total.removeAll()
                                        laptime.removeAll()
                                        lapNo.removeAll()
                                        lapn = 1
                                        soundAlert.oldMin = 0
                                        stopWatchManeger.minutes = 00
                                        stopWatchManeger.second = 00
                                        stopWatchManeger.milliSecond = 00
                                        stopWatchManeger.hour = 00
                                        stopWatchManeger2.minutes = 00
                                        stopWatchManeger2.second = 00
                                        stopWatchManeger2.milliSecond = 00
                                        stopWatchManeger2.hour = 00
                                        stopWatchManeger3.minutes = 00
                                        stopWatchManeger3.second = 00
                                        stopWatchManeger3.milliSecond = 00
                                        stopWatchManeger3.hour = 00
                                        self.stopWatchManeger.stop()
                                        self.stopWatchManeger2.stop()
                                        self.stopWatchManeger3.stop()
                                        self.soundAlert.stop()
                                        
                                    }){
                                        TextView(label : "リセット")
                                    }
                                }
                            }
                        }
                    }
                    //◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆左利きモード◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆
                    if profile.mode == false{
                        
                        HStack{
                            if stopWatchManeger.mode == .stop{
                                VStack{
                                    Button(action: {
                                        self.stopWatchManeger.start()
                                        self.stopWatchManeger2.start()
                                        self.soundAlert.start()
                                        if vbmode2 == true{
                                            impactHeavy.impactOccurred() //■■■■■■■■■■■■■■tapticengine feedback■■■■■■■■■■■■■■
                                        }
                                    }){
                                        TextView(label : "スタート")
                                    }
                                    Spacer().frame(height: 20)
                                    Button(action: {
                                        self.sheetAlertRire.toggle()
                                        if vbmode2 == true{
                                            impactHeavy.impactOccurred() //■■■■■■■■■■■■■■tapticengine feedback■■■■■■■■■■■■■■
                                        }
                                    }){
                                        TextView(label : "りれき")
                                    }.sheet(isPresented: $sheetAlertRire) {
                                        Rireki()
                                    }
                                }
                            }
                            
                            if stopWatchManeger.mode == .start{
                                VStack{
                                    Button(action: {
                                        self.stopWatchManeger.pause()
                                        self.stopWatchManeger2.pause()
                                        
                                        if stopWatchManeger3.mode == .start{
                                            self.stopWatchManeger3.pause()
                                        }
                                        
                                        self.soundAlert.pause()
                                        
                                        if vbmode2 == true{
                                            impactHeavy.impactOccurred() //■■■■■■■■■■■■■■tapticengine feedback■■■■■■■■■■■■■■
                                        }
                                        
                                    }){
                                        TextView(label : "ていし")
                                    }
                                    Spacer().frame(height: 20)
                                    Button(action: {
                                        
                                        if lap234Purchase == "false" {
                                            
                                            if stopWatchManeger3.mode == .stop {
                                                self.stopWatchManeger3.start()
                                            }
                                            
                                            if laptime.count < kiroku {
                                                
                                                if vbmode2 == true{
                                                    impactHeavy.impactOccurred() //■■■■■■■■■■■■■■tapticengine feedback■■■■■■■■■■■■■■
                                                }
                                                
                                                lapNo.insert(String(lapn), at: 0)
                                                if stopWatchManeger.hour > 0 {
                                                    total.insert(String(format: "%01d:%02d:%02d.%02d", stopWatchManeger.hour, stopWatchManeger.minutes, stopWatchManeger.second, stopWatchManeger.milliSecond), at: 0)
                                                } else {
                                                    total.insert(String(format: "%02d:%02d.%02d", stopWatchManeger.minutes, stopWatchManeger.second, stopWatchManeger.milliSecond), at: 0)
                                                }
                                                if stopWatchManeger2.hour > 0 {
                                                    laptime.insert(String(format: "%01d:%02d:%02d.%02d", stopWatchManeger2.hour, stopWatchManeger2.minutes, stopWatchManeger2.second, stopWatchManeger2.milliSecond), at: 0)
                                                } else {
                                                    laptime.insert(String(format: "%02d:%02d.%02d", stopWatchManeger2.minutes, stopWatchManeger2.second, stopWatchManeger2.milliSecond), at: 0)
                                                }
                                                self.stopWatchManeger2.pause()
                                                self.stopWatchManeger2.stop()
                                                self.stopWatchManeger2.start()
                                                lapn += 1
                                                //　■■■■■ ScrollView用のメソッド　■■■■■
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                                    // 0.5秒後に実行したい処理
                                                    withAnimation {
                                                        /// ③scrollToメソッドで飛び先を指定
                                                        scrollProxy.scrollTo(Int(jumpTo), anchor: UnitPoint(x: 0.5, y: 0.1))
                                                    }}
                                                //　■■■■■ ScrollView用のメソッド　■■■■■
                                            }
                                        }
                                        if lap234Purchase == "true" {
                                            
                                            if stopWatchManeger3.mode == .stop {
                                                self.stopWatchManeger3.start()
                                            }
                                            
                                            if laptime.count < kiroku2 {
                                                
                                                if vbmode2 == true{
                                                    impactHeavy.impactOccurred() //■■■■■■■■■■■■■■tapticengine feedback■■■■■■■■■■■■■■
                                                }
                                                
                                                lapNo.insert(String(lapn), at: 0)
                                                if stopWatchManeger.hour > 0 {
                                                    total.insert(String(format: "%01d:%02d:%02d.%02d", stopWatchManeger.hour, stopWatchManeger.minutes, stopWatchManeger.second, stopWatchManeger.milliSecond), at: 0)
                                                } else {
                                                    total.insert(String(format: "%02d:%02d.%02d", stopWatchManeger.minutes, stopWatchManeger.second, stopWatchManeger.milliSecond), at: 0)
                                                }
                                                if stopWatchManeger2.hour > 0 {
                                                    laptime.insert(String(format: "%01d:%02d:%02d.%02d", stopWatchManeger2.hour, stopWatchManeger2.minutes, stopWatchManeger2.second, stopWatchManeger2.milliSecond), at: 0)
                                                } else {
                                                    laptime.insert(String(format: "%02d:%02d.%02d", stopWatchManeger2.minutes, stopWatchManeger2.second, stopWatchManeger2.milliSecond), at: 0)
                                                }
                                                self.stopWatchManeger2.pause()
                                                self.stopWatchManeger2.stop()
                                                self.stopWatchManeger2.start()
                                                lapn += 1
                                                //　■■■■■ ScrollView用のメソッド　■■■■■
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                                    // 0.5秒後に実行したい処理
                                                    withAnimation {
                                                        /// ③scrollToメソッドで飛び先を指定
                                                        scrollProxy.scrollTo(Int(jumpTo), anchor: UnitPoint(x: 0.5, y: 0.1))
                                                    }}
                                                //　■■■■■ ScrollView用のメソッド　■■■■■
                                            }}
                                    }){
                                        TextView(label : "きろく")
                                    }
                                }
                            }
                            
                            if stopWatchManeger.mode == .pause{
                                VStack{
                                    Button(action: {
                                        self.stopWatchManeger.start()
                                        self.stopWatchManeger2.start()
                                        
                                        if stopWatchManeger3.mode == .pause
                                        {
                                            self.stopWatchManeger3.start()
                                        }
                                        
                                        self.soundAlert.start()
                                        
                                        if vbmode2 == true{
                                            impactHeavy.impactOccurred() //■■■■■■■■■■■■■■tapticengine feedback■■■■■■■■■■■■■■
                                        }
                                        
                                    }){
                                        TextView(label : "さいかい")
                                    }
                                    Spacer().frame(height: 20)
                                    Button(action: {
                                        
                                        if vbmode2 == true{
                                            impactHeavy.impactOccurred() //■■■■■■■■■■■■■■tapticengine feedback■■■■■■■■■■■■■■
                                        }
                                        
                                        //-書き込み---------------------------書き込み---------------------------書き込み--------------------------
                                        
                                        do {
                                            let realm = try Realm()
                                            try realm.write {
                                                let models = Model()
                                                models.condition = false
                                                models.lapsuu = laptime.count
                                                models.kirokuday = Date()
                                                
                                                if stopWatchManeger.hour > 0 {
                                                    models.Rirekitotal = String(format: "%01d:%02d:%02d.%02d", stopWatchManeger.hour, stopWatchManeger.minutes, stopWatchManeger.second, stopWatchManeger.milliSecond)
                                                } else {
                                                    models.Rirekitotal = String(format: "%02d:%02d.%02d", stopWatchManeger.minutes, stopWatchManeger.second, stopWatchManeger.milliSecond)
                                                }
                                                if stopWatchManeger2.hour > 0 {
                                                    models.finalLap = String(format: "%01d:%02d:%02d.%02d", stopWatchManeger2.hour, stopWatchManeger2.minutes, stopWatchManeger2.second, stopWatchManeger2.milliSecond)
                                                } else {
                                                    models.finalLap = String(format: "%02d:%02d.%02d", stopWatchManeger2.minutes, stopWatchManeger2.second, stopWatchManeger2.milliSecond)
                                                }
                                                
                                                
                                                print("laptime:\(laptime)")
                                                print("models.tickets:\(models.tickets)")
                                                
                                                models.tickets.append(objectsIn: laptime) //Listへの追加処理
                                                models.ticketsTotal.append(objectsIn: total) //Listへの追加処理
                                                realm.add(models) // modelsをRealmデータベースに書き込みます
                                                
                                                print(models)
                                                
                                                // 読み込み処理 ↓
                                                //                                            let targets = realm.objects(Model.self) // RealmデータベースからModelオブジェクトをすべて取得します
                                                //                                            let target = targets.first { $0.id == models.id } // 取得したModelオブジェクト群から、ほしいものを1つ取り出します
                                                //                                            print(target?.tickets.joined(separator: ", ") ?? "空") // ticketsに格納されたラップタイムを表示します
                                                // 読み込み処理 ↑
                                            }
                                            
                                        } catch {
                                            print(error)
                                        }
                                        
                                        if lap234Purchase == "false" {
                                            do {
                                                let realm = try Realm()
                                                let kazu = realm.objects(Model.self).count
                                                print("\(kazu)")
                                                if kazu > rireki {
                                                    for i in rireki..<kazu {
                                                        try realm.write {
                                                            _ = Model()
                                                            let targets = realm.objects(Model.self)
                                                            let target = targets.first
                                                            realm.delete(target!)
                                                            print("i:\(i)")
                                                        }}}
                                            } catch {
                                                print(error)
                                            }} else {
                                                do {
                                                    let realm = try Realm()
                                                    let kazu = realm.objects(Model.self).count
                                                    print("\(kazu)")
                                                    
                                                    if kazu > rireki2 {
                                                        for i in rireki2..<kazu {
                                                            try realm.write {
                                                                _ = Model()
                                                                let targets = realm.objects(Model.self)
                                                                let target = targets.first
                                                                realm.delete(target!)
                                                                print("i:\(i)")
                                                            }}}
                                                } catch {
                                                    print(error)
                                                }
                                            }
                                        
                                        
                                        //-書き込み---------------------------書き込み---------------------------書き込み--------------------------
                                        total.removeAll()
                                        laptime.removeAll()
                                        lapNo.removeAll()
                                        lapn = 1
                                        soundAlert.oldMin = 0
                                        stopWatchManeger.minutes = 00
                                        stopWatchManeger.second = 00
                                        stopWatchManeger.milliSecond = 00
                                        stopWatchManeger.hour = 00
                                        stopWatchManeger2.minutes = 00
                                        stopWatchManeger2.second = 00
                                        stopWatchManeger2.milliSecond = 00
                                        stopWatchManeger2.hour = 00
                                        stopWatchManeger3.minutes = 00
                                        stopWatchManeger3.second = 00
                                        stopWatchManeger3.milliSecond = 00
                                        stopWatchManeger3.hour = 00
                                        self.stopWatchManeger.stop()
                                        self.stopWatchManeger2.stop()
                                        self.stopWatchManeger3.stop()
                                        self.soundAlert.stop()
                                        
                                    }){
                                        TextView(label : "リセット")
                                    }
                                }
                            }
                            Spacer().frame(width: 40)
                            VStack{
                                Button(action: {
                                    self.sheetAlert.toggle()
                                }) {
                                    Image(systemName: "gear")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 40, height: 40)
                                        .foregroundColor(.black)
                                        .padding(5)
                                }.sheet(isPresented: $sheetAlert) {
                                    SecondView(lap234Purchase: Binding(projectedValue: $lap234Purchase))
                                }
                                Text("設定")
                                Spacer().frame(width: 20)
                                Toggle("", isOn: $profile.mode)
                                    .labelsHidden()
                                Text(profile.mode ? "Left mode" : "Right mode")
                            }
                            Spacer().frame(width: 40)
                            VStack{
                                
                                Button(action: {
                                    self.lapmode.toggle()
                                }){
                                    VStack{
                                        HStack{
                                            HStack{
                                                Text("Tap").font(.title3)
                                                Image(systemName: "arrow.triangle.2.circlepath")
                                            }.overlay(
                                                RoundedRectangle(cornerRadius: 5) //cornerRadiusに角の丸み
                                                    .stroke(Color.blue, lineWidth: 1)
                                                //第１引数に枠線の色、第２引数「lineWidth」に枠線の太さ
                                            )
                                            Spacer().frame(width:10)
                                            if lapmode {
                                                if lapn > 1 {
                                                    Text("\(lapn-1)位との差")
                                                        .font(.title)
                                                } else {
                                                    Text("＿位との差")
                                                        .font(.title)
                                                }} else {
                                                    Text("1位との差")
                                                        .font(.title)
                                                }
                                            
                                        }
                                        if lapmode {
                                            if stopWatchManeger2.hour > 0 {
                                                Text(String(format: "%01d:%02d:%02d.%02d", stopWatchManeger2.hour, stopWatchManeger2.minutes, stopWatchManeger2.second, stopWatchManeger2.milliSecond))
                                                    .font(Font.custom("HiraginoSans-W3", size: (screen?.width ?? 100) * 0.105))
                                                    .font(.system(size: 40, design: .monospaced))
                                            } else {
                                                Text(String(format: "%02d:%02d.%02d", stopWatchManeger2.minutes, stopWatchManeger2.second, stopWatchManeger2.milliSecond))
                                                    .font(Font.custom("HiraginoSans-W3", size: (screen?.width ?? 100) * 0.13))
                                                    .font(.system(size: 50, design: .monospaced))
                                            }} else {
                                                if stopWatchManeger3.hour > 0 {
                                                    Text(String(format: "%01d:%02d:%02d.%02d", stopWatchManeger3.hour, stopWatchManeger3.minutes, stopWatchManeger3.second, stopWatchManeger3.milliSecond))
                                                        .font(Font.custom("HiraginoSans-W3", size: (screen?.width ?? 100) * 0.105))
                                                        .font(.system(size: 40, design: .monospaced))
                                                } else {
                                                    Text(String(format: "%02d:%02d.%02d", stopWatchManeger3.minutes, stopWatchManeger3.second, stopWatchManeger3.milliSecond))
                                                        .font(Font.custom("HiraginoSans-W3", size: (screen?.width ?? 100) * 0.13))
                                                        .font(.system(size: 50, design: .monospaced))
                                                }
                                            }
                                    }}.foregroundColor(Color.black)
                            }
                        }
                    }
                    //◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆ラップタイム表示◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆
                    HStack{
                        Spacer().frame(width: 30)
                        Text("順位").font(.title2).bold()
                        Spacer()
                        Text("測定タイム").font(.title2).bold()
                        Spacer()
                        Text("１つ前との差 ").font(.title2).bold()
                        Spacer().frame(width: 75)
                    }
                    if stopWatchManeger.hour > 0 {
                        List {
                            ForEach((0 ..< laptime.count).reversed(), id: \.self) { index in
                                HStack(spacing:2){
                                    Spacer().frame(width: 20)
                                    VStack{
                                        Text("No.")
                                            .font(.system(size: 30, design: .monospaced))
                                        Text(lapNo[index])
                                            .font(.system(size: 45, design: .monospaced))
                                    }
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 5)
                                            .stroke(Color.black, lineWidth: 1)
                                    )
                                    Spacer()
                                    Text(total[index])
                                        .font(Font.custom("HiraginoSans-W3", size: (screen?.width ?? 100) * 0.1))
                                    //                                    .font(Font.custom("HiraginoSans-W3", size: 38))
                                        .font(.system(size: 40, design: .monospaced))
                                    Spacer()
                                    Text("\(laptime[index])")
                                        .font(Font.custom("HiraginoSans-W3", size: (screen?.width ?? 100) * 0.053))
                                    //                                    .font(Font.custom("HiraginoSans-W3", size: 20))
                                        .font(.system(size: 20, design: .monospaced))
                                }.id(index) //　■■■■■■■　ScroolView用のid　■■■■■■■
                                    .listRowInsets(EdgeInsets())
                                    .listRowBackground(Color("ColorOrange3"))
                                //                            .listRowBackground(Color.clear)
                                    .listRowInsets(EdgeInsets(top: 3, leading: 0, bottom: 3, trailing: 0))
                            }
                        }                .environment(\.defaultMinListRowHeight, 70)
                            .listStyle(PlainListStyle())
                            .font(.largeTitle)
                    } else {
                        VStack {
                            List {
                                ForEach((0 ..< laptime.count).reversed(), id: \.self) { index in
                                    HStack(spacing:2){
                                        Spacer().frame(width: 20)
                                        VStack{
                                            Text("No.")
                                                .font(.system(size: 30, design: .monospaced))
                                            Text(lapNo[index])
                                                .font(.system(size: 45, design: .monospaced))
                                        }
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 5)
                                                .stroke(Color.black, lineWidth: 1)
                                        )
                                        Spacer()
                                        Text(total[index])
                                            .font(Font.custom("HiraginoSans-W3", size: (screen?.width ?? 100) * 0.135))
                                        //                                    .font(Font.custom("HiraginoSans-W3", size: 50))
                                            .font(.system(size: 50, design: .monospaced))
                                        Spacer()
                                        Text("\(laptime[index])")
                                            .font(Font.custom("HiraginoSans-W3", size: (screen?.width ?? 100) * 0.053))
                                        //                                    .font(Font.custom("HiraginoSans-W3", size: 20))
                                            .font(.system(size: 20, design: .monospaced))
                                    }.id(index) //　■■■■■■■　ScroolView用のid　■■■■■■■
                                        .listRowInsets(EdgeInsets())
                                        .listRowBackground(Color("ColorOrange3"))
                                        .listRowInsets(EdgeInsets(top: 3, leading: 0, bottom: 3, trailing: 0))
                                }
                            }   .environment(\.defaultMinListRowHeight, 70)
                                .listStyle(PlainListStyle())
                                .font(.largeTitle)
                        }
                    }
                }
            }
            .fullScreenCover(isPresented: self.$isActive){
                FirstLaunch(isAActive: $isActive, firstLaunch2: $firstLaunch)
                    .onDisappear{
                       ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                            GADMobileAds.sharedInstance().start(completionHandler: nil)
                        })
                        
                    }
            }}
        .onAppear {
            
            print("onAppear")
            if firstLaunch {
                isActive = true
            }
            screen = UIScreen.main.bounds.size
            let userDefaults = UserDefaults.standard
            if let value2 = userDefaults.string(forKey: "lap234") {
                print("lap234:\(value2)")
                lap234Purchase = value2
            }
        }
        .onChange(of: profile.mode) { mode in
            UserDefaults.standard.set(profile.mode , forKey: "mode")
        }
        .navigationBarTitle("", displayMode: .inline)
    }
}

