//
//  AppleViewController.swift
//  Proyecto1
//
//  Created by DAMII on 25/10/23.
//

import UIKit
import CoreData

class AppleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var listaApple = [Apple]()
    let contexto = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    @IBOutlet weak var tablaApple: UITableView!
    
    @IBAction func nuevoApple(_ sender: UIBarButtonItem) {
        var nombreApple = UITextField()
        
        let alerta = UIAlertController(title: "Nueva", message: "Apple", preferredStyle: .alert)
        
        let accionAceptar = UIAlertAction(title: "Agregar", style: .default) {(_) in let nuevoApple = Apple(context: self.contexto)
            nuevoApple.nombre = nombreApple.text
            nuevoApple.estado = false
            self.listaApple.append(nuevoApple)
            self.guardar()
        }
        
        alerta.addTextField{textFieldAlerta in textFieldAlerta.placeholder = "Escribe tu texto aqui"
            nombreApple = textFieldAlerta
        }
        alerta.addAction(accionAceptar)
        present(alerta, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tablaApple.delegate = self
        tablaApple.dataSource = self
        leerApple()
    }
    
    func guardar(){
        do {
            try contexto.save()
        } catch {
            print( error.localizedDescription)
        }
        self.tablaApple.reloadData()
    }
    
    func leerApple(){
        let solicitud: NSFetchRequest<Apple> = Apple.fetchRequest()
        do{ listaApple = try contexto.fetch(solicitud)}
        catch {
            print(error.localizedDescription)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Palomear la tarea
        if tablaApple.cellForRow(at: indexPath)?.accessoryType == .checkmark{ tablaApple.cellForRow(at: indexPath)?.accessoryType = .none}
        else{
            tablaApple.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        //Editar en coredata
        listaApple[indexPath.row].estado =
            !listaApple[indexPath.row].estado
        guardar()
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let accionEliminar = UIContextualAction(style:.normal, title: "eliminar"){_,_,_ in self.contexto.delete(self.listaApple[indexPath.row])
            self.listaApple.remove(at: indexPath.row)
            self.guardar()
        }
        accionEliminar.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [accionEliminar])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listaApple.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tablaApple.dequeueReusableCell(withIdentifier: "celda", for: indexPath)
        let tarea = listaApple [indexPath.row]
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
