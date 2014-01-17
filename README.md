# Docker PAL

 * Source: https://github.com/sthulb/docker-pal
 * Website: https://github.com/sthulb/docker-pal

This creates a [Docker](http://docker.io) container for the BBC Page Assembly
Layer. If you don't know what the PAL is, you probably don't need this repo.

## Installation

Clone this repo and run: `docker build -t <yourname>/pal .`, this should build
the required container for using the PAL within Docker.

**Note:** You will need a BBC developer certificate which needs to be placed in
the root of this repo as `dev.bbc.co.uk.pem`

This repo would go nicely with my
[vagrant-coreos-docker](https://github.com/sthulb/vagrant-coreos-docker) repo.


## Usage

You can run the resulting image fairly easily with: `docker run -p 22 -p 80 -p
6081 -t -i <yourname>/pal`

It's even possible to run this concurrently with itself.


## Contributing

If you want to add functionality to this project, pull requests are welcome.

 * Create a branch based off master and do all of your changes with in it.
 * If it you have to pause to add a 'and' anywhere in the title, it should be two pull requests.
 * Make commits of logical units and describe them properly
 * Check for unnecessary whitespace with git diff --check before committing.
 * If possible, submit tests to your patch / new feature so it can be tested easily.
 * Assure nothing is broken by running all the test
 * Please ensure that it complies with coding standards.

**Please raise any issues with this project as a GitHub issue.**


## Credits

 * [@sthulb](https://twitter.com/sthulb)

Docker PAL is © 2014 Simon Thulbourn. It is free software and may be redistributed under the terms
specified in the
[LICENCE](https://github.com/sthulb/docker-pal/tree/master/LICENCE) file.
