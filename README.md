# Autostopper

Simple script that stops your running AWS EC2 instances.


## REQUIREMENTS

* Ruby 2.5.0


## SETUP

1. Clone the repository, and run `bundle`.
2. Tag your EC2 machines with the tag key `autostopper`, value `true`

As a side-note, only 2 actions are required at the moment, in case you are
leveraging IAM and its policies:

  * ec2:DescribeInstances
  * ec2:StopInstances


### RUNNING THE PROGRAM

#### Without Docker

Make sure your credentials are available to the Ruby program:

    AWS_ACCESS_KEY_ID=... AWS_SECRET_ACCESS_KEY=... ruby main.rb

And... you should be good to go!


#### With Docker

If you prefer using Docker, build the container:

    docker build -t autostopper .

Assuming your AWS credentials are already exported in your environment, you can
run it this way:

    docker run \
      -it --rm \
      -eAWS_ACCESS_KEY_ID \
      -eAWS_SECRET_ACCESS_KEY \
      autostopper


If your credentials are not exported, you could also put them in the `env`
file, and run this command instead:

    docker run \
      -it --rm \
      --env-file env \
      autostopper


## COPYRIGHT

MIT License.
