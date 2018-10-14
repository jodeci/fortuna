# frozen_string_literal: true
module FormatService
  class StatementGainLossColumns
    include Callable

    attr_reader :gain, :loss

    def initialize(gain, loss)
      @gain = hash_to_array(gain)
      @loss = hash_to_array(loss)
    end

    def call
      if gain_size > loss_size
        loss.fill(loss_size..gain_size - 1) { { "": nil } }
      else
        gain.fill(gain_size..loss_size - 1) { { "": nil } }
      end
      gain.zip(loss)
    end

    private

    def hash_to_array(hash)
      array = []
      hash.map { |key, value| array << { "#{key}": value } }
      array
    end

    def gain_size
      gain.size
    end

    def loss_size
      loss.size
    end
  end
end
