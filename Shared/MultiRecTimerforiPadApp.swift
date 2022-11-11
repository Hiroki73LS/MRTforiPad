import SwiftUI
import SwiftyStoreKit
import UIKit
import FirebaseCore


@main
struct MultiRecTimerforiPadApp: App {
    
    init() {
        
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
            // ... other code here
        }
        
        UITableView.appearance().backgroundColor = .clear
    }
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate  // 追加する
    
    var body: some Scene {
        
        WindowGroup {
            ContentView( total: [], laptime: [], finalLap: [], lapNo: [], lapn: 1, nowTime: 0)
        }
    }
}

class AppDelegate: UIResponder, UIApplicationDelegate{
    
    
    private func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        SwiftyStoreKit.completeTransactions(atomically: true) { products in
            for product in products {
                if product.transaction.transactionState == .purchased || product.transaction.transactionState == .restored {
                    
                    let defaults = UserDefaults.standard
                    defaults.set(true, forKey: "receiptData")
                    defaults.synchronize()
                    
                    if product.needsFinishTransaction {
                        
                        SwiftyStoreKit.finishTransaction(product.transaction)
                    }
                }
            }
        }
        FirebaseApp.configure()
        return true
    }
}

