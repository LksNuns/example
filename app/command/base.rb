module Command
  # Base class to all commands
  class Base
    include ActiveModel::Attributes
    include ActiveModel::AttributeAssignment
    include ActiveModel::Validations

    def initialize(attributes = {})
      super()

      assign_attributes(attributes) if attributes
    end

    def execute_command
      ActiveRecord::Base.transaction do
        execute
      end
    end

    private

    def execute
      raise NotImplementedError, "must be defined for #{self}"
    end
  end
end
