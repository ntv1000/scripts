#df/bin/sh

#export BORG_REPO=/tmp/homeserver
#export BORG_PASSPHRASE='fr45tg'

test_comp() {
repo_path=/mnt/usb-cluster/borg/test-$1
borg init --verbose -e none $repo_path

borg create                         \
    --verbose                       \
    --filter AME                    \
    --list                          \
    --stats                         \
    --show-rc                       \
    --compression $1      \
    --exclude-caches                \
    --exclude-from=full.exclude     \
                                    \
    $repo_path::'full'           \
    /
}

test_comp "none"
test_comp "zstd,1"
test_comp "zstd,5"
test_comp "zstd,22"
test_comp "auto,zstd,22"
test_comp "lz4"
test_comp "zlib"
test_comp "lzma"
