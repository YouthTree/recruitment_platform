# Youth Tree Recruitment Platform

Youth Tree is a NFP operating out of Perth, Western Australia and this is the simple
recruitment platform application for them.

## About this Application

This app servers to host position descriptions and general position applications for
said positions. The app is written on Rails 3 and the "Youth Tree Stack" - a common
set of technology (haml, sass + compass, coffeescript + barista and a few other things).

The application uses [git-flow](http://github.com/nvie/gitflow), with the `master` branch being used for the current stable
and `develop` being used for the next release. As such, deploying to production should
always use `master` whilst deploying to staging shall always use `develop`.

## Getting Started

To get started with this application, we assume you have an environment set up with
[rvm](http://rvm.beginrescueend.com/), postgres and [git](http://git-scm.org/).

To install the Recruitment Platform itself, run the following:

    git clone git@github.com:YouthTree/recruitment_platform.git

Or, if you're not on the youthtree team,

    git clone git://github.com/YouthTree/recruitment_platform.git

Now, change into the directory.

    cd recruitment_platform

Note that it will ask you if you wish to trust the rvmrc.
Inspect it to make sure it's ok and then accept it. Doing so, will do the following:

* Install ree if not present
* Create a recruitment\platform gemset
* Setup bundler in the gemset

Essentially, it bootstraps an environment ready for the next step.

Now, you can run:

    ./script/configure
    
Which will guide you through:

* Installing all of the gem dependencies
* Configuring `config/settings.yml`
* Configuring `config/database.yml`

Next, you'll want to load some data into your database. If you're on the team
and have access to the server, run:

    cap staging sync:down
    
Which will give you a cleaned version of the staging dataset. Otherwise, run:

    rake db:setup
    
Which loads the schema and creates an initial user.

## Deploying

On the Youth Tree team? Deployment should be a simple matter of:

1. `cap production deploy` - Deploy from `master` to the production server, http://getinvolved.youthtree.org.au/
2. `cap deploy` - Deploy from `develop` to the staging server, http://staging.recruitment.youthtree.org.au/

For more access details, please contact the other members of the team.

## Syncing the Database

Want to work with a copy of production / staging data on your local box?
Assuming you have access the production server, you can do so by running
`cap [environment] sync:down` where environment is `staging` or `production`.

If no environment is passed, the app defaults to `staging`. On import,
To prevent accidental mass emails, all users emails are reset to `example+n@example.com`.

To push your local database to `staging`, you simply do: `cap staging sync:up`.

Note, you can combine these to clone `production` to `staging` with the cleaned
data set by running `./script/sync-db`.

## Contributing

We encourage all community contributions. Keeping this in mind, please follow these general guidelines when contributing:

* Fork the project
* Create a topic branch for what you’re working on (git checkout -b awesome_feature)
* Commit away, push that up (git push your\_remote awesome\_feature)
* Create a new GitHub Issue with the commit, asking for review. Alternatively, send a pull request with details of what you added.
* Once it’s accepted, if you want access to the core repository feel free to ask! Otherwise, you can continue to hack away in your own fork.

Other than that, our guidelines very closely match the GemCutter guidelines [here](http://wiki.github.com/qrush/gemcutter/contribution-guidelines).

(Thanks to [GemCutter](http://wiki.github.com/qrush/gemcutter/) for the contribution guide)

## License

All code is licensed under the New BSD License and is copyright Youth Tree. Please keep this
in mind when contributing.