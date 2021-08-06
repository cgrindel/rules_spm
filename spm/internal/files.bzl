load("@bazel_skylib//lib:paths.bzl", "paths")

def is_target_file(target_name, file):
    if file.is_directory:
        return False
    dir_parts = file.short_path.split("/")
    for dir_part in dir_parts:
        if dir_part == target_name:
            return True
    return False

def is_hdr_file(file):
    if file.is_directory or file.extension != "h":
        return False
    dir_name = paths.basename(file.dirname)
    return dir_name == "include"

def is_modulemap_file(file):
    if file.is_directory:
        return False
    return file.basename == "module.modulemap"

def contains_path(file, path):
    return file.path.find(path) > -1
