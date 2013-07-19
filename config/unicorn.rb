#listen 3012, :tcp_nopush => false
timeout 3000
worker_processes 5

# NO NO NO NO (strange intermittent errors with ActiveRecord with interrupted queries)
#preload_app true
