# stravadata

stravadata is an R package providing convenient access to my [Strava](https://www.strava.com/) activity data.
The package contains the following data frames.

* `activities`: aggregate activity features.
* `streams`: disaggregate activity streams.
* `best_efforts`: activity best efforts.

I obtain these data via the [Strava API](https://developers.strava.com) using the process described [here](https://bldavies.com/blog/accessing-strava-api/).

## Installation

The public version of this package does not include any data.
Users need to add their own.
The steps for doing so are as follows.

1. Clone or fork the repo.
2. Log in to Strava and create an API application on the [API settings](https://www.strava.com/settings/api) page.
  (I put "localhost" in the "Authorization Callback Domain" field.)
3. Create `credentials.yaml` in the repo's top-level directory, and include the API application's client ID and secret as follows:
  ```yaml
  client_id: xxxxx
  secret: xxxxx
  ```
4. Run `make data` in a Terminal window at the repo's top-level directory.
  (This may take some time for users with many Strava activities or a slow internet connection.)

After creating the data, run `make package` in the same Terminal window or `devtools::install()` in a fresh `stravadata.Rproj` instance to install the package.

## Usage

See my blog posts for example use cases:

* [Accessing the Strava API with R](https://bldavies.com/blog/accessing-strava-api/)
* [Comparing my running patterns during 2018 and 2019](https://bldavies.com/blog/comparing-running-patterns-2018-2019/)
* [Activity streams in stravadata](https://bldavies.com/blog/activity-streams-stravadata/)
* [Best efforts in stravadata](https://bldavies.com/blog/best-efforts-stravadata/)

## License

MIT
