Given(/^I have (\w+)$/) do |name|
  build name.to_sym
end
Then(/^(\w+) should (NOT )?be available$/) do |name, negative|
  data = blueprint_data(name.to_sym)
  if negative
    expect(data).to be_nil
  else
    expect(data).not_to be_nil
  end
end
When(/^(\w+) should equal "([^"]*)"/) do |name, value|
  expect(send(name)).to eq(value)
end
Then(/^I change global_cherry$/) do
  global_cherry << ' modified'
end
