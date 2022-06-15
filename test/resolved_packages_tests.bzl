"""Tests for resolved_packages."""

load("@bazel_skylib//lib:unittest.bzl", "asserts", "unittest")
load("//spm:defs.bzl", "resolved_packages")

def _parse_json_test(ctx):
    env = unittest.begin(ctx)

    json_str = """\
{
  "object": {
    "pins": [
      {
        "package": "async-http-client",
        "repositoryURL": "https://github.com/swift-server/async-http-client.git",
        "state": {
          "branch": null,
          "revision": "0f21b44d1ad5227ccbaa073aa40cd37eb8bbc337",
          "version": "1.11.0"
        }
      },
      {
        "package": "async-kit",
        "repositoryURL": "https://github.com/vapor/async-kit.git",
        "state": {
          "branch": null,
          "revision": "017dc7da68c1ec9f0f46fcd1a8002d14a5662732",
          "version": "1.12.0"
        }
      }
    ]
  },
  "version": 1
}
"""
    actual = resolved_packages.parse_json(json_str)
    expected = {
        "async-http-client": resolved_packages.create(
            name = "async-http-client",
            url = "https://github.com/swift-server/async-http-client.git",
            state = resolved_packages.state(
                revision = "0f21b44d1ad5227ccbaa073aa40cd37eb8bbc337",
                version = "1.11.0",
            ),
        ),
        "async-kit": resolved_packages.create(
            name = "async-kit",
            url = "https://github.com/vapor/async-kit.git",
            state = resolved_packages.state(
                revision = "017dc7da68c1ec9f0f46fcd1a8002d14a5662732",
                version = "1.12.0",
            ),
        ),
    }
    asserts.equals(env, expected, actual)

    return unittest.end(env)

parse_json_test = unittest.make(_parse_json_test)

def resolved_packages_test_suite():
    return unittest.suite(
        "resolved_packages_tests",
        parse_json_test,
    )
