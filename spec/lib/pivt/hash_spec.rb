require 'spec_helper'
describe Hash do

  before(:each) do
  end

  it 'can format xml' do
    hash = {
      :story => {
        :name => 'Cool Name',
        :description => 'Cool Description'
      }
  	}
    hash.pivt_xml.should == '<story><name>Cool Name</name><description>Cool Description</description></story>'
  end

end
