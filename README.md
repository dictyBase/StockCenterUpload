# Stock Center Upload  [![Build Status](https://travis-ci.org/[dictyBase]/[StockCenterUpload].png)](https://travis-ci.org/[dictyBase]/[StockCenterUpload])

A Mojolicious web application to upload stock center data; using Plupload.

### Getting started


### Deployment


### Testing
* Modules required for testing the application can be install using `carton` as

```shell
carton install Test::More Test::Moose Test::Exception Test::Mojo
```

* All the tests can be found in the `t/` folder. For running the test follow steps below

```shell
carton exec perl Build.PL
./Build test
```

OR to run one test at a time

```shell
./Build test --test_files t/01-row.t verbose=1
```

Tests can be run one-by-one using `App::prove`

```shell
prove -Ilib t/02-header.t -v
```