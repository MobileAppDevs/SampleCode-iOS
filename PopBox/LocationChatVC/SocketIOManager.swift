

import UIKit
import SocketIO

//class SocketIOManager: NSObject {
//    static let sharedInstance = SocketIOManager()
//    
//    let manager = SocketManager(socketURL: URL(string: "http://notosolutions.net:1337/")!, config: [.log(true), .forcePolling(true)])
//    var socket : SocketIOClient! //= SocketManager(socketURL: URL(string: "http://notosolutions.net:1337/")!, config: [.log(true), .forcePolling(true)]).defaultSocket
//
//    override init() {
//        super.init()
//        
//    }
//
//
//    func establishConnection() {
//
//        socket = manager.defaultSocket
//        
//        socket.on(clientEvent: .connect) {data, ack in
//            print("socket connected")
//        }
//        
//        socket.on("currentAmount") {data, ack in
//            guard let cur = data[0] as? Double else { return }
//            self.socket.emitWithAck("canUpdate", cur).timingOut(after: 0) {data in
//                self.socket.emit("update", ["amount": cur + 2.50])
//            }
//            ack.with("Got your currentAmount", "dude")
//        }
//        
//        socket.connect()
//       // socket.connect()
//    }
//    func socketConnected()-> Bool
//    {
//        return true
//    }
//    func sendMessage(event : String , message : String)
//    {
//       // if(socket != nil)
//       // {
//            socket.emit(event, with: [message])
//       // }
//    }
//    func getMessage(completionHandler: @escaping (_ messageInfo: [String: AnyObject]) -> Void)
//    {
//       // if(socket != nil)
//       // {
//            socket.on("send") { (dataArray, socketAck) -> Void in
//                //var messageDictionary = [String: AnyObject]()
//                for dict in dataArray
//                {
//                    let dictdata : NSDictionary = dict as! NSDictionary
//                    NSLog("dictdata --\(dictdata)")
//                    if let message = dictdata["message"] as? [String :Any]
//                    {
//                        completionHandler(message as [String : AnyObject])
//                    }
//                }
//                
//            }
//       // }
//    }
//    func closeConnection() {
//        socket.disconnect()
//    }
//    
//}


