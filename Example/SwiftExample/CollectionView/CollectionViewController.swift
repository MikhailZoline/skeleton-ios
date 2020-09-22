// CollectionViewController.swift
//

import UIKit
import SkeletonView

class CollectionViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.isSkeletonable = true
            collectionView.backgroundColor = .clear
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.showsVerticalScrollIndicator = false
            
            collectionView.dataSource = self
            collectionView.delegate = self
            
            collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
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
            colorSelectedView.backgroundColor = Colors.color(0)
            colorSelectedView.tintColor = Colors.color(1)
        }
    }
    
    @IBOutlet weak var switchAnimated: UISwitch!
    @IBOutlet weak var skeletonTypeSelector: UISegmentedControl!
    @IBOutlet weak var showOrHideSkeletonButton: UIButton!
    @IBOutlet weak var transitionDurationLabel: UILabel!
    @IBOutlet weak var transitionDurationStepper: UIStepper!
    
    var secondaryColor: UIColor = SkeletonAppearance.shared.tintColor
    
    var type: SkeletonType {
        return SkeletonType(solidOrGradient: skeletonTypeSelector.selectedSegmentIndex == 0 ?  SkeletonType.solid : SkeletonType.gradient)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        transitionDurationStepper.value = 0.25
        collectionView.prepareSkeleton { (done) in
            self.view.showAnimatedGradientSkeleton()
        }
    }
    
    class var defaultAnim: SkeletonLayerAnimation {
        get {
            let animBuilder  = GradientDirection(direction: GradientDirection.bottomRightTopLeft)
            return animBuilder.slidingAnimation()
        }
    }
    
    @IBAction func changeAnimated(_ sender: Any) {
        if switchAnimated.isOn {
            view.startSkeletonAnimation( CollectionViewController.defaultAnim)
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
}

// MARK: - UIPickerViewDelegate, UIPickerViewDataSource

extension CollectionViewController: UIPickerViewDelegate, UIPickerViewDataSource {
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

// MARK: - UICollectionViewDelegateFlowLayout

extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width/3 - 10, height: view.frame.width/3 - 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 7, bottom: 0, right: 7)
    }
}

// MARK: - SkeletonCollectionViewDataSource

extension CollectionViewController: SkeletonCollectionViewDataSource {
    func collectionSkeletonView(_ skeletonView: UICollectionView,
                                supplementaryViewIdentifierOfKind: String,
                                at indexPath: IndexPath) -> ReusableCellIdentifier? {
        return nil
    }
    
    func numSections(in collectionSkeletonView: UICollectionView) -> Int { return 1 }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "CollectionViewCell"
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        return cell
        
    }
}

