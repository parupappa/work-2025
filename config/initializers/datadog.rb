require 'datadog/statsd'
require 'datadog'

Datadog.configure do |c|
    c.env = ENV.fetch('DD_ENV', 'development')
    c.service = 'sample-rails-app'
    c.profiling.enabled = true
    c.agent.host = 'datadog'
    c.agent.port = 8126
    # To enable runtime metrics collection, set `true`. Defaults to `false`
    # You can also set DD_RUNTIME_METRICS_ENABLED=true to configure this.
    c.runtime_metrics.enabled = true

    # Optionally, you can configure the Statsd instance used for sending runtime metrics.
    # Statsd is automatically configured with default settings if `dogstatsd-ruby` is available.
    # You can configure with host and port of Datadog Agent; defaults to 'localhost:8125'.
    c.runtime_metrics.statsd = Datadog::Statsd.new
end