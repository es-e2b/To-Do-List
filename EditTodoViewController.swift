import UIKit

class EditTodoViewController: UIViewController {
    
    var todo: Todo?
    var didUpdateTodo: ((Todo) -> Void)?
    
    let stackView = UIStackView()
    let titleLabel = UILabel()
    let titleTextField = UITextField()
    let dateLabel = UILabel()
    let datePicker = UIDatePicker()
    let saveButton = UIButton()
    let cancelButton = UIButton() // Cancel Button 추가
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        // Title Label
        titleLabel.text = "Edit Todo"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Title Text Field
        titleTextField.text = todo?.title
        titleTextField.borderStyle = .roundedRect
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        
        // Date Label
        dateLabel.text = "Select Date and Time:"
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Date Picker
        datePicker.datePickerMode = .dateAndTime
        datePicker.date = todo?.date ?? Date()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        // Save Button
        saveButton.setTitle("Save", for: .normal)
        saveButton.backgroundColor = .systemBlue
        saveButton.layer.cornerRadius = 10
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Cancel Button 설정
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.backgroundColor = .lightGray
        cancelButton.layer.cornerRadius = 10
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Stack View
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(titleTextField)
        stackView.addArrangedSubview(dateLabel)
        stackView.addArrangedSubview(datePicker)
        stackView.addArrangedSubview(saveButton)
        stackView.addArrangedSubview(cancelButton) // Cancel Button 추가
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            saveButton.heightAnchor.constraint(equalToConstant: 50),
            cancelButton.heightAnchor.constraint(equalToConstant: 50) // Cancel Button 높이 제약 추가
        ])
    }
    
    @objc func saveButtonTapped() {
        guard let title = titleTextField.text, !title.isEmpty else {
            displayError(message: "Title cannot be empty.")
            return
        }
        
        let selectedDate = datePicker.date
        var updatedTodo = todo ?? Todo(title: "", date: Date(), isCompleted: false)
        updatedTodo.title = title
        updatedTodo.date = selectedDate
        
        didUpdateTodo?(updatedTodo)
        dismiss(animated: true, completion: nil)
    }
    
    @objc func cancelButtonTapped() {
        dismiss(animated: true, completion: nil) // 취소 버튼 클릭 시 이전 화면으로 돌아가기
    }
    
    func displayError(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
