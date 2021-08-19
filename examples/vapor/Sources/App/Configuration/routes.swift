import App_Models
import Vapor

enum AppError: Error {
    case missingName
}

func routes(_ app: Application) throws {
    app.get { _ in
        "It works!"
    }

    app.get("hello", ":name") { req -> String in
        guard let name = req.parameters.get("name") else {
            throw AppError.missingName
        }

        let foo = Foo()
        foo.name = name
        // do {
        //     try foo.save(on: app.db).wait()
        // } catch {
        //     // DEBUG BEGIN
        //     Swift.print("*** CHUCK  error: \(String(reflecting: error))")
        //     // DEBUG END
        //     throw error
        // }

        return "Hello, \(name)!"
    }
}
