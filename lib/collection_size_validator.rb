class CollectionSizeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value.size < options[:min_size]
      record.errors[attribute] << (options[:message] || "You must upload at least #{options[:min_size]} image.")
    end
    if value.size > options[:max_size]
      record.errors[attribute] << (options[:message] || "You can only upload up to #{options[:max_size]} images.")
    end
  end
end