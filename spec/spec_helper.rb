$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'
require 'githat'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

module Diff
  def file_diff(name)
    _1_file_2_heads
  end

  def git_status
    git_status_modified_files
  end
end

def git_status_modified_files
  "# modified:   .gitignore\n" +
  "# deleted:    foo\n" +
  "# modified:   lib/githat.rb"
end

def _1_file_2_heads_splited
  { codes: ["\nrequire File.expand_path(File.dirname(__FILE__) + '/spec_helper')" +
    "\n\n-module Diff\n-  def files_names\n-    ['bar.rb', 'foo.rb']\n" +
    "-  end\n-end\n-\ndescribe \"Githat\" do\n  before(:each) { extend Diff }\n\n",
    " describe \"Githat\" do\n    end\n\n    it \"files_names\" do\n+      " +
    "files_names.should == ['bar.rb', 'foo.rb'] # mocked\n    end\n\n-    " +
    "it \"files_info\" do\n-    end\n-\n-    it \"file_diff\" do\n+    " +
    "it \"split_heads\" do\n+      puts _1_file_2_heads\n+      " +
    "split_heads(_1_file_2_heads).should == []\n    end\n  end\nend"],

    heads: ["diff --git a/spec/githat_spec.rb b/spec/githat_spec.rb\n" +
    "index 0c55061..217f540 100644\n--- a/spec/githat_spec.rb\n" +
    "+++ b/spec/githat_spec.rb\n@@ -1,11 +1,5 @@",
    "@@ -19,12 +13,12 @@"] }
end

def _2_files
  %{diff --git a/lib/githat.rb b/lib/githat.rb
index fdc7d30..c912bca 100644
--- a/lib/githat.rb
+++ b/lib/githat.rb
@@ -26,7 +26,7 @@ module Diff
     (0...heads.size).each do |i|
       parsed_head = parse_with_diff(prepare_head_for_output(heads[i]))
       parsed_code = parse_with_lang(codes[i], extension)
-      parsed_code = parse_with_diff(parsed_code)
+      foo
       complete_file_diff << (parsed_head + parsed_code)
     end

diff --git a/spec/githat_spec.rb b/spec/githat_spec.rb
index 13edd0f..2c6b9d1 100644
--- a/spec/githat_spec.rb
+++ b/spec/githat_spec.rb
@@ -1,5 +1,5 @@
 require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
-
+foo
 describe "Githat" do
   before(:each) { extend Diff }}
end

def _2_heads_file
  ["diff --git a/spec/githat_spec.rb b/spec/githat_spec.rb" +
  "index 0c55061..217f540 100644" +
  "--- a/spec/githat_spec.rb" +
  "+++ b/spec/githat_spec.rb" +
  "@@ -1,11 +1,5 @@",
  "@@ -19,12 +13,12 @@"]
end

def _1_file_2_heads
  %{diff --git a/spec/githat_spec.rb b/spec/githat_spec.rb
index 0c55061..217f540 100644
--- a/spec/githat_spec.rb
+++ b/spec/githat_spec.rb
@@ -1,11 +1,5 @@
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

-module Diff
-  def files_names
-    ['bar.rb', 'foo.rb']
-  end
-end
-
describe "Githat" do
  before(:each) { extend Diff }

@@ -19,12 +13,12 @@ describe "Githat" do
    end

    it "files_names" do
+      files_names.should == ['bar.rb', 'foo.rb'] # mocked
    end

-    it "files_info" do
-    end
-
-    it "file_diff" do
+    it "split_heads" do
+      puts _1_file_2_heads
+      split_heads(_1_file_2_heads).should == []
    end
  end
end}
end

RSpec.configure do |config|
end
