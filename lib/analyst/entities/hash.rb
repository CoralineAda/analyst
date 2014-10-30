module Analyst

  module Entities
    class Hash < Entity
      def pairs
        @pairs ||= process_nodes(ast.children)
      end

      def to_hash
        pairs.inject({}) do |hash, pair|
          hash[pair.key] = pair.value
          hash
        end
      end
    end
  end
end
