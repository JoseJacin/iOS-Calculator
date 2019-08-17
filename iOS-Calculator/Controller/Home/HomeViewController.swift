//
//  HomeViewController.swift
//  iOS-Calculator
//
//  Created by Jose Jacinto Sanchez Rodriguez - INDIZEN on 15/08/2019.
//  Copyright © 2019 José Sánchez Rodríguez. All rights reserved.
//

import UIKit

final class HomeViewController: UIViewController {

    // MARK: - Outlets
    //Result
    @IBOutlet weak var resultLabel: UILabel!
    
    // Numbers
    @IBOutlet weak var number0: UIButton!
    @IBOutlet weak var number1: UIButton!
    @IBOutlet weak var number2: UIButton!
    @IBOutlet weak var number3: UIButton!
    @IBOutlet weak var number4: UIButton!
    @IBOutlet weak var number5: UIButton!
    @IBOutlet weak var number6: UIButton!
    @IBOutlet weak var number7: UIButton!
    @IBOutlet weak var number8: UIButton!
    @IBOutlet weak var number9: UIButton!
    @IBOutlet weak var numberDecimal: UIButton!
    
    // Operators
    @IBOutlet weak var operatorAC: UIButton!
    @IBOutlet weak var operatorPlusMinus: UIButton!
    @IBOutlet weak var OperatorPercent: UIButton!
    @IBOutlet weak var operatorResult: UIButton!
    @IBOutlet weak var operatorAddition: UIButton!
    @IBOutlet weak var operatorSubstraction: UIButton!
    @IBOutlet weak var operatorMultiplication: UIButton!
    @IBOutlet weak var operatorDivision: UIButton!
    
    // MARK: - Variables
    private var total: Double = 0                   // Total
    private var temp: Double = 0                    // Valor temporal que se irá mostrando en resultLabel
    private var operating = false                   // Indicar si se ha seleccionado un operador
    private var decimal = false                     // Indicar si el valor es decimal
    private var operation: OperationType = .none    // Operación actual
    
    // MARK: - Constants
    private let kDecimalSeparator = Locale.current.decimalSeparator!    // Separador decimal dependiendo de la localización del dispositivo
    private let kMaxLenght = 9                                          // Longitud máxima permitida
    private let kTotal = "total"                                        // Último valor calculado
    
    private enum OperationType {
        case none, addiction, substraction, multiplication, division, percent
    }
    
    // Formateo de valores auxiliar
    private let auxFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        let locale = Locale.current
        formatter.groupingSeparator = ""                        // Separador de grupo. Separador cada 3 dígitos
        formatter.decimalSeparator = locale.decimalSeparator    // Separador decimal
        formatter.numberStyle = .decimal                        // Se indica que el formateador acepte decimales
        formatter.maximumIntegerDigits = 100                    // Número máximo de dígitos para un entero
        formatter.minimumIntegerDigits = 0                      // Número mínimo de dígitos para un entero
        formatter.maximumFractionDigits = 100                   // Número máximo de dígitos para un decimal
        return formatter
    }()
    
    // Formateo de valores auxiliar para el Total
    private let auxTotalFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = ""                        // Separador de grupo. Separador cada 3 dígitos
        formatter.decimalSeparator = ""                         // Separador decimal
        formatter.numberStyle = .decimal                        // Se indica que el formateador acepte decimales
        formatter.maximumIntegerDigits = 100                    // Número máximo de dígitos para un entero
        formatter.minimumIntegerDigits = 0                      // Número mínimo de dígitos para un entero
        formatter.maximumFractionDigits = 100                   // Número máximo de dígitos para un decimal
        return formatter
    }()
    
    // Formateo de valores por pantalla por defecto
    private let printFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        let locale = Locale.current
        formatter.groupingSeparator = locale.groupingSeparator  // Separador de grupo. Separador cada 3 dígitos
        formatter.decimalSeparator = locale.decimalSeparator    // Separador decimal
        formatter.numberStyle = .decimal                        // Se indica que el formateador acepte decimales
        formatter.maximumIntegerDigits = 9                      // Número máximo de dígitos para un entero
        formatter.minimumFractionDigits = 0                     // Indicador de número mínimo de decimales. Con 0 indicamos que puede no tenerlos
        formatter.maximumFractionDigits = 8                     // Número máximo de dígitos para un decimal
        return formatter
    }()
    
    // Formateo de valores por pantalla en formato científico
    private let printScientificFormatter: NumberFormatter = {
       let formatter = NumberFormatter()
        formatter.numberStyle = .scientific                     // Se indica que el formateador acepta exponentes
        formatter.maximumFractionDigits = 3                     // Número máximo de dígitos exponentes
        formatter.exponentSymbol = "e"                          // Símbolo exponencial
        return formatter
    }()
    
    // MARK: - Initialization
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Se establece el caracter para el botón numberDecimal
        numberDecimal.setTitle(kDecimalSeparator, for: .normal)
        
        // Se recupera el último valor guardado
        total = UserDefaults.standard.double(forKey: kTotal)
        
        result()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // UI - Preparación de la parte visual
        // Se modifica el aspecto de los botones
        // Numbers
        number0.round()
        number1.round()
        number2.round()
        number3.round()
        number4.round()
        number5.round()
        number6.round()
        number7.round()
        number8.round()
        number9.round()
        numberDecimal.round()
        
        // Operators
        operatorAC.round()
        operatorPlusMinus.round()
        OperatorPercent.round()
        operatorResult.round()
        operatorAddition.round()
        operatorSubstraction.round()
        operatorMultiplication.round()
        operatorDivision.round()
    }
    
    // MARK: - Button Actions
    //Numbers
    @IBAction func numberAction(_ sender: UIButton) {
        // Se ejecuta la funcionalidad del número
        
        // Se cambia el título del botón operator a "C"
        operatorAC.setTitle("C", for: .normal)
        
        // Se obtiene el valor actual sin separadores
        var currentTemp = auxTotalFormatter.string(from: NSNumber(value: temp))!
        
        // Se comprueba si no se está realizando ninguna operación y si el tamaño máxio del valor actual es menor que el tamaño máximo permitido
        // Se comprueba si lo que se está escribiendo es susceptible de operar
        if !operating && currentTemp.count >= kMaxLenght {
            return
        }
        
        currentTemp = auxFormatter.string(from: NSNumber(value: temp))!
        
        // Si se ha seleccionado una operación
        if operating {
            total = total == 0 ? temp : total
            resultLabel.text = ""
            currentTemp = ""
            operating = false
        }
        
        // Si se ha seleccionado decimales
        if decimal {
            currentTemp = "\(currentTemp)\(kDecimalSeparator)"
            decimal = false
        }
        
        // Se obtiene el número pulsado
        let number = sender.tag
        temp = Double(currentTemp + String(number))!
        resultLabel.text = printFormatter.string(from: NSNumber(value: temp))
        
        // Se indica visualmente el botón seleccionado
        selectVisualOperation()
        
        // Se modifican las animaciones de los botones
        sender.shine()
        
        print(sender.tag)
    }
    
    //Operators
    @IBAction func operatorACAction(_ sender: UIButton) {
        // Se limpia todo
        clear()
        
        // Se modifican las animaciones de los botones
        sender.shine()
    }
    @IBAction func operatorPlusMinusAction(_ sender: UIButton) {
        // Se ejecuta el cambio de signo
        temp = temp * (-1)
        
        // Se muestra el resultado
        resultLabel.text = printFormatter.string(from: NSNumber(value: temp))
        
        // Se modifican las animaciones de los botones
        sender.shine()
    }
    @IBAction func operatorPercentAction(_ sender: UIButton) {
        // Se ejecuta el pocentaje
        
        // Se controla si hay una operación vigente diferente al porcentaje
        // Si es así, se finaliza antes
        if operation != .percent {
            result()
        }
        
        // Se establece que se está ejecutando una operación
        operating = true
        
        // Se establece el tipo de operación
        operation = .percent
        
        // Se ejecuta el resultado
        result()
        
        // Se modifican las animaciones de los botones
        sender.shine()
    }
    @IBAction func operatorResultAction(_ sender: UIButton) {
        // Se ejecuta el resultado
        result()
        
        // Se modifican las animaciones de los botones
        sender.shine()
    }
    @IBAction func operatorAdditionAction(_ sender: UIButton) {
        // Se ejecuta la suma
        
        // Se consulta si se está ejecutando una operación
        if operation != .none {
            // Se ejecuta el resultado
            result()
        }
        
        // Se establece que se está ejecutando una operación
        operating = true
        
        // Se establece el tipo de operación
        operation = .addiction
        
        // Se indica visualmente el botón seleccionado
        sender.selected(true)
        
        // Se modifican las animaciones de los botones
        sender.shine()
    }
    @IBAction func operatorSubstractionAction(_ sender: UIButton) {
        // Se ejecuta la resta
        
        // Se consulta si se está ejecutando una operación
        if operation != .none {
            // Se ejecuta el resultado
            result()
        }
        
        // Se establece que se está ejecutando una operación
        operating = true
        
        // Se establece el tipo de operación
        operation = .substraction
        
        // Se indica visualmente el botón seleccionado
        sender.selected(true)
        
        // Se modifican las animaciones de los botones
        sender.shine()
    }
    @IBAction func operatorMultiplicationAction(_ sender: UIButton) {
        // Se ejecuta la multiplicación
        
        // Se consulta si se está ejecutando una operación
        if operation != .none {
            // Se ejecuta el resultado
            result()
        }
        
        // Se establece que se está ejecutando una operación
        operating = true
        
        // Se establece el tipo de operación
        operation = .multiplication
        
        // Se indica visualmente el botón seleccionado
        sender.selected(true)
        
        // Se modifican las animaciones de los botones
        sender.shine()
    }
    @IBAction func operatorDivisionAction(_ sender: UIButton) {
        // Se ejecuta la división
        
        // Se consulta si se está ejecutando una operación
        if operation != .none {
            // Se ejecuta el resultado
            result()
        }
        
        // Se establece que se está ejecutando una operación
        operating = true
        
        // Se establece el tipo de operación
        operation = .division
        
        // Se indica visualmente el botón seleccionado
        sender.selected(true)
        
        // Se modifican las animaciones de los botones
        sender.shine()
    }
    @IBAction func operatorDecimalAction(_ sender: UIButton) {
        // Se ejecuta la funcionalidad del decimal
        
        // Se obtiene el valor actual sin separadores
        let currentTemp = auxTotalFormatter.string(from: NSNumber(value: temp))!
        
        // Se comprueba si no se está realizando ninguna operación y si el tamaño máxio del valor actual es menor que el tamaño máximo permitido
        // Se comprueba si lo que se está escribiendo es susceptible de operar
        if !operating && currentTemp.count >= kMaxLenght {
            return
        }
        
        // Se pinta el separador decimal
        resultLabel.text = resultLabel.text! + kDecimalSeparator
        
        // Se establece que hay un decimal
        decimal = true
        
        // Se indica visualmente el botón seleccionado
        selectVisualOperation()
        
        // Se modifican las animaciones de los botones
        sender.shine()
    }
    
    // MARK: - Functions
    // Limpia los valores
    private func clear() {
        // Se establece que no se está realizando ninguna operación
        operation = .none
        
        // Se cambia el título del botón "operator" por AC
        operatorAC.setTitle("AC", for: .normal)
        
        // Se controla si el valor temporal es diferente a 0
        if temp != 0 {
            // Se establece el valor temporal a 0
            temp = 0
            // Se printa en resultLabel el valor 0
            resultLabel.text = "0"
        } else {
            // Se establece el valor total a 0
            total = 0
            // Se obtiene el resultado
            result()
        }
    }
    
    // Obtiene el resultado final
    private func result() {
        switch operation {
        case .none:
            // No se realiza nada
            break
        case .addiction:
            // Se realiza una suma
            total = total + temp
            break
        case .substraction:
            // Se realiza una resta
            total = total - temp
            break
        case .multiplication:
            // Se realiza una multiplicacion
            total = total * temp
            break
        case .division:
            // Se realiza una división
            total = total / temp
            break
        case .percent:
            // Se realiza el cálculo del porcentaje
            temp = temp / 100
            total = temp
            break
        }
        
        // Formateo en pantalla
        if let currentTotal = auxTotalFormatter.string(from: NSNumber(value: total)), currentTotal.count > kMaxLenght {
            resultLabel.text = printScientificFormatter.string(from: NSNumber(value: total))
        } else {
            resultLabel.text = printFormatter.string(from: NSNumber(value: total))

        }
        
        operation = .none
        
        // Se indica visualmente el botón seleccionado
        selectVisualOperation()
        
        // Se guarda el último valor de Total
        UserDefaults.standard.set(total, forKey: kTotal)
        
        print("TOTAL: \(total)")
    }
    
    // Muestra de forma visual la operación seleccionada
    private func selectVisualOperation() {
        if !operating {
            // No se está operando
            operatorAddition.selected(false)
            operatorSubstraction.selected(false)
            operatorMultiplication.selected(false)
            operatorDivision.selected(false)
        } else {
            switch operation {
            case .none, .percent:
                operatorAddition.selected(false)
                operatorSubstraction.selected(false)
                operatorMultiplication.selected(false)
                operatorDivision.selected(false)
                break
            case .addiction:
                operatorAddition.selected(true)
                operatorSubstraction.selected(false)
                operatorMultiplication.selected(false)
                operatorDivision.selected(false)
                break
            case .substraction:
                operatorAddition.selected(false)
                operatorSubstraction.selected(true)
                operatorMultiplication.selected(false)
                operatorDivision.selected(false)
                break
            case .multiplication:
                operatorAddition.selected(false)
                operatorSubstraction.selected(false)
                operatorMultiplication.selected(true)
                operatorDivision.selected(false)
                break
            case .division:
                operatorAddition.selected(false)
                operatorSubstraction.selected(false)
                operatorMultiplication.selected(false)
                operatorDivision.selected(true)
                break
            }
        }
    }
}
