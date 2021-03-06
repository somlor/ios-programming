//
//  DetailViewController.swift
//  HomePwner
//
//  Created by sean on 4/5/17.
//  Copyright © 2017 sean. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController,
  UITextFieldDelegate,
  UINavigationControllerDelegate,
  UIImagePickerControllerDelegate {

  // MARK: - Properties

  var item: Item! {
    didSet {
      navigationItem.title = item.name
    }
  }
  var imageStore: ImageStore!

  @IBOutlet var nameField: UITextField!
  @IBOutlet var serialNumberField: UITextField!
  @IBOutlet var valueField: UITextField!
  @IBOutlet var dateLabel: UILabel!
  @IBOutlet var imageView: UIImageView!

  // MARK: - Actions

  @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
    view.endEditing(true)
  }

  @IBAction func takePicture(_ sender: UIBarButtonItem) {
    let imagePicker = UIImagePickerController()
    if UIImagePickerController.isSourceTypeAvailable(.camera) {
      imagePicker.sourceType = .camera
    } else {
      imagePicker.sourceType = .photoLibrary
    }
    imagePicker.delegate = self
    present(imagePicker, animated: true, completion: nil)
  }

  // MARK: - Delegates

  func imagePickerController(
    _ picker: UIImagePickerController,
    didFinishPickingMediaWithInfo info: [String : Any]
  ) {
    // get picked image from info dictionary
    let image = info[UIImagePickerControllerOriginalImage] as! UIImage

    // store the image in the image store
    imageStore.setImage(image, forKey: item.itemKey)

    // put the image on the screen in the image view
    imageView.image = image

    // take image picker off the screen
    dismiss(animated: true, completion: nil)
  }

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }

  // MARK: - View lifecycle
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    view.endEditing(true)
    updateItem()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    nameField.text = item.name
    serialNumberField.text = item.serialNumber
    valueField.text = Helpers.numberFormatter.string(
      from: NSNumber(value: item.valueInDollars)
    )
    dateLabel.text = Helpers.dateFormatter.string(from: item.dateCreated)

    // TODO: this is expensive in that it tries to find image in cache and disk
    // maybe an optimization could be to have an item.hasImage boolean?
    imageView.image = imageStore.getImage(forKey: item.itemKey)
  }

  // MARK: - Private

  private func updateItem() {
    item.name = nameField.text ?? ""
    item.serialNumber = serialNumberField.text

    if let valueText = valueField.text,
      let value = Double(valueText) {
      item.valueInDollars = value
    } else {
      item.valueInDollars = 0
    }
  }
}
