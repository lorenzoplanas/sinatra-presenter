require 'spec_helper'

describe Sinatra::Presenter::Base do
  before :each do
    @doc1 = Doc.create!(:name => 'Doc 1')
    @doc2 = Doc.create!(:name => 'Doc 2')
  end

  after :each do
    @doc1.destroy
    @doc2.destroy
  end

  context "#initialize" do
    describe "with resource" do
      it "should initialize a presenter with the resource and an empty page" do
        doc_presenter = DocPresenter.new(@doc1)
        doc_presenter.rsc.should == @doc1
        doc_presenter.page.content.should == ''
      end
    end

    describe "with resource and options" do
      it "should create reader methods and instance variables for each option" do
        doc_presenter = DocPresenter.new(@doc1, :option1 => 'option 1', :option2 => 'option 2')
        doc_presenter.rsc.should == @doc1
        doc_presenter.page.content.should == ''
        doc_presenter.option1.should == 'option 1'
        doc_presenter.option2.should == 'option 2'
        doc_presenter.class.instance_methods.include?(:option1).should be_true
        doc_presenter.class.instance_methods.include?(:option2).should be_true
      end
    end
  
    describe "with collection" do
      it "should initialize the presenter with an empty resource and a collection member" do
        doc_presenter = DocPresenter.new(nil, :collection => [@doc1, @doc2])
        doc_presenter.rsc.should be_nil
        doc_presenter.collection.should == [@doc1, @doc2]
        doc_presenter.page.content.should == ''
      end
    end
  end

  context "#content_tag" do
    before :each do
      @doc_presenter = DocPresenter.new(@doc1)
    end

    describe "without content nor options or block" do
      it "should buffer an empty tag pair" do
        @doc_presenter.content_tag :p
        @doc_presenter.page.content.should == "<p></p>"
      end
    end

    describe "with options but no content or block" do
      it "should buffer an empty tag pair and set the options as html tag attributes" do
        @doc_presenter.content_tag :p, :id => "foo_id", :class => "foo_class"
        @doc_presenter.page.content.should == "<p id=\"foo_id\" class=\"foo_class\"></p>"
      end
    end

    describe "with inline content" do
      it "should buffer a tag pair with the content" do
        @doc_presenter.content_tag :p, "foo"
        @doc_presenter.page.content.should == "<p>foo</p>"
      end
    end

    describe "with inline content and options" do
      it "should buffer a tag pair with the content, and set the options as html tag attributes" do
        @doc_presenter.content_tag :p, "foo", :id => "foo_id", :class => "foo_class"
        @doc_presenter.page.content.should == "<p id=\"foo_id\" class=\"foo_class\">foo</p>"
      end
    end

    describe "with block" do
      it "should buffer a tag pair with the block's content" do
        @doc_presenter.content_tag :p do "foo" end
        @doc_presenter.page.content.should == "<p>foo</p>"
      end
    end

    describe "with block and options" do
      it "should buffer a tag pair with the block's content, and set the options as html tag attributes" do
        @doc_presenter.content_tag :p, :id => "foo_id", :class => "foo_class" do "foo" end
        @doc_presenter.page.content.should == "<p id=\"foo_id\" class=\"foo_class\">foo</p>"
      end
    end
  end

  context "#tag" do
    before :each do
      @doc_presenter = DocPresenter.new(@doc1)
    end

    describe "without options" do
      it "should buffer a self-closing tag" do
        @doc_presenter.tag :input
        @doc_presenter.page.content.should == "<input />"
      end
    end

    describe "with options" do
      it "should buffer a self-closing tag and set the options as html tag attributes" do
        @doc_presenter.tag :input, :type => 'submit', :id => "foo_id", :class => "foo_class"
        @doc_presenter.page.content.should == "<input type=\"submit\" id=\"foo_id\" class=\"foo_class\" />"
      end
    end
  end
end
