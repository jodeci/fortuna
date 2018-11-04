# frozen_string_literal: true
require "test_helper"

class CollectionTranslatableTest < ActiveSupport::TestCase
  def test_translate_given_values
    subject = DummyObject.new("apple")
    assert_equal "蘋果", subject.given_fruit
  end

  def test_methods_not_prefixed_with_given
    subject = DummyObject.new
    assert_raises NoMethodError do
      subject.eat_fruit
    end
  end

  def test_respond_to_missing
    subject = DummyObject.new
    assert subject.respond_to? :given_anything
    assert_not subject.respond_to? :eat_fruit
  end

  class DummyObject
    include ActiveModel::Model
    include CollectionTranslatable

    attr_reader :fruit

    FRUIT = { "蘋果": "apple" }.freeze

    def initialize(fruit = nil)
      @fruit = fruit
    end
  end
end
