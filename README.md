# CRANr

A simple Ruby (on Rails) indexer for the CRAN server.

[ ![Codeship Status for lucatironi/cranr](https://app.codeship.com/projects/7cc31300-985b-0135-163f-5a0d318eb11b/status?branch=master)](https://app.codeship.com/projects/252000)

The app uses **Rails** 5.1.4 with a **Postgres** Database and a **Redis** store for enqueueing jobs with **Resque**. **RSpec** is used for the test suite.
The development is possible using **Docker** and **docker-compose** to launch the services (app, worker, db, redis) without having to install anything on the local machine (given that Docker is available).

The app is deployed on **Heroku** ([cranr.herokuapp.com](https://cranr.herokuapp.com)) while **CodeShip** is used as a CI service. The app is deployed on Heroku only if the build is green.

A rake task `index_cran_server` has been scheduled every day at 12PM UTC with the Heroku Scheduler: it will retrieve the 50 first packages from the [PACKAGES](https://cran.r-project.org/src/contrib/PACKAGES) file and will update the packages on the app if there are new ones.

## Setup the app:

```
$ docker-compose build

$ docker-compose run app bin/setup

$ docker-compose up
```

Run the specs (with the docker-compose services up and running):

```
$ docker-compose exec app rspec
```

Run the rake task to populate the database with the packages from the CRAN server:

```
$ docker-compose exec app bin/rails index_cran_server
```
