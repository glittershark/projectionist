[![Gem Version](https://badge.fury.io/rb/projectionist.svg)](http://badge.fury.io/rb/projectionist)
[![Build Status](https://travis-ci.org/glittershark/projectionist.svg?branch=master)](https://travis-ci.org/glittershark/projectionist)
[![Coverage Status](https://coveralls.io/repos/glittershark/projectionist/badge.png?branch=master)](https://coveralls.io/r/glittershark/projectionist?branch=master)
[![Code Climate](https://codeclimate.com/github/glittershark/projectionist.png)](https://codeclimate.com/github/glittershark/projectionist)
[![Dependency Status](https://gemnasium.com/glittershark/projectionist.svg)](https://gemnasium.com/glittershark/projectionist)

# Projectionist 

Quickly edit project files using the [.projections.json](https://github.com/tpope/vim-projectionist) format

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

Note that there are two glob components here - `**` and `*`. When editing files, these components are separated by a `/`

