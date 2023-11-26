//
//  LGViewController.swift
//  Proyecto1
//
//  Created by DAMII on 5/11/23.
//

import UIKit
import CoreData

class LGViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var listaLG = [LG]()
    let contexto = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext


    @IBOutlet weak var tablaLG: UITableView!
    
    @IBAction func nuevoLG(_ sender: UIBarButtonItem) {
        var nombreLG = UITextField()

        let alerta = UIAlertController(title: "Nuevo LG", message: "Agregar nuevo elemento", preferredStyle: .alert)

        let accionAceptar = UIAlertAction(title: "Agregar", style: .default) { (_) in
            let nuevoLG = LG(context: self.contexto)
            nuevoLG.nombre = nombreLG.text
            nuevoLG.estado = false
            self.listaLG.append(nuevoLG)
            self.guardar()
        }

        alerta.addTextField { textFieldAlerta in
            textFieldAlerta.placeholder = "Escribe tu texto aquí"
            nombreLG = textFieldAlerta
        }

        alerta.addAction(accionAceptar)
        present(alerta, animated: true)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tablaLG.delegate = self
        tablaLG.dataSource = self
        leerLG()
    }

    func guardar() {
        do {
            try contexto.save()
        } catch {
            print(error.localizedDescription)
        }
        self.tablaLG.reloadData()
    }

    func leerLG() {
        let solicitud: NSFetchRequest<LG> = LG.fetchRequest()
        do {
            listaLG = try contexto.fetch(solicitud)
        } catch {
            print(error.localizedDescription)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tablaLG.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tablaLG.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tablaLG.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }

        listaLG[indexPath.row].estado = !listaLG[indexPath.row].estado
        guardar()
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let accionEliminar = UIContextualAction(style: .normal, title: "Eliminar") { _, _, _ in
            self.contexto.delete(self.listaLG[indexPath.row])
            self.listaLG.remove(at: indexPath.row)
            self.guardar()
        }

        accionEliminar.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [accionEliminar])
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listaLG.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tablaLG.dequeueReusableCell(withIdentifier: "celda", for: indexPath)
        let lgItem = listaLG[indexPath.row]

        celda.textLabel?.text = lgItem.nombre
        celda.textLabel?.textColor = lgItem.estado ? .black : .blue
        celda.detailTextLabel?.text = lgItem.estado ? "Sin Stock" : "En Stock"
        celda.accessoryType = lgItem.estado ? .checkmark : .none

        return celda
    }
}
