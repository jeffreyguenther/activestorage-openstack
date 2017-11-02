# ActiveStorage OpenStack

## Installation

Add this line to your application's Gemfile:

```ruby
gem "mime-types"
gem 'activestorage-openstack'
```

And then execute:

    $ bundle

## Usage

In your `services.yml`, create an entry for your OpenStack service. Like other
services, you can create as many as you want. For example, you might a separate
service definition for staging and production so you can isolate the containers.

```
dev_openstack:
  service: OpenStack
  container: <container name>
  credentials:
    openstack_auth_url: <auth url>
    openstack_username: <username>
    openstack_api_key: <password>
    openstack_project_name: <tenant name>
    openstack_domain_id: default
    openstack_temp_url_key: secret
 connection_options: # optional
```
You can put what the appropriate login params for your version of Keystone in
credentials. They will all be passed to `Fog::Storage::OpenStack.new`.

In your OpenStack provider's dashboard, set your container to private. Next, set
the `Temp-URL-Key` on the container or account. You'll likely have to use the
CLI tools to set this value. Instructions can be found in the [tempUrl
Docs](https://docs.openstack.org/swift/latest/api/temporary_url_middleware.html#secret-keys)

> :warning: If you're using macOS, you might have trouble running the `swift`
command as the Swift compiler has the same name. You might have to call  the
OpenStack swift tool with it's fully qualified name. Check
`/usr/local/bin/swift` if you run into problems. Depending how your `PATH` is
set your mileage may vary. This should get you started in your hunt. :smiley:

## Development

### Todo
- [ ] Support disposition and filename in URLs
- [ ] Fix streaming for downloads
- [ ] Smarly pick whether uploads should be chunked
- [ ] Require mime-types so as to no require extra setup.

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`rake test` to run the tests. You can also run `bin/console` for an interactive
prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release`, which will create a git tag for the version, push
git commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/[USERNAME]/activestorage-openstack. This project is intended
to be a safe, welcoming space for collaboration, and contributors are expected
to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of
conduct.

## License

The gem is available as open source under the terms of the [MIT
License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Activestorage::Openstack project’s codebases, issue
trackers, chat rooms and mailing lists is expected to follow the [code of
conduct](https://github.com/[USERNAME]/activestorage-openstack/blob/master/CODE_OF_CONDUCT.md).
