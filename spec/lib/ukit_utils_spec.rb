require 'spec_helper'
require 'ukit_utils'

describe UkitUtils do
  it "formats appeal numbers" do
    UkitUtils.format_appeal_number('VA180912012').should == 'VA/18091/2012'
    UkitUtils.format_appeal_number('IA200872012').should == 'IA/20087/2012'
    UkitUtils.format_appeal_number('DA003562012').should == 'DA/00356/2012'
    UkitUtils.format_appeal_number('OA018442011').should == 'OA/01844/2011'
  end

  it "derives appeal numbers from filenames" do
    UkitUtils.appeal_numbers_from_filename('37265/OA100502012_20__20OA100522012.doc').should == ['OA100502012', 'OA100522012']
    UkitUtils.appeal_numbers_from_filename('37245/IA282352012_20__20IA282362012.doc').should == ['IA282352012', 'IA282362012']
    UkitUtils.appeal_numbers_from_filename('IA261612012_20__20IA261602012_20__20IA261622012_20.doc').should == ['IA261612012', 'IA261602012', 'IA261622012']
    UkitUtils.appeal_numbers_from_filename('hx629622003.doc').should == ['HX629622003']
    UkitUtils.appeal_numbers_from_filename('HX-46156-2002.doc').should == ['HX461562002']
    UkitUtils.appeal_numbers_from_filename('HX-462912003.doc').should == ['HX462912003']
  end
end
