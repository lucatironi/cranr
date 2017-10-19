CRANr

Create a docker image with latest Ruby (2.4.2) and basically nothing else:

```
$ docker build -t cranr .
```

Run `bundle` inside the container to generate the `Gemfile.lock` file:

```
$ docker run -v "$PWD:/src" --rm cranr bundle
```

Start a shell inside the container:

```
$ docker run -it -v "$PWD:/src" --rm cranr bash
```

Run some commands inside the container:

```
bundle

bundle exec rspec --init

bundle exec rspec
```

```
$ docker-compose run app bundle --jobs=10 --retry=5

$ docker-compose run app bundle exec rails new . --force --database=postgresql --skip-test --skip-action-cable --skip-bundle
```