//
//  showDataController.swift
//  StepSense_V1
//
//  Created by Ajit Ravisaravanan on 11/12/19.
//  Copyright © 2019 Ajit Ravisaravanan. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import CoreBluetooth


var db = Firestore.firestore()
var ref: DocumentReference? = nil

class showDataController: UIViewController {
    
    @IBOutlet weak var stepsCount: UILabel!
    
    var ref2: DatabaseReference! = Database.database().reference()

    var connectedToDevice = true
    
//    BLUETOOTH VAR INITS - WIP
//    let sensorTagName = "RPIZeroW"
//    var dataToSubmit: DocumentReference? = nil
//    var centralManager:CBCentralManager?
//    var peripheralPi: CBPeriphera
//    let BLE_Pi_Service_CBUUID = CBUUID(string: "0x180D")
//    let BLE_PI_Step_Measurement_Characteristic_CBUUID = CBUUID(string: "0x2A37")
//    let BLE_PI_Pressure_Characteristic_CBUUID = CBUUID(string: "0x2A38")
    
    var number_of_steps: Int = 0 {
        didSet {
            self.stepsCount.text = "\(number_of_steps)"
        }
    }
    
    @IBOutlet weak var gradientView: GradientView!
    @IBOutlet weak var gradientView1: GradientView!
    @IBOutlet weak var gradientView2: GradientView!
    @IBOutlet weak var gradientView3: GradientView!
    @IBOutlet weak var gradientView4: GradientView!
    @IBOutlet weak var shoeView: UIImageView!
    
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var refreshButton: UIButton!
    
    
    @IBAction func refreshButton(_ sender: Any) {
        refreshData()
    }
    
    var mapped_data: [String:Int] = [:]
    var true_data: [Int] = []
    var prev_data: [Int] = [0,0,0,0,0,0,0,0]
    var press_string: String = ""
    var index_steps : Int = 1
    
    var data_arr: [String:[Double]] = [
//      "level of pressure" : [coordinates]
        "0": [0.0, 0.0],
        "1": [0.1, 0.1],
        "2": [0.2, 0.2],
        "3": [0.3, 0.3],
        "4": [0.4, 0.4],
        "5": [0.5, 0.5],
        "6": [0.6, 0.6],
        "7": [0.7, 0.7],
        "8": [0.8, 0.8],
        "9": [0.9, 0.9]
    ]
    
    var colors_arr: [Int:UIColor] = [
        0: .green,
        1: .green,
        2: .magenta,
        3: .magenta,
        4: .systemPink,
        5: .purple,
        6: .purple,
        7: .purple,
        8: .blue,
        9: .blue,
        10: .black,
        11: .white,
        12: .yellow,
        13: .yellow,
        14: .orange,
        15: .orange,
        16: .red,
        17: .red,
        18: .red,
        19: .red
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
//        loadGradients()
        self.view.bringSubviewToFront(shoeView)
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
//            self.incrementSteps(5)
//        }
        //let centralQueue: DispatchQueue = DispatchQueue(label: "centralQueue", attributes: .concurrent)
        //centralManager = CBCentralManager(delegate: self, queue: centralQueue, options: nil)
        //var ref2 = Database.database().reference()
    }
    
    func incrementSteps(_ incrementAmount: Int) {
        number_of_steps += incrementAmount
    }
    
    func loadGradients(_ arr: [Int]) {
        print("LOAD GRADIENTS")
        showData(gradientView, colors_arr[arr[0]]!, colors_arr[arr[1]]!)
        showData(gradientView1, colors_arr[arr[1]]!, colors_arr[arr[2]]!)
        showData(gradientView2, colors_arr[arr[2]]!, colors_arr[arr[3]]!)
        showData(gradientView3, colors_arr[arr[3]]!, colors_arr[arr[4]]!)
        showData(gradientView4, colors_arr[arr[4]]!, colors_arr[arr[5]]!)
    }
    
    func showData(_ gv: GradientView,_ firstColor: UIColor,_ secondColor: UIColor){
        gv.firstColor = firstColor
        gv.secondColor = secondColor
        gv.start = CGPoint(x: 0.5, y: 0)
        gv.end = CGPoint(x: 0.5, y: 1)
    }
    
//    func getFirePressData(completion: @escaping([Int]?) -> Void){
//        var p_string : [Int] = []
//        _ = (ref2.child("presstest/pressureDataTest2/press").observe(.value) { snapshot in
//            for press_sheet in snapshot.children {
//                guard let press_val = press_sheet as? DataSnapshot else{
//                    print("No Pressure Data")
//                    completion(nil)
//                    return
//                }
//                p_string.append(press_val.value as! Int)
//                print(press_val.value ?? 9)
//            }
//            self.true_data = p_string
//            completion(p_string)
//        })
//    }
    
    func getMappedFirePressData(completion: @escaping([String:Int]?) -> Void){
        print("GET PRESSURES")
        var p_string : [String:Int] = [:]
        _ = (ref2.child("presstest/pressureDataTest2/press").observe(.value) { snapshot in
            for press_sheet in snapshot.children {
                guard let press_val = press_sheet as? DataSnapshot else{
                    print("No Pressure Data")
                    completion(nil)
                    return
                }
                p_string[press_val.key] = press_val.value as? Int
            }
            self.mapped_data = p_string
            completion(p_string)
        })
    }
    
    
    func getStepsDatafromDB(completion: @escaping(Int?) -> Void){
        print("GET STEPS")
        var index_step : Int = 1
        _ = (ref2.child("steptest/step").observe(.value) { snapshot in
            for i in snapshot.children {
                guard let press_val = i as? DataSnapshot else{
                    print("No Step Data")
                    completion(nil)
                    return
                }
                index_step = press_val.value as! Int
                print(press_val.value ?? 10)
            }
            self.index_steps = index_step
            completion(index_step)
        })
    }
    
    func normalizeData(arr:[Int]) -> [Int]{
        var result : [Int] = arr
        if(result[5] != 0){
            result[3] = result[3] + result[5]
        }
        if(result[6] != 0){
            result[4] = result[4] + result[6]
        }
        if(result[7] != 0){
            result[5] = result[5] + result[7]
        }
        return result
    }
    
    func convertMap2Ints(arr:[String:Int]) -> [Int]{
        var result : [Int] = [0,0,0,0,0,0,0,0]
        //var test :[String:Int] = arr
        print("CONVERSION")
        //print(test["one"] ?? 50)
        result[0] = arr["one"] ?? 0
        result[1] = arr["two"] ?? 0
        result[2] = arr["three"] ?? 0
        result[3] = arr["four"] ?? 0
        result[4] = arr["five"] ?? 0
        result[5] = arr["six"] ?? 0
        result[6] = arr["seven"] ?? 0
        result[7] = arr["eight"] ?? 0
        return result
    }
    
    func refreshData() {
        //connectedToDevice = true
        if(connectedToDevice == true){
            print("DATA BEFORE LOAD")
            //let intData : [Int] = getFirePressData()
            var stepData : Int!
            getStepsDatafromDB { (i) in
                stepData = i
                self.number_of_steps = stepData
            }
            print(stepData ?? 1)
            var pressureData : [Int]!
            
            
            
            var pressureMap : [String:Int]!
            getMappedFirePressData { (i) in
                pressureMap = i ?? ["0":1]
                print(pressureMap["one"] ?? 22)
                pressureData = self.convertMap2Ints(arr:pressureMap)
                self.true_data = self.normalizeData(arr:pressureData)
                print(self.true_data)
                self.loadGradients(self.true_data)
            }
            
            //            getFirePressData { (i) in
            //                pressureData = i
            //                self.prev_data = self.true_data
            //                self.true_data = pressureData
            //                self.true_data = self.normalizeData(arr:pressureData)
            //                self.loadGradients(self.true_data)
            //            }
            //            print(pressureData ?? prev_data)
            
        }
        else{
            number_of_steps = getStepsData()
            let random_pressure_data = getRandPressureData()
            loadGradients(random_pressure_data)
        }
    }
    
    func getStepsData() -> Int {
        return Int.random(in: 0...100)
    }
    
    func getRandPressureData() -> [Int] {
        var arr : [Int] = []
        for _ in 0...9 {
            arr.append(Int.random(in: 0...9))
        }
        loadGradients(arr)
        return arr
    }
    
    @IBAction func submitResults(_ sender: Any) {
        //change to data from sensor when Bluetooth works
        if connectedToDevice == false{
            let dataToSubmit = getRandPressureData()
            let stepsToSubmit = number_of_steps
            saveResults(pressureData: dataToSubmit, steps:stepsToSubmit)
        }
        if connectedToDevice == true{
            let dataToSubmit = true_data
            let stepsToSubmit = number_of_steps
            saveResults(pressureData: dataToSubmit, steps:stepsToSubmit)
        }
     }
    
    func saveResults(pressureData:[Int], steps: Int){
        _ = db.collection("submitTestPresData").addDocument(data: [
            "pressure1": pressureData[0],
            "pressure2": pressureData[1],
            "pressure3": pressureData[2],
            "pressure4": pressureData[3],
            "pressure5": pressureData[4],
            "pressure6": pressureData[5],
            "pressure7": pressureData[6],
            "pressure8": pressureData[7],
                "steps": steps
            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added")
                    //print("Document added with ID: \(ref!.documentID)")
                }
            }
    }
     
}


// BLUETOOTH CENTRAL AND PERIPHERAL FOR iOS
// NEEDS SUCCESFULL ADVERTISEMENT ON RPI SIDE TO BE FUNCTIONAL

//extension showDataController: CBCentralManagerDelegate, CBPeripheralManagerDelegate, CBPeripheralDelegate {
//    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
//    }
//
//    func centralManagerDidUpdateState(_ central: CBCentralManager) {
//        if central.state == .poweredOn {
//            print("Bluetooth is On")
//            //centralManager?.scanForPeripherals(withServices: [BLE_Pi_Service_CBUUID], options: nil)
//            centralManager?.scanForPeripherals(withServices: nil, options: nil)
//        } else {
//            print("Bluetooth is not active")
//        }
//    }
//
//    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
//        peripheralPi = peripheral
//        peripheralPi?.delegate = self as CBPeripheralDelegate
//        central.stopScan()
//        central.connect(peripheral)
//        print("\nName   : \(peripheral.name ?? "(No name)")")
//        print("RSSI   : \(RSSI)")
//        for ad in advertisementData {
//            print("AD Data: \(ad)")
//        }
//    }
//
//    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
//        DispatchQueue.main.async { () -> Void in
//            self.connectedToDevice = true
//        }
//        peripheralPi?.discoverServices([BLE_Pi_Service_CBUUID])
//        peripheralPi?.delegate = self as CBPeripheralDelegate
//
//    }
//    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
//        print("Disconnected!")
//        DispatchQueue.main.async { () -> Void in
//            self.connectedToDevice = false
//        }
//        centralManager?.scanForPeripherals(withServices: [BLE_Pi_Service_CBUUID], options: nil)
//       }
//    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
//        for characteristic in service.characteristics! {
//            print(characteristic)
//
//               if characteristic.uuid == BLE_PI_Step_Measurement_Characteristic_CBUUID {
//                        peripheral.readValue(for: characteristic)
//               }
//
//               if characteristic.uuid == BLE_PI_Pressure_Characteristic_CBUUID {
//                        peripheral.readValue(for: characteristic)
//               }
//           }
//       }
//    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
//
//           if characteristic.uuid == BLE_PI_Step_Measurement_Characteristic_CBUUID {
//
//               let numSteps = deriveSteps(using: characteristic)
//
//               DispatchQueue.main.async { () -> Void in
//                    self.number_of_steps = numSteps
//
//               }
//
//           }
//
//           if characteristic.uuid == BLE_PI_Pressure_Characteristic_CBUUID {
//
//               let pressures = readPressureData(using: characteristic)
//
//               DispatchQueue.main.async { () -> Void in
//                self.true_data = [pressures]
//               }
//           }
//
//       }
//    func deriveSteps(using stepsCharacteristic: CBCharacteristic) -> Int {
//        let stepsVal = stepsCharacteristic.value!
//           // convert to an array of unsigned 8-bit integers
//        let buffer = [UInt8](stepsVal)
//
//        if ((buffer[0] & 0x01) == 0) {
//            print("Steps data is UInt8")
//            return Int(buffer[1])
//        } else {
//            print("Step data is UInt16 or more")
//            return -1
//        }
//    }
//    func readPressureData(using pressuresCharacteristic: CBCharacteristic) -> Int {
//
//        let pressuresVal = pressuresCharacteristic.value!
//        // convert to an array of unsigned 8-bit integers
//        let buffer = [UInt8](pressuresVal)
//
//        if ((buffer[0] & 0x01) == 0) {
//            print("Pressure data is UInt8")
//            return Int(buffer[1])
//        } else {
//             print("Pressure data is UInt16 or more")
//             return -1
//        }
//    }
//}
