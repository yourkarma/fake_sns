# Fake SNS

A small web app for local SNS development.

It contains a small store to inspect, and some methods to inspect and change the
contents, so you can create scenarios.

### Noteworthy differences:

* No checking of access keys.
* Returns all topics, not just 100, no support for `NextToken` parameter.

### Implemented:

* CreateTopic
* ListTopics
* DeleteTopic
* GetTopicAttributes
* SetTopicAttributes
* ListSubscriptions
* ListSubscriptionsByTopic

### Under Construction

* Subscribe
* Publish

### Actions to be implemented:

* AddPermission
* ConfirmSubscription
* CreatePlatformApplication
* CreatePlatformEndpoint
* DeleteEndpoint
* DeletePlatformApplication
* GetEndpointAttributes
* GetPlatformApplicationAttributes
* GetSubscriptionAttributes
* ListEndpointsByPlatformApplication
* ListPlatformApplications
* RemovePermission
* SetEndpointAttributes
* SetPlatformApplicationAttributes
* SetSubscriptionAttributes
* Unsubscribe

## Usage

There are 2 ways of running FakeSNS, as a gem, or as plain Rack app. The first
is easy, the latter is more flexible.

As a gem:

```
$ gem install fake_sns
$ fake_sns -p 9292
```

To configure AWS-SDK to send messages here:

``` ruby
AWS.config(
  use_ssl:       false,
  sns_endpoint:  "0.0.0.0",
  sns_port:      9292,
)
```

### Command line options

Get help by running `fake_sns --help`. These options are basically the same as
Sinatra's options. Here are the SNS specific options:

* Store the database somewhere else: `--database FILENAME` or
specify an in memory database that will be lost: `--database :memory:`

### Extra endpoints

To get a YAML representation of all the data known to FakeSNS, do a GET request
to the root path:

```
curl -X GET http://localhost:9292/
```

To change the database, submit the contents you got from the previous step,
augment it and submit it as the body of a PATCH request:

```
curl -X GET http://localhost:9292/ -o my-data.yml
vim my-data.yml
curl -X PATCH --data @my-data.yml http://localhost:9292/
```

To reset the entire database, send a DELETE request:

```
curl -X DELETE http://localhost:9292/
```

### Test Integration

When making integration tests for your app, you can easily include Fake SNS.

Here are the methods you need to run FakeSNS programmatically.

``` ruby
require "fake_sns/test_integration"

# globally, before the test suite starts:
AWS.config(
  use_ssl:            false,
  sns_endpoint:       "localhost",
  sns_port:           4568,
  access_key_id:      "fake access key",
  secret_access_key:  "fake secret key",
)
fake_sns = FakeSNS::TestIntegration.new

# before each test that requires SNS:
fake_sns.start

# at the end of the suite:
at_exit {
  fake_sns.stop
}

# for debugging, get everything FakeSNS knows:

puts fake_sns.data.inspect
```

See `spec/spec_helper.rb` in this project for an example on how to load it in
your test suite.

---

## More information

* [API Reference](http://docs.aws.amazon.com/sns/latest/api/API_Operations.html)
* [AWS-SDK docs](http://rubydoc.info/gems/aws-sdk/frames)
* [Fake SQS](https://github.com/iain/fake_sqs)
