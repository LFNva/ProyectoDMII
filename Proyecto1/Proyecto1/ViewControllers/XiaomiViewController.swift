//
//  XiaomiViewController.swift
//  Proyecto1
//
//  Created by DAMII on 5/11/23.
//

import UIKit
import CoreData

class XiaomiViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var listaXiaomi = [Xiaomi]()
    let contexto = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    @IBOutlet weak var tablaXiaomi: UITableView!
    
    @IBAction func nuevoXiaomi(_ sender: UIBarButtonItem) {
        var nombreXiaomi = UITextField()

        let alerta = UIAlertController(title: "Nuevo Xiaomi", message: "Agregar nuevo elemento", preferredStyle: .alert)

        let accionAceptar = UIAlertAction(title: "Agregar", style: .default) { (_) in
            let nuevoXiaomi = Xiaomi(context: self.contexto)
            nuevoXiaomi.nombre = nombreXiaomi.text
            nuevoXiaomi.estado = false
            self.listaXiaomi.append(nuevoXiaomi)
            self.guardar()
        }

        alerta.addTextField { textFieldAlerta in
            textFieldAlerta.placeholder = "Escribe tu texto aquí"
            nombreXiaomi = textFieldAlerta
        }

        alerta.addAction(accionAceptar)
        present(alerta, animated: true)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tablaXiaomi.delegate = self
        tablaXiaomi.dataSource = self
        leerXiaomi()
    }

    func guardar() {
        do {
            try contexto.save()
        } catch {
            print(error.localizedDescription)
        }
        self.tablaXiaomi.reloadData()
    }

    func leerXiaomi() {
        let solicitud: NSFetchRequest<Xiaomi> = Xiaomi.fetchRequest()
        do {
            listaXiaomi = try contexto.fetch(solicitud)
        } catch {
            print(error.localizedDescription)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tablaXiaomi.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tablaXiaomi.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tablaXiaomi.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }

        listaXiaomi[indexPath.row].estado = !listaXiaomi[indexPath.row].estado
        guardar()
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let accionEliminar = UIContextualAction(style: .normal, title: "Eliminar") { _, _, _ in
            self.contexto.delete(self.listaXiaomi[indexPath.row])
            self.listaXiaomi.remove(at: indexPath.row)
            self.guardar()
        }

        accionEliminar.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [accionEliminar])
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listaXiaomi.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tablaXiaomi.dequeueReusableCell(withIdentifier: "celda", for: indexPath)
        let xiaomiItem = listaXiaomi[indexPath.row]

        celda.textLabel?.text = xiaomiItem.nombre
        celda.textLabel?.textColor = xiaomiItem.estado ? .black : .blue
        celda.detailTextLabel?.text = xiaomiItem.estado ? "Sin Stock" : "En Stock"
        celda.accessoryType = xiaomiItem.estado ? .checkmark : .none

        return celda
    }
}
