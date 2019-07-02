////
////  UITableViewTemplate.swift
////  MusicRadio
////
////  Created by Admin on 10/16/18.
////  Copyright © 2018 HCM. All rights reserved.
////
//
//import UIKit
//
//class SearchSuggestViewController: UIViewController {
//
//    @IBOutlet weak var tableView: UITableView!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        tableView.register(UINib(nibName: SearchSuggestCell.className, bundle: nil), forCellReuseIdentifier: SearchSuggestCell.className)
//        tableView.delegate = self
//        tableView.dataSource = self
//    }
//}
//
//extension SearchSuggestViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: SearchSuggestCell.className, for: indexPath) as! SearchSuggestCell
//
//        return cell
//    }
//
//    // optional
//    func numberOfSections(in tableView: UITableView) -> Int {
//
//    }
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//
//    }
//    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
//
//    }
//
//    // Editing
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//
//    }
//    // Moving/reordering
//    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
//
//    }
//
//    // Index
//    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
//
//    }
//    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
//
//    }
//
//    // Data manipulation - insert and delete support
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//
//    }
//
//    // Data manipulation - reorder / moving support
//    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
//
//    }
//}
//
//extension SearchSuggestViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//
//    }
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//
//    }
//
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//
//    }
//
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//
//    }
//
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//
//    }
//}
//
