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


