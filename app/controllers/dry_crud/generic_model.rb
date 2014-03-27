# encoding: UTF-8

module DryCrud

  # Connects the including controller to the model whose name corrsponds to the controller's name.
  #
  # The two main methods are +model_class+ and +model_scope+.
  # Additional helper methods store and retrieve values
  # in instance variables named after their class.
  module GenericModel
    extend ActiveSupport::Concern

    included do
      helper_method :model_class, :models_label, :path_args

    private

      delegate :model_class, :models_label, :model_identifier, to: 'self.class'
    end

    private

    # @return [ActiveRecord::Relation] scope where model entries will be listed and created.
    #   This is mainly used for nested models to provide the required context.
    #   In Rails < 4  a call to Model.all would execute a query immediately and return an array of records.
    #   In Rails 4, calls to Model.all is equivalent to now deprecated Model.scoped.
    #   This means that more relations can be chained to Model.all and the result will be lazily evaluated.
    def model_scope
      if Rails.version < '4.0'
        model_class.scoped
      else
        model_class.all
      end
    end

    # @param [Object] last the +entry+ or +model_class+ that was last used
    # @return [Object] path arguments to link to the given model entry.
    #   If the controller is nested, this provides the required context.
    def path_args(last)
      last
    end

    # @param [Boolean] plural If true, pluralize the instance variable name
    # @return [ActiveRecord::Base] Get the model instance cached in the controller
    #   dynamic instance variable that is named after the +model_class+.
    #   If the collection variable is required, pass true as the second argument.
      def get_model_ivar(plural = false)
      name = ivar_name(model_class)
      name = name.pluralize if plural
      instance_variable_get(:"@#{name}")
    end

    # @param [ActiveRecord::Base] value The model instance being cached
    # @return [ActiveRecord::Base] Creates and/or sets a dynamic instance variable
    #   in this controller instance that points to the related model instance.
    #   The variable name is the snake_case class name derived from the model instance.
    #   (If the model instance is a collection, then the name is pluralized.)
      def set_model_ivar(value)
      name = if value.respond_to?(:klass) # ActiveRecord::Relation
               ivar_name(value.klass).pluralize
             elsif value.respond_to?(:each) # Array
               ivar_name(value.first.class).pluralize
             else
               ivar_name(value.class)
             end
      instance_variable_set(:"@#{name}", value)
    end

    # @param [ActiveRecord::Base] klass The model class for which a snake_case name is needed
    # @return [String] the snake_case name of the model
    def ivar_name(klass)
    # [ActiveModel::Name]
    model_name = klass.model_name
    model_name.param_key
  end

  # Class methods from GenericModel.
  module ClassMethods

    # @return [Class] The class of the model (which is a subclass of {ActiveRecord::Base})
    def model_class
      @model_class ||= controller_name.classify.constantize
    end

    # @return [String] the snake_case name of the model which is used as the key value into the params hash
    #   that returns the form params.  (Used by assign_attributes method called from new, create & update actions)
    def model_identifier
      @model_identifier ||= model_class.model_name.param_key
    end

    # @return [String] A human readable name of the model, optionally pluralized, used in view displays
    def models_label(plural = true)
      opts = { count: (plural ? 3 : 1) }
      opts[:default] = model_class.model_name.human.titleize
      opts[:default] = opts[:default].pluralize if plural
      model_class.model_name.human(opts)
    end
  end

  end
end
