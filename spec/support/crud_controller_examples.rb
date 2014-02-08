# encoding: UTF-8
require 'support/crud_controller_test_helper'

RSpec.configure do |c|
  c.before failing: true do
    model_class.any_instance.stub(:save).and_return(false)
    model_class.any_instance.stub(:destroy).and_return(false)
  end
end

# A set of examples to include into the tests for your crud controller
# subclasses. Simply #let :test_entry, :new_entry_attrs and :edit_entry_attrs
# to test the basic crud functionality.
# If single examples do not match with you implementation, you may skip
# them by passing a skip parameter with context arrays:
#   include_examples 'crud controller',
#                    skip: [%w(index html sort) %w(destroy json)]
shared_examples 'crud controller' do |options|

  include CrudControllerTestHelper

  render_views

  subject { response }

  let(:model_class)      { controller.send(:model_class) }
  let(:model_identifier) { controller.model_identifier }
  let(:test_params)      { scope_params }
  let(:sort_column)      { model_class.column_names.first }
  let(:entry)            { assigns(controller.send(:ivar_name, model_class)) }
  let(:entries) { assigns(controller.send(:ivar_name, model_class).pluralize) }
  let(:search_value) do
    field = controller.search_columns.first
    val = test_entry[field].to_s
    val[0..((val.size + 1) / 2)]
  end

  before do
    m = example.metadata
    if m[:perform_request] != false && m[:action] && m[:method]
      perform_combined_request
    end
  end

  describe_action :get, :index,
                  unless: skip?(options, 'index') do

    context '.html',
            format: :html,
            unless: skip?(options, %w(index html)) do

      context 'plain',
              unless: skip?(options, %w(index html plain)),
              combine: 'ihp' do
        it_should_respond
        it_should_assign_entries
        it_should_render
      end

      context 'search',
              if: described_class.search_columns.present?,
              unless: skip?(options, %w(index html search)),
              combine: 'ihse' do
        let(:params) { { q: search_value } }

        it_should_respond

        context 'entries' do
          subject { entries }
          it { should include(test_entry) }
        end
      end

      context 'sort',
              unless: skip?(options, %w(index html sort)) do
        context 'ascending',
                unless: skip?(options, %w(index html sort ascending)),
                combine: 'ihso' do
          let(:params) { { sort: sort_column, sort_dir: 'asc' } }

          it_should_respond

          it 'should have sorted entries' do
            sorted = entries.sort_by(&(sort_column.to_sym))
            entries.should == sorted
          end
        end

        context 'descending',
                unless: skip?(options, %w(index html sort descending)),
                combine: 'ihsd' do
          let(:params) { { sort: sort_column, sort_dir: 'desc' } }

          it_should_respond

          it 'should have sorted entries' do
            sorted = entries.sort_by(&(sort_column.to_sym))
            entries.should == sorted.reverse
          end
        end
      end
    end

    context '.json',
            format: :json,
            unless: skip?(options, %w(index json)),
            combine: 'ij' do
      it_should_respond
      it_should_assign_entries
      its(:body) { should start_with('[{') }
    end
  end

  describe_action :get, :show,
                  id: true,
                  unless: skip?(options, 'show') do

    context '.html',
            format: :html,
            unless: skip?(options, %w(show html)) do

      context 'plain',
              unless: skip?(options, %w(show html plain)),
              combine: 'sh' do
        it_should_respond
        it_should_assign_entry
        it_should_render
      end

      context 'with non-existing id',
              unless: skip?(options,
                            %w(show html with_non_existing_id)) do
        let(:params) { { id: 9999 } }

        it 'should raise RecordNotFound', perform_request: false do
          expect { perform_request }
          .to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end

    context '.json',
            format: :json,
            unless: skip?(options, %w(show json)),
            combine: 'sj' do
      it_should_respond
      it_should_assign_entry
      its(:body) { should start_with('{') }
    end
  end

  describe_action :get, :new,
                  unless: skip?(options, %w(new)) do
    context 'plain',
            unless: skip?(options, %w(new plain)),
            combine: 'new' do
      it_should_respond
      it_should_render
      it_should_persist_entry(false)
    end

    context 'with params',
            unless: skip?(options, %w(new with_params)) do
      let(:params) { { model_identifier => new_entry_attrs } }
      it_should_set_attrs(:new)
    end
  end

  describe_action :post, :create,
                  unless: skip?(options, %w(create)) do
    let(:params) { { model_identifier => new_entry_attrs } }

    it 'should add entry to database', perform_request: false do
      expect { perform_request }.to change { model_class.count }.by(1)
    end

    context 'html',
            format: :html,
            unless: skip?(options, %w(create html)) do
      it_should_persist_entry # cannot combine this

      context 'with valid params',
              unless: skip?(options, %w(create html valid)),
              combine: 'chv' do
        it_should_redirect_to_show
        it_should_set_attrs(:new)
        it_should_have_flash(:notice)
      end

      context 'with invalid params',
              failing: true,
              unless: skip?(options, %w(create html invalid)),
              combine: 'chi' do
        it_should_render('new')
        it_should_persist_entry(false)
        it_should_set_attrs(:new)
        it_should_not_have_flash(:notice)
      end
    end

    context 'json',
            format: :json,
            unless: skip?(options, %w(create json)) do
      it_should_persist_entry # cannot combine this

      context 'with valid params',
              unless: skip?(options, %w(create json valid)),
              combine: 'cjv' do
        it_should_respond(201)
        it_should_set_attrs(:new)
        its(:body) { should start_with('{') }
      end

      context 'with invalid params',
              failing: true,
              unless: skip?(options, %w(create json invalid)),
              combine: 'cji' do
        it_should_respond(422)
        it_should_set_attrs(:new)
        its(:body) { should match(/"errors":\{/) }
        it_should_persist_entry(false)
      end
    end
  end

  describe_action :get, :edit,
                  id: true,
                  unless: skip?(options, %w(edit)),
                  combine: 'edit' do
    it_should_respond
    it_should_render
    it_should_assign_entry
  end

  describe_action :put, :update,
                  id: true,
                  unless: skip?(options, %w(update)) do
    let(:params) { { model_identifier => edit_entry_attrs } }

    it 'should update entry in database', perform_request: false do
      expect { perform_request }.to change { model_class.count }.by(0)
    end

    context '.html',
            format: :html,
            unless: skip?(options, %w(update html)) do
      context 'with valid params',
              unless: skip?(options, %w(update html valid)),
              combine: 'uhv' do
        it_should_set_attrs(:edit)
        it_should_redirect_to_show
        it_should_persist_entry
        it_should_have_flash(:notice)
      end

      context 'with invalid params',
              failing: true,
              unless: skip?(options, %w(update html invalid)),
              combine: 'uhi' do
        it_should_render('edit')
        it_should_set_attrs(:edit)
        it_should_not_have_flash(:notice)
      end
    end

    context '.json',
            format: :json,
            unless: skip?(options, %w(update json)) do

      context 'with valid params',
              unless: skip?(options, %w(update json valid)),
              combine: 'ujv' do
        it_should_respond(204)
        it_should_set_attrs(:edit)
        its(:body) { should match(/s*/) }
        it_should_persist_entry
      end

      context 'with invalid params',
              failing: true,
              unless: skip?(options, %w(update json invalid)),
              combine: 'uji' do
        it_should_respond(422)
        it_should_set_attrs(:edit)
        its(:body) { should match(/"errors":\{/) }
      end
    end
  end

  describe_action :delete, :destroy,
                  id: true,
                  unless: skip?(options, %w(destroy)) do

    it 'should remove entry from database', perform_request: false  do
      expect { perform_request }.to change { model_class.count }.by(-1)
    end

    context '.html',
            format: :html,
            unless: skip?(options, %w(destroy html)) do

      context 'successfull', combine: 'dhs' do
        it_should_redirect_to_index
        it_should_have_flash(:notice)
      end

      context 'with failure', failing: true, combine: 'dhf' do
        it_should_redirect_to_index
        it_should_have_flash(:alert)
      end
    end

    context '.json',
            format: :json,
            unless: skip?(options, %w(destroy json)) do

      context 'successfull', combine: 'djs' do
        it_should_respond(204)
        its(:body) { should match(/s*/) }
      end

      context 'with failure', failing: true, combine: 'djf' do
        it_should_respond(422)
        its(:body) { should match(/"errors":\{/) }
      end
    end
  end

end
