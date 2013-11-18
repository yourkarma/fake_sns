# Fake SNS

A small web app for local SNS development.

This app contains a web interface that lists all the messages sent to it. You
can also edit the messages and send them to an SQS queue of your chosing.

### Noteworthy differences:

* No checking of access keys.

### Implemented:

Nothing

### Actions to be implemented:

* AddPermission
* ConfirmSubscription
* CreatePlatformApplication
* CreatePlatformEndpoint
* CreateTopic
* DeleteEndpoint
* DeletePlatformApplication
* DeleteTopic
* GetEndpointAttributes
* GetPlatformApplicationAttributes
* GetSubscriptionAttributes
* GetTopicAttributes
* ListEndpointsByPlatformApplication
* ListPlatformApplications
* ListSubscriptions
* ListSubscriptionsByTopic
* ListTopics
* Publish
* RemovePermission
* SetEndpointAttributes
* SetPlatformApplicationAttributes
* SetSubscriptionAttributes
* SetTopicAttributes
* Subscribe
* Unsubscribe

## Usage

There are 2 ways of running FakeSNS, as a gem, or as plain Rack app. The first
is easy, the latter is more flexible.

As a gem:

```
$ gem install fake_sns
$ fake_sns -p 9292
```

As a plain Rack app:

```
$ git clone https://github.com/yourkarma/fake_sns
$ cd fake_sns
$ bundle install
$ rackup
```

In both cases, FakeSNS is available at http://localhost:9292

To configure AWS-SDK to send messages here:

``` ruby
AWS.config(
  use_ssl:       false,
  sns_endpoint:  "0.0.0.0",
  sns_port:      9292,
)
```
