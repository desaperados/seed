config.cache_classes = true
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true
config.log_level = :debug
#config.cache_store = :mem_cache_store, {:namespace => 'seed'}
config.cache_store = :file_store, "tmp/cache"