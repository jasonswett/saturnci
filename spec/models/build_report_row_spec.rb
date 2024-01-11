require "rails_helper"

RSpec.describe BuildReportRow, type: :model do
  it 'returns green colored text when content includes "passed"' do
    report_row = BuildReportRow.new('Test passed successfully')
    expect(report_row.colorized).to eq('<span style="color: green;">Test passed successfully</span>')
  end

  it 'returns red colored text when content includes "failed"' do
    report_row = BuildReportRow.new('Test failed due to an error')
    expect(report_row.colorized).to eq('<span style="color: red;">Test failed due to an error</span>')
  end

  it 'returns text with no style when content includes neither "passed" nor "failed"' do
    report_row = BuildReportRow.new('Test executed')
    expect(report_row.colorized).to eq('<span style="">Test executed</span>')
  end
end
