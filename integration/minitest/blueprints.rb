blueprint :apple do
  'apple'
end

attributes(name: 'orange').blueprint :orange do |attributes:|
  attributes[:name]
end

blueprint :global_cherry, name: 'cherry' do |attributes:|
  attributes[:name]
end
