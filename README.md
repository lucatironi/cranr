CRANr

[ ![Codeship Status for lucatironi/cranr](https://app.codeship.com/projects/7cc31300-985b-0135-163f-5a0d318eb11b/status?branch=master)](https://app.codeship.com/projects/252000)

Setup the app:

```
$ docker-compose build

$ docker-compose run app bin/setup

$ docker-compose up
```

Run the specs (with the docker-compose services up and running):

```
$ docker-compose exec app rspec
```
