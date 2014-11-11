module Analyst

  module Entities
    class Hash < Entity

      handles_node :hash

      def pairs
        @pairs ||= process_nodes(ast.children)
      end

      # Convenience method to turn this Entity into an actual ::Hash.
      # If `extract_values` is true, then all keys and values that respond
      # to `#value` will be replaced by the value they return from that call.
      # Otherwise they'll be left as Analyst::Entities::Entity objects.
      def to_hash(extract_values:true)
        pairs.inject({}) do |hash, pair|
          key = pair.key
          val = pair.value
          if extract_values
            key = key.value if key.respond_to?(:value)
            val = val.value if val.respond_to?(:value)
          end
          hash[key] = val
          hash
        end
      end

      private

      def contents
        pairs
      end
    end
  end
end
