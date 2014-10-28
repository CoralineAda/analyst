module Analyst

  class ContextStack < Array

    def initialize
      self.push(Analyst::Entities::Empty.new(nil, nil))
    end

  end

end
