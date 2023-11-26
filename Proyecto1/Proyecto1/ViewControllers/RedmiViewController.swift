//
//  RedmiViewController.swift
//  Proyecto1
//
//  Created by DAMII on 5/11/23.
//

import UIKit
import CoreData

class RedmiViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var listaRedmi = [Redmi]()
    let contexto = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext


    @IBOutlet weak var tablaRedmi: UITableView!
    
    @IBAction func nuevoRedmi(_ sender: UIBarButtonItem) {
        var nombreRedmi = UITextField()

        let alerta = UIAlertController(title: "Nueva", message: "Redmi", preferredStyle: .alert)

        let accionAceptar = UIAlertAction(title: "Agregar", style: .default) {(_) in
            let nuevoRedmi = Redmi(context: self.contexto)
            nuevoRedmi.nombre = nombreRedmi.text
            nuevoRedmi.estado = false
            self.listaRedmi.append(nuevoRedmi)
            self.guardar()
        }

        alerta.addTextField { textFieldAlerta in
            textFieldAlerta.placeholder = "Escribe tu texto aquí"
            nombreRedmi = textFieldAlerta
        }

        alerta.addAction(accionAceptar)
        present(alerta, animated: true)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tablaRedmi.delegate = self
        tablaRedmi.dataSource = self
        leerRedmi()
    }

    func guardar() {
        do {
            try contexto.save()
        } catch {
            print( error.localizedDescription)
        }
        self.tablaRedmi.reloadData()
    }

    func leerRedmi() {
        let solicitud: NSFetchRequest<Redmi> = Redmi.fetchRequest()
        do {
            listaRedmi = try contexto.fetch(solicitud)
        } catch {
            print(error.localizedDescription)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tablaRedmi.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tablaRedmi.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tablaRedmi.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }

        listaRedmi[indexPath.row].estado = !listaRedmi[indexPath.row].estado
        guardar()
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let accionEliminar = UIContextualAction(style: .normal, title: "eliminar") { _, _, _ in
            self.contexto.delete(self.listaRedmi[indexPath.row])
            self.listaRedmi.remove(at: indexPath.row)
            self.guardar()
        }

        accionEliminar.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [accionEliminar])
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listaRedmi.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tablaRedmi.dequeueReusableCell(withIdentifier: "celda", for: indexPath)
        let tarea = listaRedmi[indexPath.row]

        celda.textLabel?.text = tarea.nombre
        celda.textLabel?.textColor = tarea.estado ? .black : .blue
        celda.detailTextLabel?.text = tarea.estado ? "Sin Stock" : "En Stock"
        celda.accessoryType = tarea.estado ? .checkmark : .none

        return celda
    }
}
