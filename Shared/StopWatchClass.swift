import SwiftUI
import AVFoundation


class StopWatchManeger:ObservableObject{

    enum stopWatchMode{
        case start
        case stop
        case pause
    }
    
    @Published var mode:stopWatchMode = .stop
    @Published var milliSecond = 00
    @Published var second = 00
    @Published var minutes = 00
    @Published var hour = 0

    var nowTime : Double = 0
    var elapsedTime : Double = 0
    var displayTime: Double = 0
    var savedTime: Double = 0
    var timer = Timer()
    static var Min = 0
    
    func start(){
        mode = .start
        
        print("stopwatch start")
        
        self.nowTime = NSDate.timeIntervalSinceReferenceDate
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true){ timer in
            
            self.elapsedTime = NSDate.timeIntervalSinceReferenceDate
//            self.displayTime = ((self.elapsedTime + self.savedTime) - self.nowTime) * 3
//            self.displayTime = ((self.elapsedTime + self.savedTime) - self.nowTime) * 600
            self.displayTime = (self.elapsedTime + self.savedTime) - self.nowTime
            
            // ミリ秒は小数点第一位、第二位なので100をかけて100で割った余り
            self.milliSecond = Int(self.displayTime * 100) % 100
            // 秒は1・2桁なので60で割った余り
            self.second = Int(self.displayTime) % 60
            // 分は経過秒を60で割った商を60で割った余り
            self.minutes = Int(self.displayTime / 60) % 60
            // 時は経過分を60で割った商を60で割る
            self.hour = Int(self.displayTime / 60) / 60
            
            StopWatchManeger.Min = self.minutes

        }
        RunLoop.current.add(timer, forMode: .common)
    }
    
    func stop(){
        timer.invalidate()
        elapsedTime = 0
        savedTime = 0
        mode = .stop
    }
    
    func pause(){
        timer.invalidate()
        savedTime = displayTime
        mode = .pause
    }
    
    
    
    
    
    
}
//------------------------------------------------------------------------------------------------------------------------
class StopWatchManeger2:ObservableObject{
    
    enum stopWatchMode{
        case start
        case stop
        case pause
    }
    
    @Published var mode:stopWatchMode = .stop
    @Published var milliSecond = 00
    @Published var second = 00
    @Published var minutes = 00
    @Published var hour = 0
    var nowTime : Double = 0
    var elapsedTime : Double = 0
    var displayTime: Double = 0
    var savedTime: Double = 0
    var timer = Timer()
    
    func start(){
        mode = .start
        
        self.nowTime = NSDate.timeIntervalSinceReferenceDate
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true){ timer in
            
            self.elapsedTime = NSDate.timeIntervalSinceReferenceDate
//            self.displayTime = ((self.elapsedTime + self.savedTime) - self.nowTime) * 600
            self.displayTime = (self.elapsedTime + self.savedTime) - self.nowTime
            
            // ミリ秒は小数点第一位、第二位なので100をかけて100で割った余り
            self.milliSecond = Int(self.displayTime * 100) % 100
            
            // 秒は1・2桁なので60で割った余り
            self.second = Int(self.displayTime) % 60
            
            // 分は経過秒を60で割った商を60で割った余り
            self.minutes = Int(self.displayTime / 60) % 60
            
            // 時は経過分を60で割った商を60で割る
            self.hour = Int(self.displayTime / 60) / 60
        }
        RunLoop.current.add(timer, forMode: .common)
    }
    
    func stop(){
        timer.invalidate()
        elapsedTime = 0
        savedTime = 0
        mode = .stop
    }
    
    func pause(){
        timer.invalidate()
        savedTime = displayTime
        mode = .pause
    }
}
//------------------------------------------------------------------------------------------------------------------------
class StopWatchManeger3:ObservableObject{
    
    enum stopWatchMode{
        case start
        case stop
        case pause
    }
    
    @Published var mode:stopWatchMode = .stop
    @Published var milliSecond = 00
    @Published var second = 00
    @Published var minutes = 00
    @Published var hour = 0
    var nowTime : Double = 0
    var elapsedTime : Double = 0
    var displayTime: Double = 0
    var savedTime: Double = 0
    var timer = Timer()
    
    func start(){
        mode = .start
        
        self.nowTime = NSDate.timeIntervalSinceReferenceDate
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true){ timer in
            
            self.elapsedTime = NSDate.timeIntervalSinceReferenceDate
//            self.displayTime = ((self.elapsedTime + self.savedTime) - self.nowTime) * 600
            self.displayTime = (self.elapsedTime + self.savedTime) - self.nowTime
            
            // ミリ秒は小数点第一位、第二位なので100をかけて100で割った余り
            self.milliSecond = Int(self.displayTime * 100) % 100
            
            // 秒は1・2桁なので60で割った余り
            self.second = Int(self.displayTime) % 60
            
            // 分は経過秒を60で割った商を60で割った余り
            self.minutes = Int(self.displayTime / 60) % 60
            
            // 時は経過分を60で割った商を60で割る
            self.hour = Int(self.displayTime / 60) / 60
        }
        RunLoop.current.add(timer, forMode: .common)
    }
    
    func stop(){
        timer.invalidate()
        elapsedTime = 0
        savedTime = 0
        mode = .stop
    }
    
    func pause(){
        timer.invalidate()
        savedTime = displayTime
        mode = .pause
    }
}
