# CKAN Docker Container

[![Build Status](https://travis-ci.org/UKHomeOffice/docker-ckan.svg)](https://travis-ci.org/UKHomeOffice/docker-ckan) [![GitHub version](https://badge.fury.io/gh/ukhomeoffice%2Fdocker-ckan.svg)](https://badge.fury.io/gh/ukhomeoffice%2Fdocker-ckan) [![Docker Repository on Quay.io](https://quay.io/repository/ukhomeofficedigital/ckan/status "Docker Repository on Quay.io")](https://quay.io/repository/ukhomeofficedigital/ckan)

This is the home office packaging of [CKAN](http://ckan.org/)

## Getting Started

These instructions will cover usage information and for the docker container

### Prerequisites


In order to run this container you'll need docker installed.

* [Windows](https://docs.docker.com/windows/started)
* [OS X](https://docs.docker.com/mac/started/)
* [Linux](https://docs.docker.com/linux/started/)

### Usage

#### Get started quick

This will get CKAN running

```
docker run -d --privileged=true --name solr milafrerichs/ckan_solr
docker run -d --privileged=true --name db ckan/postgresql
docker run -p 5000:5000 \
           --link db:db \
           --link solr:solr \
           quay.io/ukhomeofficedigital/ckan:$CONTAINER_VERSION
```

Then Point your browser at `https://<your-docker-host>:5000` and you'll see ckan.

#### TLS Parameters

TLS is enabled by default in this container, and we dynamically create a self signed certificate if no certificate is created.
If you'd like to implement your own certs then simply mount then into `/etc/httpd/ssl`

```
docker run -p 5000:5000 \
           --link db:db \
           --link solr:solr \
           -v /path/to/certs:/etc/httpd/ssl
           quay.io/ukhomeofficedigital/ckan:$CONTAINER_VERSION
```

We also allow you to define the domain for your self-signed tls certs, just use the `DOMAIN` env variable.

#### Container Parameters

If you run the container without parameters, just run it

```shell
docker run quay.io/ukhomeofficedigital/ckan:$CONTAINER_VERSION
```

If you pass a parameter to the container we'll try to run it, so

```shell
docker run quay.io/ukhomeofficedigital/ckan:$CONTAINER_VERSION bash
```

#### Environment Variables

* `DATABASE_URL` - URL for the primary database, in the format expected by sqlalchemy (required
                   unless linked to a container called 'db')
* `SOLR_URL` - URL for solr (required unless linked to a container called 'solr')

* `DOMAIN` - Domain for ckan to run under, defaults to `localhost`

* `DB_CREDS` - Path to file where username and password are stored (useful for vault_sidekick)

#### Volumes

* `/var/lib/ckan` - CKAN Data Directory

#### Useful File Locations

* `/userscripts` - All executable files in this directory will be executed before starting ckan
* `/app/ckan/plugins` - All plugins placed in here will be added to ckan by running `python setup.py develop` on them

## Built With

* CKAN 2.4.1

## Find Us

* [GitHub](https://github.com/UKHomeOffice/docker-ckan)
* [Quay.io](https://quay.io/repository/ukhomeofficedigital/ckan)

## Contributing

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct, and the process for submitting pull requests to us.

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the
[tags on this repository](https://github.com/UKHomeOffice/docker-ckan/tags).

## Authors

See the list of [contributors](https://github.com/UKHomeOffice/docker-ckan/contributors) who
participated in this project.

## License

This project is licensed under the GPLv2 License - see the [LICENSE.md](LICENSE.md) file for details.
