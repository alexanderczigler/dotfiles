#
#
#
###
## Aliases
#

alias gp="git pull --rebase --autostash"
alias v2resetdb="docker-compose down && docker volume rm v2_db-data || true && docker-compose up -d"
alias v2envrc="cp ~/Documents/v2.api.envrc ~/Code/v2/api/.envrc && cp ~/Documents/v2.cabby.envrc ~/Code/v2/cabby/.envrc && cp ~/Documents/v2.web.env ~/Code/v2/web/.env"
alias eks_mrf="aws --profile motorbranschen eks --region eu-north-1 update-kubeconfig --name ci"
alias eks_iteam="aws --profile iteam eks --region eu-north-1 update-kubeconfig --name gitlab-eks"
