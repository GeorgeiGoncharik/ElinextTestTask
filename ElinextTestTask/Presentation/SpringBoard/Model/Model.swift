import Foundation

struct Model: Hashable {
    let id = UUID().uuidString
    let imageURL: URL?
    /**
     https://loremflickr.com
     Take some control of the image that's displayed. Include a lock query string parameter and give it a value that's a positive integer.
     While our cache is not updated, and sometimes for longer, the same image will be returned by our server.
     */
    init() {
        let queryItems = [URLQueryItem(name: "lock", value: id)]
        var urlComps = URLComponents(string: "http://loremflickr.com/200/200")!
        urlComps.queryItems = queryItems
        self.imageURL = urlComps.url
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
