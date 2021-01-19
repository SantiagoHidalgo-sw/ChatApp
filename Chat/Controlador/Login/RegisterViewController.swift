

import UIKit
import FirebaseAuth


class RegisterViewController: UIViewController {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    
    private let imageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.circle")
        imageView.tintColor = .gray
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        return imageView
        
    }()
    
    private let nameField: UITextField = {
        let field = UITextField()
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "  Nombre"
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        return field
    }()
    
    private let lastNameField: UITextField = {
        let field = UITextField()
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "  Apellido"
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        return field
    }()
    
    private let emailField: UITextField = {
        let field = UITextField()
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "  E-mail.."
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        return field
    }()
    
    private let passField: UITextField = {
        let field = UITextField()
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.returnKeyType = .done
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "  Contraseña.."
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        field.isSecureTextEntry = true
        return field
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Registrarse", for: .normal)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 14
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Log In"
        view.backgroundColor = .white
        
        
        
        
        loginButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        
        emailField.delegate = self
        passField.delegate = self
        
        
        // Subvistas
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(nameField)
        scrollView.addSubview(lastNameField)
        scrollView.addSubview(emailField)
        scrollView.addSubview(passField)
        scrollView.addSubview(loginButton)
        
        imageView.isUserInteractionEnabled = true
        scrollView.isUserInteractionEnabled = true
        
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapChange))
        imageView.addGestureRecognizer(gesture)
        
    }
    
    
    @objc private func didTapChange() {
        presentPhotoActionSheet()
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        
        let size = scrollView.width/3
        imageView.frame = CGRect(x: (scrollView.width-size)/2,
                                 y: 20,
                                 width: size,
                                 height: size)
        imageView.layer.cornerRadius = imageView.width/2.0
        
        nameField.frame = CGRect(x: 30,
                                 y: imageView.bottom+10,
                                 width: scrollView.width-60,
                                 height: 52)
        lastNameField.frame = CGRect(x: 30,
                                     y: nameField.bottom+10,
                                     width: scrollView.width-60,
                                     height: 52)
        emailField.frame = CGRect(x: 30,
                                  y: lastNameField.bottom+10,
                                  width: scrollView.width-60,
                                  height: 52)
        passField.frame = CGRect(x: 30,
                                 y: emailField.bottom+10,
                                 width: scrollView.width-60,
                                 height: 52)
        loginButton.frame = CGRect(x: 30,
                                   y: passField.bottom+10,
                                   width: scrollView.width-60,
                                   height: 52)
        
        
    }
    
    
    @objc private func registerButtonTapped(){
        
        emailField.resignFirstResponder()
        passField.resignFirstResponder()
        nameField.resignFirstResponder()
        lastNameField.resignFirstResponder()
        
        
        
        guard let email = emailField.text, let password = passField.text, !email.isEmpty, !password.isEmpty , password.count >= 6, let nombre = nameField.text, let apellido = lastNameField.text, !apellido.isEmpty, !nombre.isEmpty else {
            alertUserLoginError()
            return
        }
        
        //Firebase
        
        DatabaseManager.shared.userExist(with: email, completion: {[weak self] exists in
            guard let strongSelf = self else{
                return
            }
            
            guard !exists else {
                strongSelf.alertUserLoginError(message: "La cuenta ya existe")
                return
            }
            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password, completion: { authResult, error in
                guard let strongSelf = self else{
                    
                    return
                }
                guard authResult != nil,error == nil else {
                    print("error")
                    return
                    
                }
                
                DatabaseManager.shared.insertUser(with: UsuarioChat(nombre:nombre
                                                                    ,apellido: apellido,   emailAddres: email))
                
                strongSelf.navigationController?.dismiss(animated: true, completion: nil)
                
            })
        })
        
        
        
        
        
        
    }
    
    func alertUserLoginError(message: String = "Ingrese toda la info") {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Quitar", style: .cancel, handler: nil))
        present(alert,animated: true)
        
    }
    
    
    @objc private func didTapRegister(){
        let vc = RegisterViewController()
        vc.title = "Crear Cuenta"
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
}

extension RegisterViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField {
            passField.becomeFirstResponder()
        }
        else if textField == passField {
            registerButtonTapped()
        }
        return true
    }
}


extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    func presentPhotoActionSheet(){
        
        let actionSheet = UIAlertController(title: "Foto de perfil", message: "Como prefieres seleccionar la foto", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Cancelar",
                                            style: .cancel,
                                            handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Tomar foto",
                                            style: .default,
                                            handler: {[weak self]_ in self?.presentCamera()}))
        actionSheet.addAction(UIAlertAction(title: "Elegir Foto",
                                            style: .default,
                                            handler: {[weak self] _ in self?.presentPhotos()}))
        
        present(actionSheet,animated: true)
        
    }
    
    func presentCamera() {
        
        let camara = UIImagePickerController()
        camara.sourceType = .camera
        camara.delegate = self
        camara.allowsEditing = true
        present(camara, animated: true)
        
    }
    
    func presentPhotos(){
        
        let camara = UIImagePickerController()
        camara.sourceType = .photoLibrary
        camara.delegate = self
        camara.allowsEditing = true
        present(camara, animated: true)
        
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        
        self.imageView.image = selectedImage
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    
    
}
