RSpec.describe "Platform Applications" do

it "creates a new platform application" do
  arn = sns.create_platform_application(attributes: {}, name: "foo", platform: "bar").platform_application_arn
  expect(arn).to match(/arn:aws:sns:us-east-1:(\w+)/)

  new_arn = sns.create_platform_application(attributes: {}, name: "bar", platform: "baz").platform_application_arn
  expect(new_arn).not_to eq arn

  existing_arn = sns.create_platform_application(attributes: {}, name: "foo", platform: "bar").platform_application_arn
  expect(existing_arn).to eq arn
end

end
