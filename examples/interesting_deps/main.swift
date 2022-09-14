import libwebp
import Logging
import Auth0

let logger = Logger(label: "com.example.main")
logger.info("Hello World!")

let webpVersion = WebPGetDecoderVersion()
logger.info("WebP version: \(webpVersion)")

let webAuth = Auth0.webAuth()