# Vapor Example for `rules_spm`

[Vapor](https://github.com/vapor/vapor) is a popular web framework for Swift. It is composed of many
Swift and Clang dependencies. Some of their Clang modules
(e.g. [CBcrypt](https://github.com/vapor/vapor/blob/main/Sources/CBcrypt/include/module.modulemap)) 
have custom module maps. This example exercises the `rules_spm` code that processes custom module
maps and handles novel Clang module linking issues.