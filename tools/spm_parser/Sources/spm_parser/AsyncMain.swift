import ArgumentParser

@main
enum AsyncMain {
    static func main() async {
        await Dump.main()
    }
}
