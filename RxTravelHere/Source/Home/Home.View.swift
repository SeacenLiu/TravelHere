//
//  Home.View.swift
//  RxTravelHere
//
//  Created by SeacenLiu on 2018/12/5.
//  Copyright © 2018 SeacenLiu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension Home {
    final class View: UIViewController {
        private var _homeView: HomeView { return view as! HomeView }
        let _disposeBag = DisposeBag()
        
        override func loadView() {
            view = HomeView.nibView()
        }
        
        /// 地图
        fileprivate lazy var mapView = MAMapView(
            bundle: "MapSetting",
            frame: self.view.bounds
        )
        
        /// ViewModel
        private lazy var _viewModel = ViewModel(input: (
            locations: self.mapView.rx.didUpdateUserLocation.map{ $0.location.coordinate },
            refreshTap: self._homeView.refreshBtn.rx.tap.asSignal()))
        
        private lazy var locationManager = CLLocationManager(delegate: self)
        // TODO: - 没有定位权限使用高斯模糊
    }
}

extension Home.View {
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        checkLocationAuthorization()
        
        _homeView.userBtn.rx.tap
            .subscribe { (_) in
                Account.Manager.shared.ensureLogin(curVC: self, handle: {
                    self.present(UserCenter.View.viewForNavigation(), animated: true)
                })
        }
        .disposed(by: _disposeBag)
        
        _homeView.editBtn.rx.tap.subscribe(onNext: { [unowned self] _ in
            Account.Manager.shared.ensureLogin(curVC: self, handle: {
                self.present(Record.Edit.View(), animated: true)
            })
        }).disposed(by: _disposeBag)

        _viewModel.avatar
            .drive(_homeView.userBtn.rx.image(for: .normal))
            .disposed(by: _disposeBag)
        
        _viewModel.showRecord
            .debug()
            .drive(rx.homeShowArround)
            .disposed(by: _disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startLocation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        closeLocation()
    }
    
    func setupUI() {
        view.insertSubview(mapView, at: 0)
        // 用户位置显示
        let r = MAUserLocationRepresentation()
        r.showsAccuracyRing = false
        mapView.update(r)
        // 默认的视角
        mapView.setDefaultVisual()
    }
}

// MARK: - 定位权限有关
extension Home.View {
    private func startLocation() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
            mapView.userTrackingMode = .followWithHeading
        }
        else if CLLocationManager.authorizationStatus() != .notDetermined  {
            tipChangePrivilege(privilege: .location)
        }
    }
    
    private func closeLocation() {
        mapView.showsUserLocation = false
        mapView.userTrackingMode = .none
    }
}

extension Reactive where Base: Home.View {
    var homeShowArround: AnyObserver<Home.MapShowResult> {
        return Binder<Home.MapShowResult>(base) { c, v in
            if let news = v.news {
                if news.isEmpty {
                    c.showHUD(infoText: "附近没有留言")
                } else {
                    if let olds = v.olds {
                        c.mapView.removeAnnotations(olds)
                    }
                    c.mapView.addAnnotations(news)
                }
            } else {
                c.showHUD(errorText: "网络错误")
            }
        }.asObserver()
    }
}

// MARK: - CLLocationManagerDelegate
extension Home.View: CLLocationManagerDelegate {
    func checkLocationAuthorization() {
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
            mapView.userTrackingMode = .followWithHeading
        } else if CLLocationManager.authorizationStatus() != .notDetermined  {
            tipChangePrivilege(privilege: .location)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse:
            log("authorizedWhenInUse")
        case .denied:
            log("denied")
        default:
            break
        }
    }
}
