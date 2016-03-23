RSpec.describe "Platform Endpoints" do

it "creates a new platform endpoint" do
  arn = sns.create_platform_endpoint(platform_application_arn: "foo", token: "bar").endpoint_arn
  expect(arn).to match(/arn:aws:sns:us-east-1:(\w+)/)

  new_arn = sns.create_platform_endpoint(platform_application_arn: "bar", token: "baz").endpoint_arn
  expect(new_arn).not_to eq arn

  existing_arn = sns.create_platform_endpoint(platform_application_arn: "foo", token: "bar").endpoint_arn
  expect(existing_arn).to eq arn
end

end
