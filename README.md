# Kickflip

<!--- These are examples. See https://shields.io for others or to customize this set of shields. You might want to include dependencies, project status and licence info here --->
![GitHub repo size](https://img.shields.io/github/repo-size/karsonkalt/kickflip)
![GitHub last commit](https://img.shields.io/github/last-commit/karsonkalt/kickflip)
![Twitter Follow](https://img.shields.io/twitter/follow/karsonkalt?style=social)

Kickflip is a `sinatra` web application that stores information about skateparks in the US.

Any visitor can see data about users and skateparks. Users who have an account can log "checkins" to skateparks and administrators can edit skatepark data.

## Installing Kickflip

To install Kickflip, follow these steps:
* You have installed all required `gems` in the `Gemfile` by running `bundle install`
* Run `shotgun` in the terminal to start run the `ApplicationController`
* Open the port in the browser (`shotgun` defaults to port 9393)

## Using Kickflip

To use Kickflip, follow these steps:

* Create a new account by clicking `Signup`
* Create a unique username
* Search for a skatepark using the `search` function in the `Parks` tab. You can search for name of a skatepark or by location.
* Checkin to a skatepark by clicking `Checkin`. You will not be able to checkin to another skatepark for 5 minutes.
* The user with the most checkins at a skatepark becomes "King of the Park" and a badge is added to their profile and the skatepark.

## Creating Admin Accounts

There is no way to give a `User` administrator privledges in the front end interface

Once a User is created, to give them administrator privledges:

* Run `rake console` in the top level directory
* Select the `User` you would like to find by running `user = User.find(<id_of_user>)`
* Change their admin privledges by running `user.admin_status = true`
* Save to the database  by running `user.save`
* The console should return `true` to indicate the user is now an administrator.
* Admins will see a star next to their username when they log in on the front end

## Contributing to Kickflip
To contribute to Kickflip, follow these steps:

1. Fork this repository.
2. Create a branch: `git checkout -b <branch_name>`.
3. Make your changes and commit them: `git commit -m '<commit_message>'`
4. Push to the original branch: `git push origin <project_name>/<location>`
5. Create the pull request.

Alternatively see the GitHub documentation on [creating a pull request](https://help.github.com/en/github/collaborating-with-issues-and-pull-requests/creating-a-pull-request).

## Contributors

This project was created by [@karsonkalt](https://github.com/karsonkalt) as a student of [Flatiron School Software Engineering](https://flatironschool.com/)

## Contact

If you want to contact me you can reach me on Twitter at [@karsonkalt](http://www.twitter.com/karsonkalt)

## License
<!--- If you're not sure which open license to use see https://choosealicense.com/--->

This project uses the following license: [BSD 2-Clause License](</LICENSE.txt>).