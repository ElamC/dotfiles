alias python="/usr/local/bin/python3"
alias personal="cd ~/personal"
alias cdh="cd ~"

alias dls="docker ps -a"
# https://stackoverflow.com/questions/45141402/build-and-run-dockerfile-with-one-command/59220656#59220656
dbr() {
  docker build --no-cache . | tee /dev/tty | tail -n1 | cut -d' ' -f3 | xargs -I{} docker run --rm -i {}
}
