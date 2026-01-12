require "async"

RSpec.configure do |config|
  config.around(:each, :async) do |example|
    Async do |task|
      example.run
      task.stop
    end
  end
end
