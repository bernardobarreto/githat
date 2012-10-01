require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Githat" do
  before(:each) { extend Diff }

  describe Diff do
    describe "ensure some methods are mocked" do
      it "files_names" do
        files_names.should == ['.gitignore', 'lib/githat.rb']
      end

      it "file_diff" do
        file_diff('githat_spec.rb').should == _1_file_2_heads
      end
    end

    it "file_extension" do
      file_extension('Makefile').should == :makefile
      file_extension('.gitignore').should == :text
      file_extension('foo.rb').should == :rb
      file_extension('bar.js').should == :js
      file_extension('foobar').should == :text
    end

    it "files_infos (with argv)" do
      gh_spec = files_infos(['spec/githat_spec.rb']).should == _1_file_2_heads_diff
    end

    it "files_names" do
      files_names.should == ['.gitignore', 'lib/githat.rb']
    end

    it "split_heads" do
      split_heads(_1_file_2_heads).should == _1_file_2_heads_splited[:heads]
    end

    it "split_codes" do
      split_codes(_1_file_2_heads).should == _1_file_2_heads_splited[:codes]
    end

    it "split_diff" do
      split_diff(_1_file_2_heads).should == _1_file_2_heads_splited
    end
  end
end
