//
//  MotorolaViewController.swift
//  Proyecto1
//
//  Created by DAMII on 5/11/23.
//

import UIKit
import CoreData

class MotorolaViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var listaMotorola = [Motorola]()
    let contexto = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    @IBOutlet weak var tablaMotorola: UITableView!
    
    @IBAction func nuevoMotorola(_ sender: UIBarButtonItem) {
        var nombreMotorola = UITextField()

        let alerta = UIAlertController(title: "Nuevo Motorola", message: "Agregar nuevo elemento", preferredStyle: .alert)

        let accionAceptar = UIAlertAction(title: "Agregar", style: .default) { (_) in
            let nuevoMotorola = Motorola(context: self.contexto)
            nuevoMotorola.nombre = nombreMotorola.text
            nuevoMotorola.estado = false
            self.listaMotorola.append(nuevoMotorola)
            self.guardar()
        }

        alerta.addTextField { textFieldAlerta in
            textFieldAlerta.placeholder = "Escribe tu texto aquí"
            nombreMotorola = textFieldAlerta
        }

        alerta.addAction(accionAceptar)
        present(alerta, animated: true)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tablaMotorola.delegate = self
        tablaMotorola.dataSource = self
        leerMotorola()
    }

    func guardar() {
        do {
            try contexto.save()
        } catch {
            print(error.localizedDescription)
        }
        self.tablaMotorola.reloadData()
    }

    func leerMotorola() {
        let solicitud: NSFetchRequest<Motorola> = Motorola.fetchRequest()
        do {
            listaMotorola = try contexto.fetch(solicitud)
        } catch {
            print(error.localizedDescription)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tablaMotorola.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tablaMotorola.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tablaMotorola.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }

        listaMotorola[indexPath.row].estado = !listaMotorola[indexPath.row].estado
        guardar()
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let accionEliminar = UIContextualAction(style: .normal, title: "Eliminar") { _, _, _ in
            self.contexto.delete(self.listaMotorola[indexPath.row])
            self.listaMotorola.remove(at: indexPath.row)
            self.guardar()
        }

        accionEliminar.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [accionEliminar])
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listaMotorola.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tablaMotorola.dequeueReusableCell(withIdentifier: "celda", for: indexPath)
        let motorolaItem = listaMotorola[indexPath.row]

        celda.textLabel?.text = motorolaItem.nombre
        celda.textLabel?.textColor = motorolaItem.estado ? .black : .blue
        celda.detailTextLabel?.text = motorolaItem.estado ? "Sin Stock" : "En Stock"
        celda.accessoryType = motorolaItem.estado ? .checkmark : .none

        return celda
    }
}
