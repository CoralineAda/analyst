module Analyst

  module EntityParser
    module Entities
      class Method < Entity
        def name
          ast.children.first.to_s
        end
        def full_name
          parent.full_name + '#' + name
        end
      end
    end
  end

end
