require "spec_helper"

describe Notifications do
  describe "import_email" do
    let(:mail) { Notifications.import_email }

    it "renders the headers" do
      mail.subject.should eq("Import email")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

  describe "import_message" do
    let(:mail) { Notifications.import_message }

    it "renders the headers" do
      mail.subject.should eq("Import message")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

end
