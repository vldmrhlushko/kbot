## Import pakage 
telebot "gopkg.in/telebot.v3

## Edit kbot.go according to your needs

## build your bin file
gofmt -s -w ./  ## formatting 
go get ## downloading and installing packages end dependencies
go build -ldflags "-X="github.com/den-vasyliev/kbot/cmd.appVersion=v1.0.1

## register your bot in telegram using BotFather and copy TOKEN

## assign env safely
read -s TELE_TOKEN
echo $TELE_TOKEN
export TELE_TOKEN

# start app and check 
./kbot start



# Next Lesson
## Makefile creation. A Makefile is just a simple way to standardize and automate repetitive commands like build, test, lint, versioning

## list steps, begin with format, then build. As a version you can choose attributes from git repository and assign variables: describe --tags --abbrev=0    git rev-parse --short HEAD

## Add rules of Dokerfile for building image to Makefile



