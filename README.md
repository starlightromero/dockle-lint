# Dockle Lint

This application serves to showcase Docker linting via CI/CD pipeline. The app is a simple API that has one route. A GET request to the / route will make an API call to in order to get the user's IP address, ISP, and location data, including the user's latitude and longitude to the millionth decimal place. All this data will be returned.

If you want to download the code and try it out yourself, you will need to sign up for a free API key from:

```
https://geo.ipify.org/
```

## Software Required

- docker
- docker-compose
- make

## How to Run

Clone the repo
```zsh
git clone git@github.com:starlightromero/dockle-lint.git
```

cd into the directory
```zsh
cd dockle-lint
```

Rename `.env.sample` to `.env`
```zsh
mv .env.sample .env
```

Edit the `.env` file to contain your API Key
```zsh
vim .env
```

Run the application!


## Makefile Commands

`build`: Build app

`start`: Start app at port 8080

`build-compose`: Build app with docker-compose

`start-compose`: Start app with docker-compose

`stop-compose`: Stop app with docker-compose