//
//  AccesoriosViewController.swift
//  Proyecto1
//
//  Created by DAMII on 5/11/23.
//

import UIKit
import CoreData

class AccesoriosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var listaAccesorios = [Accesorios]()
    let contexto = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext


    @IBOutlet weak var tablaAccesorios: UITableView!
    
    
    @IBAction func nuevoAccesorios(_ sender: UIBarButtonItem) {
        var nombreAccesorios = UITextField()

        let alerta = UIAlertController(title: "Nuevo Accesorio", message: "Agregar nuevo elemento", preferredStyle: .alert)

        let accionAceptar = UIAlertAction(title: "Agregar", style: .default) { (_) in
            let nuevoAccesorio = Accesorios(context: self.contexto)
            nuevoAccesorio.nombre = nombreAccesorios.text
            nuevoAccesorio.estado = false
            self.listaAccesorios.append(nuevoAccesorio)
            self.guardar()
        }

        alerta.addTextField { textFieldAlerta in
            textFieldAlerta.placeholder = "Escribe tu texto aquí"
            nombreAccesorios = textFieldAlerta
        }

        alerta.addAction(accionAceptar)
        present(alerta, animated: true)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tablaAccesorios.delegate = self
        tablaAccesorios.dataSource = self
        leerAccesorios()
    }

    func guardar() {
        do {
            try contexto.save()
        } catch {
            print(error.localizedDescription)
        }
        self.tablaAccesorios.reloadData()
    }

    func leerAccesorios() {
        let solicitud: NSFetchRequest<Accesorios> = Accesorios.fetchRequest()
        do {
            listaAccesorios = try contexto.fetch(solicitud)
        } catch {
            print(error.localizedDescription)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tablaAccesorios.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tablaAccesorios.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tablaAccesorios.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }

        listaAccesorios[indexPath.row].estado = !listaAccesorios[indexPath.row].estado
        guardar()
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let accionEliminar = UIContextualAction(style: .normal, title: "Eliminar") { _, _, _ in
            self.contexto.delete(self.listaAccesorios[indexPath.row])
            self.listaAccesorios.remove(at: indexPath.row)
            self.guardar()
        }

        accionEliminar.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [accionEliminar])
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listaAccesorios.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tablaAccesorios.dequeueReusableCell(withIdentifier: "celda", for: indexPath)
        let accesorio = listaAccesorios[indexPath.row]

        celda.textLabel?.text = accesorio.nombre
        celda.textLabel?.textColor = accesorio.estado ? .black : .blue
        celda.detailTextLabel?.text = accesorio.estado ? "Sin Stock" : "En Stock"
        celda.accessoryType = accesorio.estado ? .checkmark : .none

        return celda
    }
}
