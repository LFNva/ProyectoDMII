//
//  OppoViewController.swift
//  Proyecto1
//
//  Created by DAMII on 5/11/23.
//

import UIKit
import CoreData

class OppoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var listaOppo = [Oppo]()
    let contexto = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext


    @IBOutlet weak var tablaOppo: UITableView!
    
    
    @IBAction func nuevoOppo(_ sender: UIBarButtonItem) {
        var nombreOppo = UITextField()

        let alerta = UIAlertController(title: "Nuevo Oppo", message: "Agregar nuevo elemento", preferredStyle: .alert)

        let accionAceptar = UIAlertAction(title: "Agregar", style: .default) { (_) in
            let nuevoOppo = Oppo(context: self.contexto)
            nuevoOppo.nombre = nombreOppo.text
            nuevoOppo.estado = false
            self.listaOppo.append(nuevoOppo)
            self.guardar()
        }

        alerta.addTextField { textFieldAlerta in
            textFieldAlerta.placeholder = "Escribe tu texto aquí"
            nombreOppo = textFieldAlerta
        }

        alerta.addAction(accionAceptar)
        present(alerta, animated: true)
    }
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tablaOppo.delegate = self
        tablaOppo.dataSource = self
        leerOppo()
    }

    func guardar() {
        do {
            try contexto.save()
        } catch {
            print(error.localizedDescription)
        }
        self.tablaOppo.reloadData()
    }

    func leerOppo() {
        let solicitud: NSFetchRequest<Oppo> = Oppo.fetchRequest()
        do {
            listaOppo = try contexto.fetch(solicitud)
        } catch {
            print(error.localizedDescription)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tablaOppo.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tablaOppo.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tablaOppo.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }

        listaOppo[indexPath.row].estado = !listaOppo[indexPath.row].estado
        guardar()
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let accionEliminar = UIContextualAction(style: .normal, title: "Eliminar") { _, _, _ in
            self.contexto.delete(self.listaOppo[indexPath.row])
            self.listaOppo.remove(at: indexPath.row)
            self.guardar()
        }

        accionEliminar.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [accionEliminar])
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listaOppo.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tablaOppo.dequeueReusableCell(withIdentifier: "celda", for: indexPath)
        let oppoItem = listaOppo[indexPath.row]

        celda.textLabel?.text = oppoItem.nombre
        celda.textLabel?.textColor = oppoItem.estado ? .black : .blue
        celda.detailTextLabel?.text = oppoItem.estado ? "Sin Stock" : "En Stock"
        celda.accessoryType = oppoItem.estado ? .checkmark : .none

        return celda
    }
}
