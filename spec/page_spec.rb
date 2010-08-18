require 'spec_helper'

describe Page do
  before :each do
    @page = Page.new
  end

  after :each do
    @page = nil
  end

  describe "#initialize" do
    it "should have no content" do
      @page.content.should be_empty
    end
  end

  describe "#buf" do
    it "should append a +String+ to @page content" do
      @page.buf "foo"
      @page.content.should == "foo"
      @page.buf "\nbar"
      @page.content.should == "foo\nbar"
    end
  end
end
