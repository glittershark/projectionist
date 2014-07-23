[![Gem Version](https://badge.fury.io/rb/projectionist.svg)](http://badge.fury.io/rb/projectionist)
[![Build Status](https://travis-ci.org/glittershark/projectionist.svg?branch=master)](https://travis-ci.org/glittershark/projectionist)
[![Code Climate](https://codeclimate.com/github/glittershark/projectionist.png)](https://codeclimate.com/github/glittershark/projectionist)
[![Dependency Status](https://gemnasium.com/glittershark/projectionist.svg)](https://gemnasium.com/glittershark/projectionist)

# Projectionist 

Command-line interface to the [.projections.json](https://github.com/tpope/vim-projectionist) format - WIP

## Installation

    $ gem install projectionist

## Usage

For ease of typing, the executable file for projectionist is `prj`.

Given a `.projections.json` file in the root of your project with the following structure:

```
{
    "lib/**/*.rb": {
        "type": "lib"
    }
}
```

The command to edit `lib/whatever/test.rb` would be:

    $ prj edit lib whatever/test


## Contributing

1. [Fork it](https://github.com/glittershark/projectionist/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

