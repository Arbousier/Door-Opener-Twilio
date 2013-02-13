# Readme

## Twilio open

Opening a door with a simple phone call.

#### Idea

You call Twilio, twilio contacts the app passing your phone number among the params, the apps check if the number is authorized. If it is the Door.open method is called, if it's not you get told nicely that you are not known and ask if you want to be redirected to a real human.

### Tests

This app is rspec tested, the following command will run the test suite.

```sh
bundle exec rake rspec
```

### Cloudant

Since there is very little to store I decided to play a bit more and use Cloudant to store phone entries. Each entry is simple :

```ruby
{'number' => '0600000000', 'name' => 'Ralph', 'authorized' => true}
```

### Todo

* Create something to add new people easily.
