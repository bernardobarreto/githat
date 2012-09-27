require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

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
      files_names.should == ['bar.rb', 'foo.rb'] # mocked
    end

    it "split_heads" do
      split_heads(_1_file_2_heads).should ==
       ["diff --git a/spec/githat_spec.rb b/spec/githat_spec.rb\n" +
        "index 0c55061..217f540 100644\n--- a/spec/githat_spec.rb\n" +
        "+++ b/spec/githat_spec.rb\n@@ -1,11 +1,5 @@",
        "@@ -19,12 +13,12 @@"]
    end
  end
end
