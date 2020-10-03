# NattoWrap

NattoWrap is lightweight wrapper library for using **natto**.
It is useful for extracting nouns, converting to MeCabModels and so on from sentences.
To experiment with that code, run `bin/console` for an interactive prompt.

original natto library is at https://github.com/buruzaemon/natto

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'natto_wrap'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install natto_wrap

## Usage

```ruby
require 'natto_wrap'

puts NattoWrap::MeCabModel.to_reading('今日は晴です')

キョウハハレデス


puts NattoWrap::MeCabModel.extract_nouns('今日は晴です').map(&:word)

今日
晴


models = NattoWrap::MeCabModel.convert_model('今日は晴です')
puts models.map { |model| model.to_csv.join(',') }

今日,0,0,0,名詞,副詞可能,*,*,*,*,今日,キョウ,キョー
は,0,0,0,助詞,係助詞,*,*,*,*,は,ハ,ワ
晴,0,0,0,名詞,一般,*,*,*,*,晴,ハレ,ハレ
です,0,0,0,助動詞,*,*,*,特殊・デス,基本形,です,デス,デス
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ksugawara61/natto_wrap. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
