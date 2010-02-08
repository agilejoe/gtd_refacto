require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "GTD" do
  it "should have a description" do
    t = Task.new
    t.description = "Hello"
    t.description.should == "xHello"
  end
end