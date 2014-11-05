module Analyst

  module Entities
    class CodeBlock < Entity
      extend Forwardable

      def_delegators :parent, :name, :full_name

      def contents
        @contents ||= ast.children.map { |child| process_node(child) }
      end

    end
  end
end

