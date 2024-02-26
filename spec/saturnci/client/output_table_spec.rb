require_relative "../../../lib/saturnci/output_table"

describe "table" do
  context "short commit message" do
    let!(:output_table) do
      items = [
        {
          "branch_name" => "saturnci-client",
          "commit_hash" => "7f8c8132",
          "commit_message" => "This commit message is pretty short."
        },
      ]

      SaturnCI::OutputTable.new(items)
    end

    it "does not get truncated" do
      expected_output = <<~OUTPUT
      Branch           Commit    Commit message
      saturnci-client  7f8c8132  This commit message is pretty short.
      OUTPUT

      expect(output_table.to_s).to eq(expected_output.strip)
    end
  end

  context "long commit message" do
    let!(:output_table) do
      long_commit_message = <<~TEXT
      This is an extremely long commit message which spans multiple lines
      and is entirely too verbose to be reasonably shown as a value in a
      line on a table.
      TEXT

      items = [
        {
          "branch_name" => "saturnci-client",
          "commit_hash" => "7f8c8132",
          "commit_message" => long_commit_message
        },
      ]

      SaturnCI::OutputTable.new(items)
    end

    it "gets truncated" do
      expected_output = <<~OUTPUT
      Branch           Commit    Commit message
      saturnci-client  7f8c8132  This is an extremely long commit message...
      OUTPUT

      expect(output_table.to_s).to eq(expected_output.strip)
    end
  end
end
