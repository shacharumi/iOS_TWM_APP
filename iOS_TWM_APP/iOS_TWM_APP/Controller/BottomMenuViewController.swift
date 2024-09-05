//
//  BottomMenuViewController.swift
//  iOS_TWM_APP
//
//  Created by 謝霆 on 2024/8/23.
//

import UIKit

import SnapKit

import Alamofire

class BottomMenuViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.view.frame = CGRectMake(0, screenSize.height * 0.85 , screenSize.width, screenSize.height * 0.85)
        
        
        configBottomMenuView()
        
        customizeLabels()
        
        timer = Timer.scheduledTimer(timeInterval: 30.0, target: self, selector: #selector(repeatGetMockData), userInfo: nil, repeats: true)
        
        
        
        let userToken = UserDefaults.standard.string(forKey: "userToken")
        
        guard let userToken = userToken else{return}
        
        setFirstMockData()
        
        initializeHideKeyboard()
        
        searchBar.searchTextField.delegate = self
        
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        timer?.invalidate()
        timer = nil
    }
    
    
    var timer: Timer?
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
    }
    
    
    
    let bottomMenuView = UIImageView()
    
    var isExpanded: Bool? = false
    
    let recentUpdateLabel = UILabel()
    
    let timeLabel = UILabel()
    
    let dateLabel = UILabel()
    
    let deviceNameLabel = UILabel()
    
    let stepCountLabel = UILabel()
    
    let frequencyLabel = UILabel()
    
    let frequencyValueLabel = UILabel()
    
    let stepCountTextLabel = UILabel()
    
    let stepCountValueLabel = UILabel()
    
    let refreshButton = UIButton()
    
    let refreshButtonContainerView = UIView()
    
    let locateButton = UIButton()
    
    let locateButtonContainerView = UIView()
    
    let searchButton = UIButton()
    
    let searchButtonContainerView = UIView()
    
    let screenSize: CGRect = UIScreen.main.bounds
    
    let searchBar = UISearchBar()
    
    var completeSearchButton = UIButton(type: .system)
    
    var window: UIWindow?
    
    let loginRequest = LoginDataRequest()
    
    var hour = Calendar.current.component(.hour, from: Date())
    
    var minutes = Calendar.current.component(.minute, from: Date())
    
    var reloadMockData: MockData?
    
    var passDeviceName: ((String) -> Void)?
    
    
    func configBottomMenuView() {
        
        view.addSubview(bottomMenuView)
        
        view.layer.cornerRadius = 20
        
        view.backgroundColor = .white.withAlphaComponent(0.8)
        
        bottomMenuView.isUserInteractionEnabled = true
        
        [recentUpdateLabel, timeLabel, dateLabel, deviceNameLabel, stepCountTextLabel,
         stepCountValueLabel, frequencyLabel, frequencyValueLabel, searchBar, completeSearchButton].forEach {
            bottomMenuView.addSubview($0)
        }
        
        self.bottomMenuView.addSubview(searchButtonContainerView)
        
        self.bottomMenuView.addSubview(locateButtonContainerView)
        
        self.bottomMenuView.addSubview(refreshButtonContainerView)
        
        searchButtonContainerView.isHidden = true
        
        locateButtonContainerView.isHidden = true
        
        refreshButtonContainerView.isHidden = true
        
        searchBar.isHidden = true
        
        completeSearchButton.isHidden = true
        
        refreshButtonContainerView.addSubview(refreshButton)
        
        locateButtonContainerView.addSubview(locateButton)
        
        searchButtonContainerView.addSubview(searchButton)
        
        refreshButton.setImage(UIImage(named: "icons8-refresh-60"), for: .normal)
        
        locateButton.setImage(UIImage(named: "icons8-location-50"), for: .normal)
        
        searchButton.setImage(UIImage(named: "icons8-search-52"), for: .normal)
        
        
        
        bottomMenuView.snp.makeConstraints { make in
            
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            
            make.bottom.equalTo(view)
            
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left)
            
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right)
            
        }
        
        
        bottomMenuView.layer.cornerRadius = 20
        
        bottomMenuView.layer.borderColor = UIColor.white.cgColor
        
        bottomMenuView.layer.borderWidth = 0.5
        
        bottomMenuView.image = UIImage(named: "sports-background")
        
        bottomMenuView.alpha = 0.5
        
        bottomMenuView.layer.masksToBounds = true
        
        searchButtonContainerView.backgroundColor = .white
        
        searchButtonContainerView.layer.cornerRadius = 8
        
        searchButtonContainerView.layer.borderColor = UIColor.black.cgColor
        
        locateButtonContainerView.backgroundColor = .white
        
        locateButtonContainerView.layer.cornerRadius = 8
        
        locateButtonContainerView.layer.borderColor = UIColor.black.cgColor
        
        refreshButtonContainerView.backgroundColor = .white
        
        refreshButtonContainerView.layer.cornerRadius = 8
        
        refreshButtonContainerView.layer.borderColor = UIColor.black.cgColor
        
        locateButton.addTarget(self, action: #selector(locateButtonTapped), for: .touchUpInside)
        
        let tapBottomMenuGesture = UITapGestureRecognizer(target: self, action: #selector(didTappedBottomView))
        
        bottomMenuView.addGestureRecognizer(tapBottomMenuGesture)
        
        searchButton.addTarget(self, action: #selector(didTapSearchButton), for: .touchUpInside)
        
        refreshButton.addTarget(self, action: #selector(tappedRefreshButton), for: .touchUpInside)
        
        //completeSearchButton.addTarget(self, action: #selector(didTapCompleteSearchButton), for: .touchUpInside)
        //test
        //        locateButton.addTarget(self, action: #selector(testPush), for: .touchUpInside)
        
        setBottomViewConstraint()
        
    }
    
    func setBottomViewConstraint() {
        
        let commonYAnchor = deviceNameLabel.snp.bottom
        
        
        recentUpdateLabel.snp.makeConstraints { make in
            make.top.equalTo(commonYAnchor).offset(8)
            make.left.equalTo(bottomMenuView.snp.left).offset(40)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(recentUpdateLabel.snp.bottom).offset(8)
            make.left.equalTo(dateLabel.snp.right).offset(4)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(recentUpdateLabel.snp.bottom).offset(18)
            make.left.equalTo(bottomMenuView.snp.left).offset(12)
        }
        
        deviceNameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(bottomMenuView.snp.top).offset(25)
            make.centerX.equalTo(bottomMenuView.snp.centerX)
        }
        
        stepCountTextLabel.snp.makeConstraints { make in
            make.top.equalTo(deviceNameLabel.snp.bottom).offset(18)
            make.centerX.equalTo(deviceNameLabel.snp.centerX)
        }
        
        stepCountValueLabel.snp.makeConstraints { make in
            make.centerX.equalTo(stepCountTextLabel.snp.centerX)
            make.top.equalTo(stepCountTextLabel.snp.bottom).offset(8)
        }
        
        frequencyLabel.snp.makeConstraints { make in
            make.top.equalTo(commonYAnchor).offset(8) // Aligning Y with recentUpdateLabel
            make.right.equalTo(bottomMenuView.snp.centerX).offset(155)
        }
        
        frequencyValueLabel.snp.makeConstraints { make in
            make.top.equalTo(frequencyLabel.snp.bottom).offset(8)
            make.centerX.equalTo(bottomMenuView.snp.centerX).offset(140)
        }
        
        stepCountTextLabel.snp.makeConstraints { make in
            make.top.equalTo(commonYAnchor).offset(8) // Aligning Y with recentUpdateLabel
            make.centerX.equalTo(deviceNameLabel.snp.centerX)
        }
        
        refreshButtonContainerView.snp.makeConstraints { make in
            
            make.top.equalTo(recentUpdateLabel.snp.bottom).offset(screenSize.width * 0.15)
            
            make.left.equalTo(bottomMenuView.snp.left).offset(30)
            
            make.height.equalTo(screenSize.width * 0.15)
            
            make.width.equalTo(screenSize.width * 0.15)
            
        }
        
        locateButtonContainerView.snp.makeConstraints { make in
            
            make.top.equalTo(recentUpdateLabel.snp.bottom).offset(screenSize.width * 0.15)
            
            make.centerX.equalTo(deviceNameLabel.snp.centerX)
            
            make.height.equalTo(screenSize.width * 0.15)
            
            make.width.equalTo(screenSize.width * 0.15)
            
        }
        
        searchButtonContainerView.snp.makeConstraints { make in
            
            make.top.equalTo(recentUpdateLabel.snp.bottom).offset(screenSize.width * 0.15)
            make.centerX.equalTo(bottomMenuView.snp.centerX).offset(140)
            make.height.equalTo(screenSize.width * 0.15)
            make.width.equalTo(screenSize.width * 0.15)
        }
        
        searchButton.snp.makeConstraints { make in
            
            make.centerX.equalTo(searchButtonContainerView.snp.centerX)
            
            make.centerY.equalTo(searchButtonContainerView.snp.centerY)
            
        }
        
        refreshButton.snp.makeConstraints { make in
            
            make.centerX.equalTo(refreshButtonContainerView.snp.centerX)
            
            make.centerY.equalTo(refreshButtonContainerView.snp.centerY)
            
        }
        
        locateButton.snp.makeConstraints { make in
            
            make.centerX.equalTo(locateButtonContainerView.snp.centerX)
            
            make.centerY.equalTo(locateButtonContainerView.snp.centerY)
            
        }
        
    }
    
    
    func customizeLabels() {
        
        
        
        
        recentUpdateLabel.text = "最近更新"
        
        deviceNameLabel.text = "DeviceName"
        stepCountTextLabel.text = "今日步數"
        stepCountValueLabel.text = "0"
        frequencyLabel.text = "頻率"
        
        recentUpdateLabel.textColor = .darkGray
        
        stepCountTextLabel.textColor = .darkGray
        
        frequencyLabel.textColor = .darkGray
        
        recentUpdateLabel.font = .systemFont(ofSize: 14)
        stepCountTextLabel.font = .systemFont(ofSize: 14)
        frequencyLabel.font = .systemFont(ofSize: 14)
        timeLabel.font = .systemFont(ofSize: 24)
        stepCountValueLabel.font = .systemFont(ofSize: 24)
        frequencyValueLabel.font = .systemFont(ofSize: 24)
        deviceNameLabel.font = .systemFont(ofSize: 24)
        dateLabel.font = .systemFont(ofSize: 12)
        
    }
    
    @objc func repeatGetMockData() {
        
        let userToken = UserDefaults.standard.string(forKey: "userToken")
        
        
        guard let userToken = userToken else {
            
            print("userToken not found")
            
            return}
        
        getMockData(userToken)
        
        
    }
    
    @objc func locateButtonTapped() {
        NotificationCenter.default.post(name: NSNotification.Name("LocateButtonTappedNotification"), object: nil)
    }
    
    
    @objc func didTapSearchButton() {
        
        searchBar.isHidden = false
        completeSearchButton.isHidden = false
        completeSearchButton.isEnabled = true
        
        
        self.view.frame = CGRectMake(0, screenSize.height * 0.63, screenSize.width, screenSize.height * 0.4)
        
        
        self.deviceNameLabel.snp.updateConstraints { make in
            make.centerY.equalTo(bottomMenuView.snp.top).offset(105)
        }
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(bottomMenuView).offset(25)
            make.width.equalTo(bottomMenuView).multipliedBy(0.77)
            make.height.equalTo(40)
            make.leading.equalTo(bottomMenuView).offset(20)
        }
        
        completeSearchButton.snp.makeConstraints { make in
            make.width.equalTo(40)
            make.height.equalTo(30)
            make.trailing.equalTo(bottomMenuView.snp.trailing).offset(-15)
            make.centerY.equalTo(searchBar)
        }
        
        searchBar.text = ""
        searchBar.backgroundColor = .white
        searchBar.searchBarStyle = .minimal
        searchBar.layer.cornerRadius = 10
        searchBar.searchTextField.textColor = .black
        
        completeSearchButton.setTitle("完成", for: .normal)
        completeSearchButton.setTitleColor(.systemBlue, for: .normal)
        
        
        
        self.view.layoutIfNeeded()
        
    }
    
    
    
    @objc func didTapCompleteSearchButton() {
        
        SportsVenueViewController().passKeyWords?(searchBar.text ?? "")
        
    }
    
    
    @objc func didTappedBottomView() {
        
        searchBar.isHidden = true
        completeSearchButton.isHidden = true
        
        view.endEditing(true)
        
        self.deviceNameLabel.snp.updateConstraints { make in
            make.centerY.equalTo(bottomMenuView.snp.top).offset(25)
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            if self.isExpanded == false {
                
                self.view.frame = CGRectMake(0, self.screenSize.height * 0.74, self.screenSize.width, self.screenSize.height * 0.29)
                
                
                self.searchButtonContainerView.isHidden = false
                
                self.locateButtonContainerView.isHidden = false
                
                self.refreshButtonContainerView.isHidden = false
                
                self.searchButtonContainerView.transform = .identity
                self.locateButtonContainerView.transform = .identity
                self.refreshButtonContainerView.transform = .identity
                
                self.isExpanded = true
            } else {
                
                self.view.frame = CGRectMake(0, self.screenSize.height * 0.85, self.screenSize.width, self.screenSize.height * 0.20)
                
                
                self.searchButtonContainerView.transform = CGAffineTransform(translationX: 0, y: 60)
                self.locateButtonContainerView.transform = CGAffineTransform(translationX: 0, y: 60)
                self.refreshButtonContainerView.transform = CGAffineTransform(translationX: 0, y: 60)
                
                
                self.isExpanded = false
                
            }
            self.view.layoutIfNeeded()
        })
        
        
    }
    
    
    @objc func tappedRefreshButton () {
        
        let userToken = UserDefaults.standard.string(forKey: "userToken")
        
        
        guard let userToken = userToken else {
            
            print("userToken not found")
            
            return}
        
        print("get token: \(userToken)")
        
        self.getMockData(userToken)
        
        
    }
    
    @objc func getMockData(_ token: String) {
        
        let calendar = Calendar.current
        
        let date = Date()
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "accept": "application/json"
        ]
        
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        
        AF.request("https://fastapi-production-a532.up.railway.app/Info/",
                   method: .get, headers: headers).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let decodeData = try decoder.decode(MockData.self, from: data)
                    
                    NotificationCenter.default.post(name: Notification.Name("didUpdateMockData"), object: nil)
                    print("MockData Response: \(decodeData)")
                    
                    if decodeData.deviceName == nil && decodeData.step == nil {
                        let token = UserDefaults.standard.string(forKey: "userToken")
                        let savedUserID = UserDefaults.standard.string(forKey: "userID")
                        let savedUserPassword = UserDefaults.standard.string(forKey: "userPassword")
                        self.loginRequest.loginData(userID: savedUserID ?? "", password: savedUserPassword ?? "") { [weak self] success, message in
                            guard let self = self else { return }
                        }
                        
                        self.getMockData(token ?? "")
                        
                    } else {
                        let formatter = DateFormatter()
                        formatter.dateFormat = "MM/dd"
                        
                        self.dateLabel.text = formatter.string(from: date)
                        self.timeLabel.text = String(format: "%02d:%02d", hour, minutes)
                        self.deviceNameLabel.text = decodeData.deviceName
                        self.stepCountValueLabel.text = String(decodeData.step ?? 0)
                        
                        self.frequencyValueLabel.text = decodeData.frequency
                        
                        self.passDeviceName?(decodeData.deviceName ?? "no data")
                        self.saveMockDataToUserDefaults(decodeData)
                    }
                    
                } catch let decodingError {
                    print("Decoding Error: \(decodingError)")
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    @objc func testPush() {
        self.navigationController?.pushViewController(SportsVenueViewController(), animated: true)
    }
    
    
}


extension BottomMenuViewController {
    func setFirstMockData() {
        if let savedData = UserDefaults.standard.data(forKey: "MockData") {
            do {
                let decoder = JSONDecoder()
                let savedMockData = try decoder.decode(MockData.self, from: savedData)
                
                let formatter = DateFormatter()
                formatter.dateFormat = "MM/dd"
                
                self.dateLabel.text = formatter.string(from: Date())
                self.timeLabel.text = String(format: "%02d:%02d", hour, minutes)
                self.deviceNameLabel.text = savedMockData.deviceName
                self.stepCountValueLabel.text = String(savedMockData.step ?? 0)
                self.frequencyValueLabel.text = savedMockData.frequency
                
            } catch {
                print("Failed to decode saved MockData: \(error)")
            }
        }
    }
    
    func saveMockDataToUserDefaults(_ data: MockData) {
        let encoder = JSONEncoder()
        do {
            let encodedData = try encoder.encode(data)
            UserDefaults.standard.set(encodedData, forKey: "MockData")
            NotificationCenter.default.post(name: .didUpdateMockData, object: nil)
            
        } catch {
            print("Failed to encode MockData: \(error)")
        }
    }
    
    
}

extension Notification.Name {
    static let didUpdateMockData = Notification.Name("didUpdateMockData")
}

extension BottomMenuViewController {
    func initializeHideKeyboard(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissMyKeyboard))
        view.addGestureRecognizer(tap)
    }
    @objc func dismissMyKeyboard(){
        
        view.endEditing(true)
    }
}

extension BottomMenuViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
}



