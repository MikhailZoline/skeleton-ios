![](Assets/header2.jpg)

<p align="center">
    <a href="#-features">Features</a>
  • <a href="#-guides">Guides</a>
  • <a href="#-installation">Installation</a>
  • <a href="#-usage">Usage</a>
  • <a href="#-miscellaneous">Miscellaneous</a>
  • <a href="#️-contributing">Contributing</a>
</p>

Skeleton screens, when used to indicate that a screen is loading, are perceived to be of a shorter duration compared to other loading animations.
Skeleton displays that take advantage of slow, steady movements that move left to right are seen as shorter.
Apple's native skeleton loader already exists in the SkeletonUI framework, but it can only be used in conjunction with the SwiftUI and Combine frameworks.

**This Framework has been cloned from SkeletonView [☠️](https://github.com/Juanpe/SkeletonView)** and ported for use in ObjC as well as Swift View Controls in the Marriott environment .

Enjoy it! 🙂


## 
- [🌟 Features](#-features)
- [✔️ Update](#-Update)
- [📟 Code](#-Code)
- [📲 Install](#-Install)
- [🐒 Usage](#-usage)
  - [🌿 Collections](#-collections)
  - [🔠 Texts](#-texts)
  - [🦋 Appearance](#-appearance)
  - [🎨 Custom colors](#-custom-colors)
  - [ 🏃‍♀️ Animations](#%EF%B8%8F-animations)
  - [🏄 Transitions](#-transitions)
- [✨ Miscellaneous](#-miscellaneous)
- [❤️ Contributing](#️-contributing)



## 🌟 Features

* Usable from Objective-C and Swift
* All skeleton related settings could be defined from Interface Builder
* Usable in existing screens with minimal modifications
* Customizable colors and gradient animations
* Universal (iPhone and iPad)
* Lightweight readable code base

## ✔️ Update

It was decided to use the binary framework in order to integrate the Skeleton library into the Marriott project.
The original source was cloned from here [☠️] (https://github.com/Juanpe/SkeletonView), with the history preserved, then the Marriott-related changes were applied.

1️⃣ If you want to update the Skeleteon code with the original: clone / pull the code from this repository.

2️⃣ Add the original skeleton remote from the repo: git remote add original-skeleton-repo https://github.com/Juanpe/SkeletonView.git

3️⃣ Pull from original remote: git pull original-skeleton-repo

## 📟 Code

1️⃣ If you want to modify the Skeleteon code with your customizations: you can view and test your modifications with SkeletonDemo.xcodeproj in skeleton_ios, then commit and push to the origin.

## 📲 Install

1️⃣ clone / pull the code from this repository to the same folder where the ios folder is located.

2️⃣ cd skeleton_ios

3️⃣ launch the skeleton framework builder: ../ios/Tools/build_skeleton.sh
    This script will build and combine binaries for Simulator and iPhone in one framework,
    it will also copy the newly compiled framework to ios/Marriott/Marriott/Third-Party/Skeleton /
    
4️⃣ commit the modified Skeleton binaries in Marriott: 
    cd ios/
    git add /Marriott/Marriott/Third-Party/Skeleton/*
    git commit -m "Updated Skeleton Framework"

## 🏛️ Architecture

**Skeleton views layout**
Here is an illustration that shows how you should specify which elements are skeletonables when you are using an UITableView:

<img src="Assets/tableview_scheme.png" width="700px">

As you can see, `Skeleton` is selective, so if you don't want to show skeleton in all subviews, then don't mark them. The skeleton layer will then not overlay unspecified subviews and they will be rendered as usual.

📑 **Hierarchy**

Since `Skeleton` is recursive, it will stop looking for `skeletonable` subviews as soon as a view is not `skeletonable`. 
In other words if the parent of the view you want to skeltonize is not flagged `skeletonable` then `Skeleton` will never render it.


## 🐒 Usage


**Skeleton** module is alredy included in Marriott-Prefix.pch and Marriott-Bridging-Header.h


1️⃣ **Using code:**
set which views will be `skeletonables`
```swift
avatarImageView.isSkeletonable = true
```
2️⃣  **Using IB/Storyboards:**

![](Assets/storyboard.png)

3️⃣ Once you've set the views, you can show the **skeleton**. To do so, you have **4** choices:

```swift
(1) view.showSkeleton()                 // Solid
(2) view.showGradientSkeleton()         // Gradient
(3) view.showAnimatedSkeleton()         // Solid animated
(4) view.showAnimatedGradientSkeleton() // Gradient animated
```

**UICollectionView**

For `UICollectionView`, you need to conform to `SkeletonCollectionViewDataSource` protocol.

``` swift
public protocol SkeletonCollectionViewDataSource: UICollectionViewDataSource {
    func numSections(in collectionSkeletonView: UICollectionView) -> Int // default: 1
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier
    func collectionSkeletonView(_ skeletonView: UICollectionView, supplementaryViewIdentifierOfKind: String, at indexPath: IndexPath) -> ReusableCellIdentifier? // default: nil
}
```

The rest of the process is the same as ```UITableView```

### 🌿 Collections

```SkeletonView``` is compatible with ```UITableView``` and ```UICollectionView```.


**UITableView**

If you want to show the skeleton in a ```UITableView```, you need to conform to ```SkeletonTableViewDataSource``` protocol.

``` swift
public protocol SkeletonTableViewDataSource: UITableViewDataSource {
    func numSections(in collectionSkeletonView: UITableView) -> Int
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier
}
```
As you can see, this protocol inherits from ```UITableViewDataSource```, so you can replace this protocol with the skeleton protocol.

This protocol has a default implementation:

``` swift
func numSections(in collectionSkeletonView: UITableView) -> Int
// Default: 1
```

``` swift
func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int
// Default:
// It calculates how many cells need to populate whole tableview
```

There is only one method you need to implement to let Skeleton know the cell identifier. This method doesn't have default implementation:
 ``` swift
 func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier
 ```

**Example**
 ``` swift
 func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
    return "CellIdentifier"
}
 ```
 
Besides, you can skeletonize both the headers and footers. You need to conform to `SkeletonTableViewDelegate` protocol.

```swift
public protocol SkeletonTableViewDelegate: UITableViewDelegate {
    func collectionSkeletonView(_ skeletonView: UITableView, identifierForHeaderInSection section: Int) -> ReusableHeaderFooterIdentifier? // default: nil
    func collectionSkeletonView(_ skeletonView: UITableView, identifierForFooterInSection section: Int) -> ReusableHeaderFooterIdentifier? // default: nil
}
```

> 📣 **IMPORTANT!** 
> 
> 1️⃣ If you are using resizable cells (**`tableView.rowHeight = UITableViewAutomaticDimension`**), it's mandatory define the **`estimatedRowHeight`**.
> 
> 2️⃣ When you add elements in a **`UITableViewCell`** you should add it to **`contentView`** and not to the cell directly.
> ```swift
> self.contentView.addSubview(titleLabel) ✅         
> self.addSubview(titleLabel) ❌
> ```

  



### 🔠 Texts

![](Assets/multilines2.png)

When using elements with text, ```SkeletonView``` draws lines to simulate text.
Besides, you can decide how many lines you want. If  ```numberOfLines``` is set to zero, it will calculate how many lines needed to populate the whole skeleton and it will be drawn. Instead, if you set it to one, two or any number greater than zero, it will only draw this number of lines.

You can set some properties for multilines elements.


| Property | Values | Default | Preview
| ------- | ------- |------- | -------
| **Filling percent** of the last line. | `0...100` | `70%` | ![](Assets/multiline_lastline.png)
| **Corner radius** of lines. (**NEW**) | `0...10` | `0` | ![](Assets/multiline_corner.png)



To modify the percent or radius **using code**, set the properties:
```swift
descriptionTextView.lastLineFillPercent = 50
descriptionTextView.linesCornerRadius = 5
```

Or, if you prefer use **IB/Storyboard**:

![](Assets/multiline_customize.png)


### 🦋 Appearance

The skeletons have a default appearance. So, when you don't specify the color, gradient or multilines properties, `SkeletonView` uses the default values.

Default values:
- **tintColor**: UIColor
    - *default: `.skeletonDefault` (same as `.clouds` but adaptive to dark mode)*
- **gradient**: SkeletonGradient
  - *default: `SkeletonGradient(baseColor: .skeletonDefault)`*
- **multilineHeight**: CGFloat
  - *default: 15*
- **multilineSpacing**: CGFloat
  - *default: 10*
- **multilineLastLineFillPercent**: Int
  - *default: 70*
- **multilineCornerRadius**: Int
  - *default: 0*
- **skeletonCornerRadius**: CGFloat (IBInspectable)  (Make your skeleton view with corner)
  - *default: 0*

To get these default values you can use `SkeletonAppearance.default`. Using this property you can set the values as well:
```swift
SkeletonAppearance.default.multilineHeight = 20
SkeletonAppearance.default.tintColor = .green
```

You can also specifiy these line appearance properties on a per-label basis:
- **lastLineFillPercent**: Int
- **linesCornerRadius**: Int
- **skeletonLineSpacing**: CGFloat
- **skeletonPaddingInsets**: UIEdgeInsets


### 🎨 Custom colors

You can decide which color the skeleton is tinted with. You only need to pass as a parameter the color or gradient you want.

**Using solid colors**
```swift
view.showSkeleton(usingColor: UIColor.gray) // Solid
// or
view.showSkeleton(usingColor: UIColor(red: 25.0, green: 30.0, blue: 255.0, alpha: 1.0))
```
**Using gradients**
``` swift
let gradient = SkeletonGradient(baseColor: UIColor.midnightBlue)
view.showGradientSkeleton(usingGradient: gradient) // Gradient
```

Besides, **SkeletonView** features 20 flat colors 🤙🏼

```UIColor.turquoise, UIColor.greenSea, UIColor.sunFlower, UIColor.flatOrange  ...```

![](Assets/flatcolors.png)
###### Image captured from website [https://flatuicolors.com](https://flatuicolors.com)


### 🏃‍♀️ Animations

**SkeletonView** has two built-in animations, *pulse* for solid skeletons and *sliding* for gradients.

Besides, if you want to do your own skeleton animation, it's really easy.


Skeleton provides the `showAnimatedSkeleton` function which has a ```SkeletonLayerAnimation``` closure where you can define your custom animation.

```swift
public typealias SkeletonLayerAnimation = (CALayer) -> CAAnimation
```

You can call the function like this:

```swift
view.showAnimatedSkeleton { (layer) -> CAAnimation in
  let animation = CAAnimation()
  // Customize here your animation

  return animation
}
```

It's available ```SkeletonAnimationBuilder```. It's a builder to make ```SkeletonLayerAnimation```.

Today, you can create **sliding animations** for gradients, deciding the **direction** and setting the **duration** of the animation (default = 1.5s).

```swift
// func makeSlidingAnimation(withDirection direction: GradientDirection, duration: CFTimeInterval = 1.5) -> SkeletonLayerAnimation

let animation = SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .leftToRight)
view.showAnimatedGradientSkeleton(usingGradient: gradient, animation: animation)

```

```GradientDirection``` is an enum, with theses cases:

|  Direction | Preview
|------- | -------
| .leftRight | ![](Assets/sliding_left_to_right.gif)
| .rightLeft | ![](Assets/sliding_right_to_left.gif)
| .topBottom | ![](Assets/sliding_top_to_bottom.gif)
| .bottomTop | ![](Assets/sliding_bottom_to_top.gif)
| .topLeftBottomRight | ![](Assets/sliding_topLeft_to_bottomRight.gif)
| .bottomRightTopLeft | ![](Assets/sliding_bottomRight_to_topLeft.gif)

> **😉 TRICK!**
>
> Exist another way to create sliding animations, just using this shortcut:
> ```swift
> let animation = GradientDirection.leftToRight.slidingAnimation()
> ```

  

### 🏄 Transitions

**SkeletonView** has built-in transitions to **show** or **hide** the skeletons in a *smoother* way 🤙

To use the transition, simply add the ```transition``` parameter to your ```showSkeleton()``` or ```hideSkeleton()``` function with the transition time, like this:

```swift
view.showSkeleton(transition: .crossDissolve(0.25))     //Show skeleton cross dissolve transition with 0.25 seconds fade time
view.hideSkeleton(transition: .crossDissolve(0.25))     //Hide skeleton cross dissolve transition with 0.25 seconds fade time

```

The default value is  `crossDissolve(0.25)`

**Preview**

<table>
<tr>
<td width="50%">
<center>None</center>
</td>
<td width="50%">
<center>Cross dissolve</center>
</td>
</tr>
<tr>
<td width="50%">
<img src="Assets/skeleton_transition_nofade.gif"></img>
</td>
<td width="50%">
<img src="Assets/skeleton_transition_fade.gif"></img>
</td>
</tr>
</table>


## ✨ Miscellaneous 

  

**Hierarchy**

Since ```SkeletonView``` is recursive, and we want skeleton to be very efficient, we want to stop recursion as soon as possible. For this reason, you must set the container view as `Skeletonable`, because Skeleton will stop looking for `skeletonable` subviews as soon as a view is not Skeletonable, breaking then the recursion.

Because an image is worth a thousand words:

In this example we have a `UIViewController` with a `ContainerView` and a `UITableView`. When the view is ready, we show the skeleton using this method:
```
view.showSkeleton()
```

> ```isSkeletonable```= ☠️

| Configuration | Result|
|:-------:|:-------:|
|<img src="Assets/no_skeletonable.jpg" width="350"/> | <img src="Assets/no_skeletonables_result.png" width="350"/>|
|<img src="Assets/container_no_skeletonable.jpg" width="350"/> | <img src="Assets/no_skeletonables_result.png" width="350"/>|
|<img src="Assets/container_skeletonable.jpg" width="350"/> | <img src="Assets/container_skeletonable_result.png" width="350"/>|
|<img src="Assets/all_skeletonables.jpg" width="350"/>| <img src="Assets/all_skeletonables_result.png" width="350"/>|
|<img src="Assets/tableview_no_skeletonable.jpg" width="350"/> | <img src="Assets/tableview_no_skeletonable_result.png" height="350"/>|
|<img src="Assets/tableview_skeletonable.jpg" width="350"/> | <img src="Assets/tableview_skeletonable_result.png" height="350"/>|

  

**Hierarchy in collections**

Here is an illustration that shows how you should specify which elements are skeletonables when you are using an `UITableView`:

<img src="Assets/tableview_scheme.png" width="700px">

As you can see, we have to make skeletonable the tableview, the cell and the UI elements, but we don't need to set as skeletonable the `contentView`

  

**Skeleton views layout**

Sometimes skeleton layout may not fit your layout because the parent view bounds have changed. ~For example, rotating the device.~

You can relayout the skeleton views like so:

```swift
override func viewDidLayoutSubviews() {
    view.layoutSkeletonIfNeeded()
}
```

> 📣 **IMPORTANT!** 
> 
> You shouldn't call this method. From **version 1.8.1** you don't need to call this method, the library does automatically. So, you can use this method **ONLY** in the cases when you need to update the layout of the skeleton manually.


  

**Update skeleton**

You can change the skeleton configuration at any time like its colour, animation, etc. with the following methods:

```swift
(1) view.updateSkeleton()                 // Solid
(2) view.updateGradientSkeleton()         // Gradient
(3) view.updateAnimatedSkeleton()         // Solid animated
(4) view.updateAnimatedGradientSkeleton() // Gradient animated
```


**Debug**

To facilitate the debug tasks when something is not working fine. **`SkeletonView`** has some new tools.

First, `UIView` has available a new property with his skeleton info:
```swift
var skeletonDescription: String

```
The skeleton representation looks like this:

![](Assets/debug_description.png)

Besides, you can activate the new **debug mode**. You just add the environment variable `SKELETON_DEBUG` and activate it.

![](Assets/debug_mode.png)

Then, when the skeleton appears, you can see the view hierarchy in the Xcode console.

<details>
<summary>Open to see an output example </summary>
<img src="Assets/hierarchy_output.png" />
</details>

  
**Supported OS & SDK Versions**

* from iOS 9.0
* Swift 5


