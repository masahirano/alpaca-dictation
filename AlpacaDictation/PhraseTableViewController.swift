//
//  PhraseTableViewController.swift
//  AlpacaDictation
//
//  Created by Masataka Hirano on 2017/08/01.
//  Copyright © 2017 Masataka Hirano. All rights reserved.
//

import UIKit
import Photos
import RealmSwift

class PhraseTableViewController: UITableViewController {
    
    var assets: Array<Phrase>?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem

        // search Album and set to property
        assets = fetchPhrases()
    }

    private func fetchPhrases() -> Array<Phrase> {
        let realm = try! Realm()

        return Array(realm.objects(Phrase.self))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assets!.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "PhraseTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? PhraseTableViewCell else {
            fatalError("piyo")
        }
        guard let phrase = assets?[indexPath.row] else {
            return cell
        }

        cell.titleLabel.text = phrase.phAssetidentifier
        phrase.setThumbnail(to: cell.photoImageView)

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let phrase = assets![indexPath.row]
            let asset = phrase.getPHAsset()
            if asset.canPerform(PHAssetEditOperation.delete) {
                PHPhotoLibrary.shared().performChanges({
                    let assetsWillDelete: NSArray = [asset]
                    PHAssetChangeRequest.deleteAssets(assetsWillDelete)
                }, completionHandler: { (isSuccess, error) in
                    if isSuccess {
                        self.assets!.remove(at: indexPath.row)
                    } else {
                        // TODO: implement someday
                    }
                })
            } else {
                // TODO: implement someday
            }
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }

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

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        switch segue.identifier ?? "" {
        case "ShowDetail":
            guard let viewController = segue.destination as? ViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let selectedPhraseCell = sender as? PhraseTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            guard let indexPath = tableView.indexPath(for: selectedPhraseCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            guard let phrase = assets?[indexPath.row] else {
                fatalError("piyo")
            }
            viewController.phrase = phrase
        case "StartVideoRecording":
            print("start to record video")
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }

}
