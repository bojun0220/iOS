/**
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 * distribute, sublicense, create a derivative work, and/or sell copies of the
 * Software in any work that is designed, intended, or marketed for pedagogical or
 * instructional purposes related to programming, coding, application development,
 * or information technology.  Permission for such use, copying, modification,
 * merger, publication, distribution, sublicensing, creation of derivative works,
 * or sale is expressly withheld.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit
import CoreBluetooth

let ServiceCBUUID = CBUUID(string: "FFE0")
let CharacteristicCBUUID = CBUUID(string: "FFE1")
var myperipheral: CBPeripheral!
var myCharacteristic: CBCharacteristic!

var receiving = ""


class HRMViewController: UIViewController {
  
  @IBOutlet weak var locationLabel: UILabel!
  @IBOutlet weak var PM25Label: UILabel!
  @IBOutlet weak var temperatureLabel: UILabel!
  @IBOutlet weak var PMlevelLabel: UILabel!
  @IBOutlet weak var temLabel: UILabel!
  @IBOutlet weak var lockButtonLabel: UIButton!
  @IBOutlet weak var BluetoothStateLabel: UILabel!
  @IBOutlet weak var speedLabel: UILabel!
  
  
  var centralManager: CBCentralManager!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    centralManager = CBCentralManager(delegate: self, queue: nil)
    
    // Make the digits monospaces to avoid shifting when the numbers change
    /*locationLabel.font = UIFont.monospacedDigitSystemFont(ofSize: locationLabel.font!.pointSize, weight: .regular)
     PM25Label.font = UIFont.monospacedDigitSystemFont(ofSize: PM25Label.font!.pointSize, weight: .regular)
     temperatureLabel.font = UIFont.monospacedDigitSystemFont(ofSize: temperatureLabel.font!.pointSize, weight: .regular)*/
  }
  var temp = true
  @IBAction func lockButton(_ sender: UIButton) {
    temp = !temp
    sendMessage("L")
    if temp{
      lockButtonLabel.setTitle("Unlock", for: .normal)
    }else{
      lockButtonLabel.setTitle("Lock", for: .normal)
    }
  }
    func sendMessage(_ message: String) {
        let valueString = (message as NSString).data(using: String.Encoding.utf8.rawValue)
        myperipheral!.writeValue(valueString!, for: myCharacteristic!, type: CBCharacteristicWriteType.withoutResponse)
    }

}

extension HRMViewController: CBCentralManagerDelegate {
  func centralManagerDidUpdateState(_ central: CBCentralManager) {
    switch central.state{
    case .unknown:
      print("Unknown")
    case .resetting:
      print("Resetting")
    case .unsupported:
      print("Unsupported")
    case .unauthorized:
      print("Unauthorized")
    case .poweredOff:
      print("Powered Off")
    case .poweredOn:
      print("Powered On")
      centralManager.scanForPeripherals(withServices: [ServiceCBUUID])
      BluetoothStateLabel.text = "Scanning for BLE device..."
    }
  }
  
  func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
    print(peripheral)
    myperipheral = peripheral
    centralManager.stopScan()
    print("Stop Scanning")
    BluetoothStateLabel.text = "Stop Scanning"
    centralManager.connect(myperipheral)
    myperipheral.delegate = self
  }
  
  func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
    print("Connected!")
    BluetoothStateLabel.text = "Connected!"
    myperipheral.discoverServices(nil)
  }
}

extension HRMViewController: CBPeripheralDelegate {
  func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
    guard let services = peripheral.services else { return }
    
    for service in services {
      print(service)
      peripheral.discoverCharacteristics(nil, for: service)
    }
    
  }
  func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService,
                  error: Error?) {
    guard let characteristics = service.characteristics else { return }
    myCharacteristic = service.characteristics?.last
    
    for characteristic in characteristics {
      print(characteristic)
      peripheral.readValue(for: characteristic)
      peripheral.setNotifyValue(true, for: characteristic)
    }
  }
  
  func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
    if let error = error {
      print("訂閱失敗: \(error)")
      return
    }
    if characteristic.isNotifying {
      print("訂閱成功")
    } else {
      print("取消訂閱")
    }
  }
  
  func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic,
                  error: Error?) {
    let data = characteristic.value
    if let str = String.init(data: data!, encoding: String.Encoding.utf8){
      print (str)
      receiving = str
      
      if let LocationIndex = receiving.firstIndex(of: "L") {
        locationLabel.text = "Locaton: \(receiving[LocationIndex ..< receiving.endIndex])"
        if let speedIndex = receiving.firstIndex(of: "S"){
          let index = receiving.index(speedIndex, offsetBy: 1)
          speedLabel.text = "\(receiving[index ..< receiving.endIndex])"
          
        }
        
      }
      if let PM25Index = receiving.firstIndex(of: "P"){
        PM25Label.text = "PM2.5: \(receiving[PM25Index ..< receiving.endIndex]) ug/m3"
        setPMstage(PMvalue: receiving)
      }
      if let TemperatureIndex = receiving.firstIndex(of: "T") {
        temperatureLabel.text = "Temperature: \(receiving[TemperatureIndex ..< receiving.endIndex]) ℃"
        setTemperature(tempretureValue: receiving)
      }
      
    }else{
      print("Received an invalid string")
    }
  }
  
  func setPMstage(PMvalue: String){
    let index = PMvalue.index(PMvalue.startIndex, offsetBy: 1)
    if let PMnumber = Double(PMvalue[index...]){
      switch PMnumber {
      case 71...:
        PMlevelLabel.text = "😱"
      case 54...71:
        PMlevelLabel.text = "😨"
      case 36...54:
        PMlevelLabel.text = "😐"
      default:
        PMlevelLabel.text = "😀"
      }
    }
  }
  func setTemperature(tempretureValue: String){
    let index = tempretureValue.index(tempretureValue.startIndex, offsetBy: 1)
    let temp = tempretureValue[index...]
    temLabel.text = "\(temp)"
  }
  
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?){
    print("寫入數據")
  }
}

