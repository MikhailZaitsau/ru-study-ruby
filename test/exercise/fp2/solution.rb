module Exercise
  module Fp2
    class MyArray < Array
      # Использовать стандартные функции массива для решения задач нельзя.
      # Использовать свои написанные функции для реализации следующих - можно.

      # Написать свою функцию my_each
      def my_each(&block)
        return to_enum unless block_given?

        yield(first) unless empty?
        MyArray.new(drop(1)).my_each(&block) unless empty?
        self
      end

      # Написать свою функцию my_map
      def my_map
        return to_enum unless block_given?

        my_reduce(MyArray.new) { |acc, element| acc << yield(element) }
      end

      # Написать свою функцию my_compact
      def my_compact
        my_reduce(MyArray.new) { |acc, element| element.nil? ? acc : acc << element }
      end

      # Написать свою функцию my_reduce
      def my_reduce(accumulator = nil, operator = nil, &block)
        raise TypeError, "#{accumulator} is not a number" unless accumulator.is_a?(Numeric) || operator.nil?
        raise TypeError, "#{operator} is not a symbol or a string" unless string_or_symbol?(operator) || operator.nil?
        return accumulator if empty?

        block = make_block(accumulator) if string_or_symbol?(accumulator)
        block = make_block(operator) if string_or_symbol?(operator)
        accumulator = accumulator.nil? || string_or_symbol?(accumulator) ? first : block.call(accumulator, first)
        MyArray.new(drop(1)).my_reduce(accumulator, &block)
      end

      private

      def string_or_symbol?(argument)
        argument.is_a?(String) || argument.is_a?(Symbol)
      end

      def make_block(string_or_symbol)
        ->(acc, element) { acc.send(string_or_symbol, element) }
      end
    end
  end
end
