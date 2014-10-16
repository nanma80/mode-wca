require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe 'TSV' do
  let(:tsv) { ModeWca::Local::TsvFile.new('../spec/files/tsv/test.tsv') }
  let(:csv) { ModeWca::Local::CsvFile.new('../spec/files/tsv/test.csv') }

  it 'should list columns' do
    expect(tsv.columns).to eq [{name: 'id', type: 'integer'}, {name: 'name', type: 'string'}]
  end

  it 'should convert to csv' do
    tsv.to_csv(csv.path)
    expect(File.read(csv.path)).to eq "1,111\n2,22\n3,\"t\"\"hre\"\"e\"\n4,\"fo, ur\"\n"
  end
end