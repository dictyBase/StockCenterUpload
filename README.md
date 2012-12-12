# Stock Center Upload [![Build Status](https://secure.travis-ci.org/dictyBase/StockCenterUpload.png?branch=develop)](https://travis-ci.org/dictyBase/StockCenterUpload)
A Mojolicious web application to upload stock center data; using Plupload.

### Getting started


### Deployment
* Deployment setup is done using [deploy-task](https://github.com/dictyBase/deploy-task)

### Testing
* Modules required for testing the application can be installed using `carton` as

```shell
carton install Test::More Test::Moose Test::Exception Test::Mojo
```

* All the tests can be found in the `t/` folder. For running the test follow steps below

```shell
carton exec perl Build.PL
./Build test
```

__OR__, to run one test at a time

```shell
./Build test --test_files t/01-row.t verbose=1
```

Tests can be run one-by-one using `App::prove`

```shell
prove -Ilib t/02-header.t -v
```
