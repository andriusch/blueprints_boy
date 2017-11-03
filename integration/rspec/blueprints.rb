blueprint :apple do
  'apple'
end

attributes(name: 'orange')
  .blueprint(:orange) { |attributes:| attributes[:name] }
  .strategy(:new, proc { |attributes:| "new #{attributes[:name]}" })

blueprint :global_cherry, name: 'cherry' do |attributes:|
  attributes[:name]
end
