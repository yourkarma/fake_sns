require 'ostruct'

RSpec.describe 'Message filtering', :filter do
  def setup_filter
    filter(
      'type' => {
        'Type' => 'String',
        'Value' => 'test.type'
      }
    )
  end

  def setup_message(content = {})
    OpenStruct.new(message: content)
  end

  it 'returns true if message passes the filter' do
    message = setup_message('type' => 'test.type')
    expect(setup_filter.passes?(message)).to eq true
  end

  it 'returns false if message is missing the field' do
    message = setup_message()
    expect(setup_filter.passes?(message)).to eq false
  end

  it 'returns false if message if field has type mismatch' do
    message = setup_message('type' => 1)
    expect(setup_filter.passes?(message)).to eq false
  end

  it 'returns false if message if field and value mismatch' do
    message = setup_message('type' => 'test2.kind')
    expect(setup_filter.passes?(message)).to eq false
  end
end
