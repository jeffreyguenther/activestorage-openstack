# ActiveStorage OpenStack

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'activestorage-openstack'
```

And then execute:

    $ bundle

## Usage

In your `services.yml`...

```
dev_openstack:
  service: OpenStack
  container: <container name>
  credentials: #you can put what you want here and it will be directly passed to `Fog::Storage::OpenStack.new`
    openstack_auth_url: <auth url>
    openstack_username: <username>
    openstack_api_key: <password>
    openstack_project_name: <tenant name>
    openstack_domain_id: default
    openstack_temp_url_key: secret
# connection_options:
```

In your cloud hosting service, set your container to private and you'll to set
the `Temp-URL-Key` on the container or account. Depending on your OpenStack
provider, you'll likely have to use the CLI tools to set this value.
Instructions can be found in the [tempUrl
Docs](https://docs.openstack.org/swift/latest/api/temporary_url_middleware.html#secret-keys)

## Development

### Todo
- [ ] Support disposition and filename in URLs
- [ ] Fix streaming for downloads
- [ ] Smarly pick whether uploads should be chunked

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
