require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

module Diff
  def files_names
    ['bar.rb', 'foo.rb']
  end
end

describe "Githat" do
  before(:each) { extend Diff }

  describe Diff do
    it "file_extension" do
      file_extension('Makefile').should == :makefile
      file_extension('.gitignore').should == :text
      file_extension('foo.rb').should == :rb
      file_extension('bar.js').should == :js
      file_extension('foobar').should == :text
    end

    it "files_names" do
    end

    it "files_info" do
    end

    it "file_diff" do
    end
  end
end
