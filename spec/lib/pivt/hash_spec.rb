require 'spec_helper'
describe Hash do

  it 'can format xml' do
    hash = {
      :story => {
        :name => 'Cool Name',
        :description => 'Cool Description'
      }
  	}
    xml = '<story><name>Cool Name</name><description>Cool Description</description></story>'
    hash.pivt_xml.should == xml
  end

end
