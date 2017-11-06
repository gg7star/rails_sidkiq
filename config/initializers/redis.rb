# Configuration
redis = Hash.new{|h, k| h[k] = Hash.new(url: ENV["REDIS_URL"].presence || "redis://localhost:6379")}

# redis["production"] = {url: ENV["REDIS_URL"].presence || "redis://localhost:6390"}
# redis["staging"] = {url: ENV["REDIS_URL"].presence || "redis://localhost:6390"}
redis["development"] = {url: "redis://localhost:6390"}
redis["test"] = {url: "redis://localhost:6391"}

# Parse the env-specific url
uri = URI.parse(redis.dig(Rails.env, :url))

# Boot local redis in dev
if Rails.env.development? || Rails.env.test?
  system("redis-server --port #{uri.port} --daemonize yes")
  raise "Couldn't start redis" if $?.exitstatus != 0
end

# Initialize application-wide constant.
REDIS = Redis.new(url: uri.to_s, port: uri.port).freeze
puts ">> Initialized REDIS with #{REDIS.inspect}"