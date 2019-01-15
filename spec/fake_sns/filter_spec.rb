require 'ostruct'

RSpec.describe 'Message filtering', :filter do
  def setup_filter
    filter(
      'type' => ['test.type']
    )
  end

  def setup_message(attrs = {})
    OpenStruct.new(attrs: attrs)
  end

  describe 'passes?' do
    it 'returns true if message passes the filter' do
      message = setup_message('type' => {'Type' => 'String', 'Value' => 'test.type'})
      expect(setup_filter.passes?(message)).to eq true
    end

    it 'returns false if message is missing attributes' do
      message = OpenStruct.new
      expect(setup_filter.passes?(message)).to eq false
    end

    it 'returns false if message is missing the field' do
      message = setup_message()
      expect(setup_filter.passes?(message)).to eq false
    end

    it 'returns false if message if field and value mismatch' do
      message = setup_message('type' => {'Type': 'String', 'Value': 'test2.kind'})
      expect(setup_filter.passes?(message)).to eq false
    end
  end

  describe 'fields_match' do
    it 'returns true if message attr props and rule props match' do
      attr = {
        'type' => {
          'Type' => 'String',
          'Value' => 'test.type'
        }
      }

      expect(setup_filter.fields_match?(attr)).to eq true
    end
  end

  describe 'contains_values?' do
    it 'returns true if message attr is member of rule for prop' do
      attr = {
        'type' => {
          'Type' => 'String',
          'Value' => 'test.type'
        }
      }

      expect(setup_filter.contains_values?(attr)).to eq true
    end

    it 'returns false if message attr is not member of rule for prop' do
      attr = {
        'type' => {
          'Type' => 'String',
          'Value' => 'test.type2'
        }
      }

      expect(setup_filter.contains_values?(attr)).to eq false
    end
  end
end
