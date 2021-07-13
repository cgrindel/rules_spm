import CNIOSHA1

var sha1Ctx: SHA1_CTX = SHA1_CTX()
c_nio_sha1_init(&sha1Ctx)

Swift.print("*** CHUCK  sha1Ctx: \(String(reflecting: sha1Ctx))")
