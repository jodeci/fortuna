# frozen_string_literal: true
# 使用方式參考 Salary::ROLE
module CollectionTranslatable
  def method_missing(method_name)
    if (match = method_name.id2name.match(%r{^given_(\w+)}))
      "#{model_name}::#{match[1].upcase}".constantize.key(self.send(match[1])).to_s
    else
      super
    end
  end

  def respond_to_missing?(method_name, include_private = false)
    method_name.to_s.start_with?("given_") || super
  end
end
