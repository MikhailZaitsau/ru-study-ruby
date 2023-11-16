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
        return accumulator if empty?

        block = make_block(accumulator, operator, block)
        accumulator = accumulator.nil? || block[:accumulator] ? first : block.values[0].call(accumulator, first)
        MyArray.new(drop(1)).my_reduce(accumulator, &block.values[0])
      end

      private

      def make_block(accumulator, operator, block)
        raise LocalJumpError, 'no block given' if accumulator.nil? && operator.nil? && block.nil?
        return { opretor: ->(acc, element) { acc.send(operator, element) } } if operator
        return { block: block } if block

        { accumulator: ->(acc, element) { acc.send(accumulator, element) } }
      end
    end
  end
end
