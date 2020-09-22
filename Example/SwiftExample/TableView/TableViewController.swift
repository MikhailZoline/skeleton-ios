//
//  ViewController.swift
//  SkeletonViewExample
//
//  Created by Juanpe Catalán on 02/11/2017.
//  Copyright © 2017 SkeletonView. All rights reserved.
//

import UIKit
import SkeletonView

class TableViewController: UIViewController {
    @IBOutlet weak var tableview: UITableView! {
        didSet {
            tableview.rowHeight = UITableView.automaticDimension
            tableview.sectionHeaderHeight = UITableView.automaticDimension
            tableview.sectionFooterHeight = UITableView.automaticDimension
            tableview.estimatedRowHeight = 120.0
            tableview.estimatedSectionFooterHeight = 20.0
            tableview.estimatedSectionHeaderHeight = 20.0
            tableview.register(HeaderFooterSection.self, forHeaderFooterViewReuseIdentifier: "HeaderIdentifier")
            tableview.register(HeaderFooterSection.self, forHeaderFooterViewReuseIdentifier: "FooterIdentifier")
        }
    }
    
    @IBOutlet weak var avatarImage: UIImageView! {
        didSet {
            avatarImage.layer.cornerRadius = avatarImage.frame.width/2
            avatarImage.layer.masksToBounds = true
        }
    }
    
    @IBOutlet weak var colorSelectedView: UIView! {
        didSet {
            colorSelectedView.layer.cornerRadius = 5
            colorSelectedView.layer.masksToBounds = true
            colorSelectedView.backgroundColor = SkeletonAppearance.shared.tintColor
        }
    }

    @IBOutlet weak var switchAnimated: UISwitch!
    @IBOutlet weak var skeletonTypeSelector: UISegmentedControl!
    @IBOutlet weak var showOrHideSkeletonButton: UIButton!
    @IBOutlet weak var transitionDurationLabel: UILabel!
    @IBOutlet weak var transitionDurationStepper: UIStepper!
    
    var type: SkeletonType {
        return SkeletonType(solidOrGradient: skeletonTypeSelector.selectedSegmentIndex == 0 ?  SkeletonType.solid : SkeletonType.gradient)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        transitionDurationStepper.value = 0.25
        self.view.showAnimatedGradientSkeleton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    //(CALayer) -> CAAnimation
    class var defaultAnim: SkeletonLayerAnimation {
        get {
            let animBuilder  = GradientDirection(direction: GradientDirection.topLeftBottomRight)
            return animBuilder.slidingAnimation()
        }
    }

    @IBAction func changeAnimated(_ sender: Any) {
        if switchAnimated.isOn {
            view.startSkeletonAnimation(TableViewController.defaultAnim)
        } else {
            view.stopSkeletonAnimation()
        }
    }
    
    @IBAction func changeSkeletonType(_ sender: Any) {
        if self.view.isSkeletonActive {
            self.hideSkeleton()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.showSkeleton()
            }
        }
    }
    
    @IBAction func btnChangeColorTouchUpInside(_ sender: Any) {
        showAlertPicker()
    }
    
    @IBAction func showOrHideSkeleton(_ sender: Any) {
        showOrHideSkeletonButton.setTitle((view.isSkeletonActive ? "Show skeleton" : "Hide skeleton"), for: .normal)
        view.isSkeletonActive ? hideSkeleton() : showSkeleton()
    }
    
    @IBAction func transitionDurationStepperAction(_ sender: Any) {
        transitionDurationLabel.text = NSString(format:"Fade duration: %.2f s", transitionDurationStepper.value) as String
        if view.isSkeletonActive { showSkeleton() }
    }
    
    func showSkeleton() {
        if type.isGardient { showGradientSkeleton() }
        else { showSolidSkeleton() }
    }

    func hideSkeleton() {
        view.hideSkeleton(transition: SkeletonTransitionStyle(transitionDurationStepper.value))
    }
    
    func showSolidSkeleton() {
        if switchAnimated.isOn {
            view.showAnimatedSkeleton(usingColor: colorSelectedView.backgroundColor!, transition: SkeletonTransitionStyle(transitionDurationStepper.value))
        } else {
            view.showSkeleton(usingColor: colorSelectedView.backgroundColor!, transition: SkeletonTransitionStyle(transitionDurationStepper.value))
        }
    }
    
    func showGradientSkeleton() {
        let gradient = SkeletonGradient(baseColor: colorSelectedView.backgroundColor!, secondaryColor: colorSelectedView.tintColor)
        if switchAnimated.isOn {
            view.showAnimatedGradientSkeleton(usingGradient: gradient, transition: SkeletonTransitionStyle(transitionDurationStepper.value))
        } else {
            view.showGradientSkeleton(usingGradient: gradient, transition: SkeletonTransitionStyle(transitionDurationStepper.value))
        }
    }
    
    func showAlertPicker() {
        let alertView = UIAlertController(title: "Select color", message: "\n\n\n\n\n\n", preferredStyle: .alert)
        
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 50, width: 260, height: 115))
        pickerView.dataSource = self
        pickerView.delegate = self
        
        alertView.view.addSubview(pickerView)
        
        let action = UIAlertAction(title: "OK", style: .default) { [unowned pickerView, unowned self] _ in
            let row = pickerView.selectedRow(inComponent: 0)
            self.colorSelectedView.backgroundColor = Colors.color(row)
            self.colorSelectedView.tintColor = Colors.color(row+1 < Colors.count ?  row+1 : 0 )
            if self.view.isSkeletonActive {
                self.hideSkeleton()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.showSkeleton()
                }
            }
        }
        alertView.addAction(action)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertView.addAction(cancelAction)
        
        present(alertView, animated: false, completion: {
            pickerView.frame.size.width = alertView.view.frame.size.width
        })
    }
    
    static var lorem = String("Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.").components(separatedBy: .whitespaces)
    static var currIdx = 0
}

extension TableViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
       return Colors.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Colors.title(row)
    }
}

extension TableViewController: SkeletonTableViewDataSource {

    @objc func numSections(in collectionSkeletonView: UITableView) -> Int {
        return 1
    }
    @objc func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return 10
    }
    @objc func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "CellIdentifier"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath) as! Cell
        cell.label1.text = TableViewController.lorem[indexPath.row]
        if let header = tableView.headerView(forSection: indexPath.section) {
            (header as! HeaderFooterSection).titleLabel.text = TableViewController.lorem[indexPath.row]
        }
        if let header = tableView.headerView(forSection: indexPath.section) {
            (header as! HeaderFooterSection).titleLabel.text = TableViewController.lorem[indexPath.row > 1 ? indexPath.row - 2 : indexPath.row ]
        }
        if let footer = tableView.footerView(forSection: indexPath.section) {
            (footer as! HeaderFooterSection).titleLabel.text = TableViewController.lorem[indexPath.row < TableViewController.lorem.count ? indexPath.row + 1 : indexPath.row ]
        }
        return cell
    }
}

extension TableViewController: SkeletonTableViewDelegate {
    func collectionSkeletonView(_ skeletonView: UITableView, identifierForHeaderInSection section: Int) -> ReusableHeaderFooterIdentifier? {
        return "HeaderIdentifier"
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView
            .dequeueReusableHeaderFooterView(withIdentifier: "HeaderIdentifier") as! HeaderFooterSection
        header.titleLabel.text =  TableViewController.lorem[0]
        return header
    }

    func collectionSkeletonView(_ skeletonView: UITableView, identifierForFooterInSection section: Int) -> ReusableHeaderFooterIdentifier? {
        return "FooterIdentifier"
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = tableView
            .dequeueReusableHeaderFooterView(withIdentifier: "FooterIdentifier") as! HeaderFooterSection
        footer.titleLabel.text = TableViewController.lorem[2]
        return footer
    }
}
