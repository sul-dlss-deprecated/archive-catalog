# encoding: UTF-8

# Abstract controller providing basic CRUD actions.
#
# Some enhancements were made to ease extensibility.
# The current model entry is available in the view as an instance variable
# named after the +model_class+ or in the helper method +entry+.
# Several protected helper methods are there to be (optionally) overriden by
# subclasses.
# With the help of additional callbacks, it is possible to hook into the
# action procedures without overriding the entire method.
class CrudController < ListController

  self.responder = DryCrud::Responder

  if Rails.version >= '4.0'
    class_attribute :permitted_attrs
  end

  # Defines before and after callback hooks for create, update, save and
  # destroy actions.
  define_model_callbacks :create, :update, :save, :destroy

  # Defines before callbacks for the render actions. A virtual callback
  # unifiying render_new and render_edit, called render_form, is defined
  # further down.
  define_render_callbacks :show, :new, :edit

  hide_action :run_callbacks

  after_save :set_success_notice
  after_destroy :set_success_notice

  helper_method :entry, :full_entry_label

  ##############  ACTIONS  ############################################

  # Show one entry of this model.
  #   GET /entries/1
  #   GET /entries/1.json
  def show(&block)
    respond_with(entry, &block)
  end

  # Display a form to create a new entry of this model.
  #   GET /entries/new
  #   GET /entries/new.json
  def new(&block)
    assign_attributes if params[model_identifier]
    respond_with(entry, &block)
  end

  # Create a new entry of this model from the passed params or update existing record
  # There are before and after create callbacks to hook into the action.
  # To customize the response, you may overwrite this action and call
  # super with a block that gets the format parameter.
  # Specify a :location option if you wish to do a custom redirect.
  #   POST /entries
  #   POST /entries.json
  def create(options = {}, &block)
    assign_attributes
    created = with_callbacks(:create, :save) {entry.save}
    respond_options = options.reverse_merge(success: created)
    respond_with(entry, respond_options, &block)
  end

  # Display a form to edit an existing entry of this model.
  #   GET /entries/1/edit
  def edit(&block)
    respond_with(entry, &block)
  end

  # Update an existing entry of this model from the passed params.
  # There are before and after update callbacks to hook into the action.
  # To customize the response, you may overwrite this action and call
  # super with a block that gets the format parameter.
  # Specify a :location option if you wish to do a custom redirect.
  #   PATCH or PUT /entries/1
  #   PATCH or PUT /entries/1.json
  def update(options = {}, &block)
    assign_attributes
    updated = with_callbacks(:update, :save) { entry.save }
    respond_options = options.reverse_merge(success: updated)
    respond_with(entry, respond_options, &block)
  end

  # Destroy an existing entry of this model.
  # There are before and after destroy callbacks to hook into the action.
  # To customize the response, you may overwrite this action and call
  # super with a block that gets success and format parameters.
  # Specify a :location option if you wish to do a custom redirect.
  #   DELETE /entries/1
  #   DELETE /entries/1.json
  def destroy(options = {}, &block)
    destroyed = run_callbacks(:destroy) { entry.destroy }
    unless destroyed
      set_failure_notice
      location = request.env['HTTP_REFERER'].presence
    end
    location ||= index_url
    respond_options = options.reverse_merge(success: destroyed,
                                            location: location)
    respond_with(entry, respond_options, &block)
  end

  private

  #############  CUSTOMIZABLE HELPER METHODS  ##############################


  def to_boolean(value)
    ActiveRecord::ConnectionAdapters::Column.value_to_boolean(value.to_s.downcase)
  end

  # Main accessor method for the handled model entry.  params is_a {ActionController::Parameters}
  # Returns the model instance corresponding to a table row found using a primary key
  # this method is shared by all CRUD operations
  def entry
    # originally, this method was a single line
    #   get_model_ivar || set_model_ivar(params[:id] ? find_entry : build_entry)
    # but we enhanced it so that POST (create) acts like *add or update*

    # return the previously cached entry if it exists
    ivar = get_model_ivar
    return ivar if ivar
    begin
      # find the existing entry (table row) using the params supplied with the request
      # (either as an {id} param or as a set of key/value pairs)
      ivar = find_entry
    rescue ActiveRecord::RecordNotFound => notfound
      if params[:id]
        # For requests where the primary key is provided as an {id} param,
        # if the table row was not found, we should return the 404 error to the client
        raise notfound
      end
      # probably unnecessary
      ivar = nil
    end
    # For the NEW or POST (create or update) operation, we will build the entry if it does not yet exist
    ivar = build_entry unless ivar
    # cache the entry for the next time it is needed
    set_model_ivar(ivar)
    ivar
  end

  # Creates a new model entry. [ActiveRecord::Relation]
  def build_entry
    model_scope.new
  end

  # [ActiveRecord::Relation].first -> ActiveRecord::Base Sets an existing model entry from the given id.
  # try every possible way to find an existing row corresponding to the primary key
  # raises ActiveRecord::RecordNotFound if the entry is not in the table
  def find_entry
    ms = model_scope
    result = nil
    if params[:id]
      # Requests that retrieve existing records (e.g. show, edit, update, destroy) set an 'id' param
      # The +find+ method raises ActiveRecord::RecordNotFound if no database item has this primary key
      result = ms.find(params[:id])
    elsif params[ms.primary_key]
      # Primary key is a single value provided in the params hash
      # This modification allows the create action to succeed even if the item already exists
      # The +where...first+ methods returns the item from the database or nil if not found
      result = ms.where(ms.primary_key => params[ms.primary_key]).first
    elsif ms.primary_key.instance_of? CompositePrimaryKeys::CompositeKeys
      # primary key is composed of multiple values
      if (ms.primary_key - params.keys).empty?
        # param values are present for all the primary keys
        pk_values = ms.primary_key.map{|k| params[k]}
        result = ms.find(pk_values)
      end
    end
    result
  end

  # Assigns the attributes from the params to the model entry.
  def assign_attributes
    entry.attributes = model_params
  end

  # The form params for this model.
  def model_params
    if Rails.version < '4.0'
      params[model_identifier]
    else
      params.require(model_identifier).permit(permitted_attrs)
    end
  end

  # Url of the index page to return to.
  def index_url
    polymorphic_url(path_args(model_class), returning: true)
  end

  # A label for the current entry, including the model name.
  def full_entry_label
    "#{models_label(false)} <i>#{ERB::Util.h(entry)}</i>".html_safe
  end

  # Set a success flash notice when we got a HTML request.
  def set_success_notice
    if request.format == :html
      flash[:notice] ||= flash_message(:success)
    end
  end

  # Set a failure flash notice when we got a HTML request.
  def set_failure_notice
    if request.format == :html
      flash[:alert] ||= error_messages.presence || flash_message(:failure)
    end
  end

  # Get an I18n flash message.
  # Uses the key {controller_name}.{action_name}.flash.{state}
  # or crud.{action_name}.flash.{state} as fallback.
  def flash_message(state)
    scope = "#{action_name}.flash.#{state}"
    keys = [:"#{controller_name}.#{scope}_html",
            :"#{controller_name}.#{scope}",
            :"crud.#{scope}_html",
            :"crud.#{scope}"]
    I18n.t(keys.shift, model: full_entry_label, default: keys).html_safe
  end

  # Html safe error messages of the current entry.
  def error_messages
    escaped = entry.errors.full_messages.map { |m| ERB::Util.html_escape(m) }
    escaped.join('<br/>').html_safe
  end

  # Class methods for CrudActions.
  class << self
    # Convenience callback to apply a callback on both form actions
    # (new and edit).
    def before_render_form(*methods)
      before_render_new(*methods)
      before_render_edit(*methods)
    end


  end

end
