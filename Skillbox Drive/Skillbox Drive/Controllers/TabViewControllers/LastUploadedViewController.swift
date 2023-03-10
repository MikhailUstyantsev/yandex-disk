//
//  RecentlyLoadItemsViewController.swift
//  Skillbox Drive
//
//  Created by Mikhail Ustyantsev on 23.09.2022.
//

import UIKit

class LastUploadedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let defaults = UserDefaults.standard
    
    private var isFirst = true
    //    в случае если токен пустой, будем запрашивать новый (см. функцию updateData)
    private var token: String = ""
    private var filesData: YDGetLastUploadedResponse?
    private var recentlyLoadImages: [UIImage] = []
    
    let tableView: UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .plain)
        table.register(LastLoadedTableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupViews()
        token = defaults.object(forKey: "token") as? String ?? ""
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isFirst {
            updateData()
        }
        isFirst = false
    }
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        
        tableView.rowHeight = 80
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LastLoadedTableViewCell
        
        guard let items = filesData?.items, items.count > indexPath.row else { return cell }
        
        let currentFile = items[indexPath.row]
        
        //TODO: Создать вьюмодель ячейки и перенести всю работу с данными туда
        
        cell.headerLabel.text = currentFile.name
        
        let createdDate = Date.createDateFromString(dateString: currentFile.created ?? "")
        
        let dateToShowInCell = Date.createStringFromDate(date: createdDate)
        
        cell.bodyLabel.text = dateToShowInCell
        
        guard let url = URL(string: currentFile.preview ?? "") else { return cell }
        
        cell.cellImageView.loadImageWithUrl(url, token)

        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filesData?.items?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    private func updateData() {
        guard !token.isEmpty else {
            //            чтобы получить новый токен, нам нужно открыть контроллер с вебвью
            //            let requestTokenViewController = AuthViewController()
            //            реализуем протокол делегирования
            //            requestTokenViewController.delegate = self
            //            present(requestTokenViewController, animated: false, completion: nil)
            return
        }
        //       MARK: - Load disk images
        //запрос последних загруженных файлов
        
        //плоский список всех файлов
        var components = URLComponents(string: "https://cloud-api.yandex.net/v1/disk/resources/files")
        //        установим параметр для указания типа запрашиваемых файлов с диска
        // так мы указали, что хотим получить только изображения
        components?.queryItems = [URLQueryItem(name: "media_type", value: "image")]
        
        //        получаем объект класса  URL
        guard let url = components?.url else { return }
        //         нам необходимо указать заголовок authorization в котром мы должны отправить токен, чтобы API диска разрешила нам получить пользовательские данные
        //        Поэтому создаем объект класса URLRequest и создаем необходимый нам заголовок с токеном
        var request = URLRequest(url: url)
        request.setValue("OAuth \(token)", forHTTPHeaderField: "Authorization")
        //  используем полученный запрос для создания data task
        let task = URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            // научимся извлекать объекты из ответа сервера - необходимо еще раз посмотреть документацию
            guard let sself = self, let data = data else { return }
            guard let newFiles = try? JSONDecoder().decode(YDGetLastUploadedResponse.self, from: data) else { return }
            print("Received: \(newFiles.items?.count ?? 0) files")
            sself.filesData = newFiles
            
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
        task.resume()
    }
    
    
    
}


extension LastUploadedViewController: AuthViewControllerDelegate {
    
    func handleTokenChanged(token: String) {
        //        сохраним токен и обновим данные
        self.token = token
        print("New token: \(token)")
        updateData()
    }
    
    
    
    func loadImage(stringUrl: String, completion: @escaping ((UIImage?) -> Void)) {
        // снова создаем запрос, в котором указываем заголовок с токеном, поскольку картинки хранятся на диске
        guard let url = URL(string: stringUrl) else { return }
        var request = URLRequest(url: url)
        request.setValue("OAuth \(token)", forHTTPHeaderField: "Authorization")
        
        //        далее пишем код для загрузки картинки из сети
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            DispatchQueue.main.async {
                guard let image = UIImage(data: data) else {
                    completion(nil)
                    return
                }
                completion(image)
            }
        }
        task.resume()
    }
    
    
    
}
