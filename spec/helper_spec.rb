require File.join(File.dirname(__FILE__), 'spec_helper')

describe 'Helper' do
  it 'should convert CamelCase to snake_case' do
    input = 'competitionId'
    output = 'competition_id'
    expect(ModeWca::Helper.camel_to_snake(input)).to eq output
  end
end