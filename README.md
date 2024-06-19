[Youtube Link]
- https://youtu.be/4hpoUZAF7h0

To-do List 어플입니다.

간단한 조작으로 할 일을 추가할 수 있고, 할 일을 수행했는지 체크할 수 있습니다.

우측에서 좌측으로 스와이프를 통해 수정 및 삭제도 간편하게 할 수 있습니다.

ViewController를 통해 메인 화면에서 동적으로 타이틀 및 To-do 아이템의 유무룰 확인합니다.

만약 아이템이 존재하지 않을 시 'No To-Do items'라는 텍스트를 띄웁니다.

플로팅 버튼을 우측 하단에 생성하고, 해당 버튼을 통해 새로운 할 일을 추가합니다.

버튼을 클릭하면 AddTodoViewController를 통해 뷰를 생성합니다.

AddTodoViewController에서는 타이틀, 날짜 선택 버튼, 시간 선택 버튼을 동적으로 생성합니다.

Add 버튼과 Cancle 버튼을 통해 할 일을 추가하거나 동작 취소를 할 수 있습니다.

할 일이 추가되면, ViewController의

```
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: "Edit") { [weak self] (action, view, completionHandler) in
            self?.editTodo(at: indexPath)
            completionHandler(true)
        }
        editAction.backgroundColor = UIColor(named: "editActionColor") ?? .blue
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, completionHandler) in
            self?.deleteTodo(at: indexPath)
            completionHandler(true)
        }
        deleteAction.backgroundColor = UIColor(named: "deleteActionColor") ?? .red
        
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
```
부분을 통해 스와이프로 Edit 또는 Delete 버튼을 띄울 수 있습니다.

Edit 버튼을 클릭하면 마찬가지로

EditTodoViewController를 통해 뷰를 생성합니다.

뷰에는 기존의 정보가 반영돼있고, 정보를 수정할 수 있습니다.
