//
//  SamsungViewController.swift
//  Proyecto1
//
//  Created by DAMII on 25/10/23.
//

import UIKit
import CoreData

class SamsungViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var listaSamsung = [Samsung]()
    let contexto = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var tablaSamsung: UITableView!
    
    @IBAction func nuevoSamsung(_ sender: UIBarButtonItem) {
        var nombreSamsung = UITextField()
        
        let alerta = UIAlertController(title: "Nueva", message: "Apple", preferredStyle: .alert)
        
        let accionAceptar = UIAlertAction(title: "Agregar", style: .default) {(_) in let nuevoSamsung = Samsung(context: self.contexto)
            nuevoSamsung.nombre = nombreSamsung.text
            nuevoSamsung.estado = false
            self.listaSamsung.append(nuevoSamsung)
            self.guardar()
        }
        
        alerta.addTextField{textFieldAlerta in textFieldAlerta.placeholder = "Escribe tu texto aqui"
            nombreSamsung = textFieldAlerta
        }
        alerta.addAction(accionAceptar)
        present(alerta, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tablaSamsung.delegate = self
        tablaSamsung.dataSource = self
        leerApple()
    }
    
    func guardar(){
        do {
            try contexto.save()
        } catch {
            print( error.localizedDescription)
        }
        self.tablaSamsung.reloadData()
    }
    
    func leerApple(){
        let solicitud: NSFetchRequest<Samsung> = Samsung.fetchRequest()
        do{ listaSamsung = try contexto.fetch(solicitud)}
        catch {
            print(error.localizedDescription)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Palomear la tarea
        if tablaSamsung.cellForRow(at: indexPath)?.accessoryType == .checkmark{ tablaSamsung.cellForRow(at: indexPath)?.accessoryType = .none}
        else{
            tablaSamsung.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        //Editar en coredata
        listaSamsung[indexPath.row].estado =
            !listaSamsung[indexPath.row].estado
        guardar()
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let accionEliminar = UIContextualAction(style:.normal, title: "eliminar"){_,_,_ in self.contexto.delete(self.listaSamsung[indexPath.row])
            self.listaSamsung.remove(at: indexPath.row)
            self.guardar()
        }
        accionEliminar.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [accionEliminar])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listaSamsung.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tablaSamsung.dequeueReusableCell(withIdentifier: "celda", for: indexPath)
        let tarea = listaSamsung [indexPath.row]
        celda.textLabel?.text = tarea.nombre
        celda.textLabel?.textColor = tarea.estado ?.black : .blue
        celda.detailTextLabel?.text = tarea.estado ? "Sin Stock" : "En Stock"
        celda.accessoryType = tarea.estado ?.checkmark : .none
        return celda
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
