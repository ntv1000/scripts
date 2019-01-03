default_prune() {
	borg prune                          \
		--verbose                       \
		--list                          \
		--prefix "$1"                   \
		--show-rc                       \
		--keep-daily    14              \
		--keep-weekly   8               \
		--keep-monthly  -1
}
