package = "futil"
version = "scm-1"

source = {
    url = "git://github.com/felixgwu/futil",
    tag = "master"
}

description = {
    summary = "Felix's unitlity functions for Torch",
    detailed = [[

        ]],
    homepage = "https://github.com/felixgwu/futil",
    license = "MIT"
}

dependencies = {
    "torch >= 7.0",
    "nn >= 1.0",
    "nnname",
}

build = {
    type = "builtin",
    modules = {
        futil = 'futil.lua'
    }
}
