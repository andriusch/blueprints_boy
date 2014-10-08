blueprint :apple do
  'apple'
end

attributes(name: 'orange').blueprint :orange do |data|
  data.attributes[:name]
end

blueprint :global_cherry, name: 'cherry' do |data|
  data.attributes[:name]
end
