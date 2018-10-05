class ApplicationService
  extend Enumerize

  class Failure < StandardError; end

  enumerize :state, in: [:success, :failure], predicates: true

  def self.call(*args)
    new(*args).tap(&:call)
  end
end
