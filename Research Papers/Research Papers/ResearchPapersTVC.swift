//
//  ResearchPapersTVC.swift
//  Research Papers
//
//  Created by Mateusz Golebiowski on 22/11/2022.
//

import UIKit

class ResearchPapersTVC: UITableViewController {
    
    var reports: technicalReports? = nil
    var curRow = 0
    
    @IBOutlet var theTable: UITableView!
    
    func updateTheTable() {
        theTable.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        curRow = indexPath.row
        performSegue(withIdentifier: "toDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! ViewController
        
        vc.paperTitle = reports?.techreports2[curRow].title ?? "No Title"
        vc.year = reports?.techreports2[curRow].year ?? "No Year"
        vc.author = reports?.techreports2[curRow].authors ?? "No Author(s)"
        vc.email = reports?.techreports2[curRow].email ?? "No Email"
        vc.abstract = reports?.techreports2[curRow].abstract ?? "No Abstract"
        vc.url = reports?.techreports2[curRow].pdf
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = URL(string: "https://cgi.csc.liv.ac.uk/~phil/Teaching/COMP228/techreports/data.php?class=techreports2") {
            let session = URLSession.shared
            session.dataTask(with: url) { (data, response, err) in
            guard let jsonData = data else {
                return
            }
            do {
                let decoder = JSONDecoder()
                let reportList = try decoder.decode(technicalReports.self, from: jsonData)
                self.reports = reportList
                DispatchQueue.main.async {
                    self.updateTheTable()
                }
                var count = 0
                for aReport in reportList.techreports2 {
                    count += 1
                    print("\(count) " + aReport.title) }
                } catch let jsonErr {
                    print("Error decoding JSON", jsonErr)
                }
            }.resume()
                print("You are here!")
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return reports?.techreports2.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "theCell", for: indexPath)
        var content = UIListContentConfiguration.cell()
        content.text = reports?.techreports2[indexPath.row].title ?? "No Title"
        content.secondaryText = reports?.techreports2[indexPath.row].authors ?? "No Authors"
        cell.contentConfiguration = content
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
