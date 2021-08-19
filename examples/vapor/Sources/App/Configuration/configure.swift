import Fluent
import FluentSQLiteDriver
import Vapor

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    app.databases.use(.sqlite(.memory), as: .sqlite)
    app.migrations.add(CreateFooTable(), to: .sqlite)
    // Make sure that the database is fully migrated.
    try app.autoMigrate().wait()

    // register routes
    try routes(app)
}
