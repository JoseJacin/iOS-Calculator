//
//  AppDelegate.swift
//  iOS-Calculator
//
//  Created by Jose Jacinto Sanchez Rodriguez - INDIZEN on 15/08/2019.
//  Copyright © 2019 José Sánchez Rodríguez. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Setup
        setupView()
        
        return true
    }
    
    // MARK: - Private Methods
    // Inicializa la primera vista de la app
    private func setupView() {
        // Se instancia la Vista completa de la app
        window = UIWindow(frame: UIScreen.main.bounds)
        // Se instancia el ViewController de la vista que se quire mostrar
        let vc = HomeViewController()
        // Se asigna al Controlador de Vista Principal de window (Vista completa de la app) el ViewController de la vista
        window?.rootViewController = vc
        // Indicamos que se inicie y que se muestre
        window?.makeKeyAndVisible()
    }
}

