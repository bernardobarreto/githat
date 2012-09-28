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

    it "prepare_head_for_output" do
      prepare_head_for_output(_2_heads_file[1]).should == "\n@@ -19,12 +13,12 @@"
    end

    it "split_heads" do
      split_heads(_1_file_2_heads).should ==
       ["diff --git a/spec/githat_spec.rb b/spec/githat_spec.rb\n" +
        "index 0c55061..217f540 100644\n--- a/spec/githat_spec.rb\n" +
        "+++ b/spec/githat_spec.rb\n@@ -1,11 +1,5 @@",
        "@@ -19,12 +13,12 @@"]
    end

    it "split_codes" do
      split_codes(_1_file_2_heads).should ==
        ["\nrequire File.expand_path(File.dirname(__FILE__) + '/spec_helper')" +
         "\n\n-module Diff\n-  def files_names\n-    ['bar.rb', 'foo.rb']\n" +
         "-  end\n-end\n-\ndescribe \"Githat\" do\n  before(:each) { extend Diff }\n\n",
         " describe \"Githat\" do\n    end\n\n    it \"files_names\" do\n+      " +
         "files_names.should == ['bar.rb', 'foo.rb'] # mocked\n    end\n\n-    " +
         "it \"files_info\" do\n-    end\n-\n-    it \"file_diff\" do\n+    " +
         "it \"split_heads\" do\n+      puts _1_file_2_heads\n+      " +
         "split_heads(_1_file_2_heads).should == []\n    end\n  end\nend"]
    end
  end
end
