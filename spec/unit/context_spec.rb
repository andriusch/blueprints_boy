require 'spec_helper'

describe BlueprintsBoy::Context do
  describe '#initialize' do
    specify do
      subject.dependencies.should eq([])
      subject.attrs.should eq({})
      subject.factory_class.should be_nil
    end
  end

  describe '#depends_on' do
    it 'sets dependencies' do
      subject.depends_on(:blueprint, :blueprint2)
      subject.dependencies.should eq([:blueprint, :blueprint2])
    end

    it 'merges dependencies' do
      subject.depends_on(:blueprint, :blueprint2)
      subject.depends_on(:blueprint3)
      subject.dependencies.should eq([:blueprint, :blueprint2, :blueprint3])
    end

    it 'only keeps uniq dependencies' do
      subject.depends_on(:blueprint)
      subject.depends_on(:blueprint)
      subject.dependencies.should eq([:blueprint])
    end
  end

  describe '#attributes' do
    it 'changes attrs' do
      subject.attributes(attr: 'val')
      subject.attrs.should eq(attr: 'val')
    end

    it 'merges attributes' do
      subject.attributes(attr1: 'v1')
      subject.attributes(attr2: 'v2')
      subject.attrs.should eq(attr1: 'v1', attr2: 'v2')
    end
  end

  describe '#factory' do
    it 'sets factory class' do
      subject.factory(Fixnum)
      subject.factory_class.should eq(Fixnum)
    end
  end
end
