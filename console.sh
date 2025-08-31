#!/bin/bash
# description     : dockerization console a facade script for development setup of multi component / microservices systems
# author	  : github.com/yodahack
# version         : 2.0-development
# requirements    : Docker version 1.13.1, build 092cba3
# requirements    : docker-compose version 1.8.0
# notes           : developped & tested with Bash 4.3.48(1)-release on Bodhi Linux 16.04
# extra notes     : written originally for adshares.net <3
# license         : https://opensource.org/licenses/MIT

set -e                            # REQUIRED // Exit this process immediately if a sub command returns with a non-zero status
export COMPOSE_IGNORE_ORPHANS=1   # OPTIONAL // Works with docker-compose v1.21.2+

# === Load configuration from .env (same directory as this script) ===
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
if [ -f "$SCRIPT_DIR/.env" ]; then
  set -a
  . "$SCRIPT_DIR/.env"
  set +a
fi
# PROJECT_GROUP from .env becomes the default group; fallback to dev
: "${PROJECT_GROUP:=dev}"
if [ -z "$DOCKER_CONSOLE_DEFAULT_PROJECT_GROUP" ]; then
  export DOCKER_CONSOLE_DEFAULT_PROJECT_GROUP="$PROJECT_GROUP"
fi
# === End .env loading ===


# GLOBAL SETTINGS
if [ -z "$DOCKER_CONSOLE_SCRIPT_PATH" ]
then
  readonly DOCKER_CONSOLE_SCRIPT_PATH="$( pwd )"
  readonly DOCKER_CONSOLE_DOCKERS_DIR="dockers"
  readonly DOCKER_CONSOLE_DOCKERS_DIR_PATH=$DOCKER_CONSOLE_SCRIPT_PATH"/"$DOCKER_CONSOLE_DOCKERS_DIR
  readonly DOCKER_CONSOLE_SCRIPT_NAME=$(basename $0)
  readonly DOCKER_CONSOLE_ARGS=($@)
  readonly DOCKER_CONSOLE_ARGNUM=$#
fi

CC_RED='\033[0;31m'
CC_ORG='\033[0;33m'
CC_BLU='\033[1;34m'
CC_GRE='\033[0;32m'
CC_PUR='\033[1;35m'
CC_CYA='\033[1;36m'
CC_NC='\033[0m'

function console_error {

    echo -e "[${CC_PUR}${DOCKER_CONSOLE_SCRIPT_NAME}${CC_NC}] ${CC_RED}Error${CC_NC}: $1" >&2
}
function console_info {

    echo -e "[${CC_PUR}${DOCKER_CONSOLE_SCRIPT_NAME}${CC_NC}] ${CC_BLU}Info${CC_NC}: $1" >&2
}
function console_okay {

    echo -e "[${CC_PUR}${DOCKER_CONSOLE_SCRIPT_NAME}${CC_NC}] ${CC_GRE}OK${CC_NC}: $1" >&2
}
function console_warn {

    echo -e "[${CC_PUR}${DOCKER_CONSOLE_SCRIPT_NAME}${CC_NC}] ${CC_ORG}Warning${CC_NC}: $1" >&2
}

# DOCKER TOOLS REQUIREMENTS

REQ_UBUNTU="16.04"
REQ_DOCKER="18.03.1"
REQ_COMPOSE="1.21.2"

# Docker version 1.13.1, build 092cba3
# Docker version 18.03.1-ce, build 9ee9f40
# docker-compose version 1.21.2, build a133471

function ver_eq {
  if [ "$1" == "$2" ]
  then
    return
  fi
  return 1
}

function ver_lo {
  if ver_eq $1 $2; then return 1; fi
  v=$(printf "$1\n$2" | sort -V | head -n 1;)
  if ver_eq $v $1; then return 0; fi
  return 1;
}

function ver_hi {
  if ver_eq $1 $2; then return 1; fi
  v=$(printf "$1\n$2" | sort -V | tac | head -n 1;)
  if ver_eq $v $1; then return 0; fi
  return 1;
}

function console_docker_tools_install_help {
    echo
    echo " Requirements:"
    echo
    echo "  * https://github.com/becomewater/dockerization"
    echo
    echo " In case of manual installation, please follow docker docs:"
    echo
    echo "  * https://docs.docker.com/install/"
    echo "  * https://docs.docker.com/compose/install/"
    echo
    echo
    echo " Good luck"
    echo " <3, Team"
    echo " grzechowski.com"
    echo
}

function console_docker_about {
    echo '


                                 ///////*. .^. .////////
                           ,///,                         *///.
                        ///                 ,                 ///
                     //.                   ,,,                   ,//
                  *//                     ,,,,,                     //,
                */*                      ,,,,,,,                      //,
               //                        ,,,,,,,                        //
             */.                         ,,,,,,,                         ,/.
            //       ,,,,,,,,            ,,,,,,,            ,,,,,,,,       /,
           ,/          ,,,,,,,,,,,,      ,,,,,,,      ,,,,,,,,,,,,         ./
           //            ,,,,,,,,,,,,,    ,,,,,    ,,,,,,,,,,,,,            //
          */                ,,,,,,,,,,,,. .,,,  ,,,,,,,,,,,,.                /,
          //                     ,,,,,,,,,  , .,,,,,,,,,                     //
          //                                                                 //
          //                    .,,,,,,,,,  ,  ,,,,,,,,,                     //
          */                ,,,,,,,,,,,,  ,,,,. .,,,,,,,,,,,,                /.
           //            ,,,,,,,,,,,,,    ,,,,,    ,,,,,,,,,,,,,            //
           ./          ,,,,,,,,,,,       ,,,,,,,       ,,,,,,,,,,,         ,/
            */       ,,,,,,,,            ,,,,,,,            ,,,,,,,,       /.
             ./,                         ,,,,,,,                         */
               //                        ,,,,,,,                        //
                .//                      ,,,,,,,                      //
                  .//                     ,,,,,                     //
                     //*                   ,,,                   ///
                        ///                 ,                 ///
                            ////                         ////
                                 ,////////,. .,////////.

                                 originaly done for adshares.net
                                 furthermore used by becomewater.com
                                 to be used by wamjobs.com
                                 MIT / whatever you please

                                 <3 yodahack

				 grzechowski.com
				 github.com/yodahack
				 
				 xn--webkitt-sxa.org
'
}

function console_docker_tools_update_required {

    output=1
    if [ $# -gt 0 ]
    then
      output=0
    fi

    cerr_miss_compose=0
    cerr_miss_docker=0
    command -v docker >/dev/null 2>&1 || { console_error "command 'docker' not found"; cerr_miss_docker=1; }
    command -v docker-compose >/dev/null 2>&1 || { console_error "command 'docker-compose' not found"; cerr_miss_compose=1; }
    if [ "$cerr_miss_docker" -gt 0 -o "$cerr_miss_compose" -gt 0 ]
    then
      console_warn "Minimum required Docker version 1.13.1 (it may differ depending on your specific project needs)"
      console_warn "Minimum required Docker Compose version 1.8.0 (it may differ depending on your specific project needs)"
      return 1
    fi

    compose_v=$(docker-compose -v | cut -d',' -f1 | awk '{print $3}' | cut -d'-' -f1)
    docker_v=$(docker -v | cut -d',' -f1 | awk '{print $3}' | cut -d'-' -f1)

    if ver_lo $compose_v $REQ_COMPOSE
    then
      if [ $output -gt 0 ]; then console_warn "We recommend updating your docker-compose version to $REQ_COMPOSE"; fi
    fi

    if ver_lo $docker_v $REQ_DOCKER
    then
      if [ $output -gt 0 ]; then console_warn "We recommend updating your docker version to $REQ_DOCKER"; fi
    fi

    if ver_lo $compose_v $REQ_COMPOSE || ver_lo $docker_v $REQ_COMPOSE
    then
      if [ $output -gt 0 ]; then console_info "Check if you are compatible with auto-installer by running './$DOCKER_CONSOLE_SCRIPT_NAME update-compat-check'"; fi
      return 1
    fi
}

# CONSOLE general help

function console_help_suggest {
    echo
    echo " What's up? Do you need help? Try:"
    echo
    echo " ./$DOCKER_CONSOLE_SCRIPT_NAME"
    echo "or"
    echo " ./$DOCKER_CONSOLE_SCRIPT_NAME h"
    echo "or"
    echo " ./$DOCKER_CONSOLE_SCRIPT_NAME help"
    echo
}

function console_help {

    (

    # cr=$CC_RED
    # CC_ORG='\033[0;33m'
    # CC_BLU='\033[1;34m'
    cb=$CC_BLU
    co=$CC_ORG
    cc=$CC_CYA
    cg=$CC_GRE
    cn=$CC_NC

    echo -e "
${co}Usage${cn}:

 ${cb}\$${cn} ./$DOCKER_CONSOLE_SCRIPT_NAME [-options] COMMAND [arguments]

${co}Available commands${cn}:

   ${cg}help${cn}                                       # displays this output
   ${cg}examples${cn}                                   # displays help with commands examples

   ${cg}l${cn}|${cg}list${cn}                                     # list available PROJECTS

   ${cg}link${cn}  project  path-to-repo  (number=1)    # link your project with project repository DEV_REPO_(NUMBER)
   ${cg}unlink${cn}  project (number=1)                 # unlink your project with project repository DEV_REPO_(NUMBER)
   ${cg}proxy${cn}  project  path-to-sites-enabled      # link your project with host proxy (req nginx,sudo)

   ${cg}settings${cn}  project                          # displays build settings

   ${cg}b${cn}|${cg}build${cn}  project                           # runs pre-build, builds image, runs post-build
   ${cg}r${cn}|${cg}rebuild${cn}  project                         # runs pre-build, builds all steps of image (NO CACHE), runs post-build
   ${cg}u${cn}|${cg}up${cn}  project                              # runs pre-up, creates containers and starts them, runs post-up
   ${cg}d${cn}|${cg}down${cn}  project                            # runs pre-down, stops containers and destroys them, runs post-down
   ${cg}s${cn}|${cg}start${cn}  project                           # runs pre-start, starts existing containers, runs post-start
   ${cg}p${cn}|${cg}stop${cn}  project                            # runs pre-stop, stops running containers, runs post-stop

   ${cg}e${cn}|${cg}exec${cn} project  script                     # executes script on running conatiners

   ${cg}wipe${cn}                                       # this will remove ABSOLUTELY ALL your docker images and containers

${co}More${cn}:

   ${cg}about${cn}                                      # some about info
   ${cg}req${cn}                                        # requirements

console_docker_tools_install_help
${co}Available options${cn}:

   build:
      ${cc}-s${cn} set1=val1,set2=val2,....             # will overwrite build settings with new values (${cb}batch incompatible${cn})
      ${cc}-r${cn}                                      # will overwrite build settings with default values (${cb}batch incompatible${cn})
    "
    )
}

function console_help_examples {
  (

    cb=$CC_BLU
    co=$CC_ORG
    cp=$CC_PUR
    cn=$CC_NC
    echo -e "
 ${co}Commands examples${cn}:

   # Configure hostnames for ${DOCKER_CONSOLE_DEFAULT_PROJECT_GROUP:-dev} projects (recommended without local host proxy)

    ${cb}\$${cn} cat dockers/${DOCKER_CONSOLE_DEFAULT_PROJECT_GROUP:-dev}/hostnames-dockers >> /etc/hosts

   # Setup, build, up ${DOCKER_CONSOLE_DEFAULT_PROJECT_GROUP:-dev} project

    ${cb}\$${cn} ./console.sh link ${DOCKER_CONSOLE_DEFAULT_PROJECT_GROUP:-dev}/becomewater-website /home/cptJTKirk/becomewater/becomewater-website
    ${cb}\$${cn} ./console.sh b becomewater-website
    ${cb}\$${cn} ./console.sh u becomewater-website

    // in last 2 cases ${DOCKER_CONSOLE_DEFAULT_PROJECT_GROUP:-dev}/ project group is ommited as it is first on the list and will be checked and if projected found selected automatically (with warning)

    // if you have setup your hostnames you can now test it with browser by opening ${cp}http://www.becomewater.dock${cn}

   # Build project with custom build setting

    ${cb}\$${cn} ./console.sh -s resetdata=1 b becomewater-website

    // you can provide multiple custom settings separated by comma

   # Batch commands usage:

    ${cb}\$${cn} ./console.sh u becomewater-website,mailcatcher,....

    // runs up command on automatically selected ${DOCKER_CONSOLE_DEFAULT_PROJECT_GROUP:-dev}/becomewater-website, ${DOCKER_CONSOLE_DEFAULT_PROJECT_GROUP:-dev}/mailcatcher, ${DOCKER_CONSOLE_DEFAULT_PROJECT_GROUP:-dev}/...
    // requires ${DOCKER_CONSOLE_DEFAULT_PROJECT_GROUP:-dev} projects to be linked first with local git repositories
    "
#    ${cb}\$${cn} ./console.sh d,b,u test/becomewater-website,mailcatcher,...
#
#    // runs down, build and up commands on test/becomewater-website, test/mailcatcher and test/.... using first hinted projects group test/ as default
#
#    "
  )
}

# REPO FUNCTIONS (order of usage, general to detail)

function console_project_group_list {
  for i in `find $DOCKER_CONSOLE_DOCKERS_DIR -maxdepth 1 -type d | sed 's/\.\///g' | sed 's/dockers\///g' | grep -v '^dockers$' | grep -v '^\.$' | sort` ; do echo "$i"; done
}

function console_project_list {
  for i in `find $DOCKER_CONSOLE_DOCKERS_DIR -maxdepth 2 -type d | sed 's/\.\///g' | sed 's/dockers\///g' | grep -v '^dockers$' | grep '/'| grep -v '^\.$' | sort` ; do echo "$i"; done
}

function console_project_list_display {
  (
  bsdetect=false
  echo
  echo -e "${CC_ORG}List of available projects${CC_NC}:"
  echo
  for i in $(console_project_list); do if console_project_has_settings $i; then echo -n "  [b] "; else bsdetect=true; echo -n "      "; fi; echo " $i"; done
  echo
  if $bsdetect
  then
    echo
    echo -e "  ${CC_BLU}[b]${CC_NC} - project build use settings"
    echo
  fi
  )
}

function console_project_has_settings {
  if [ -e $DOCKER_CONSOLE_DOCKERS_DIR_PATH/$1/docker/.settings-default ]; then return 0; else return 1; fi
}

function console_project_exist_multi {
  if [ "$(echo $1 | grep -v ',')" != "" ]
  then
    console_project_exist $1
    return
  fi
  (
    fp=$(echo $1|cut -d',' -f1)
    if [[ "$fp" == *"/"* ]]
    then
      export DOCKER_CONSOLE_DEFAULT_PROJECT_GROUP
      DOCKER_CONSOLE_DEFAULT_PROJECT_GROUP=`echo $fp|cut -d'/' -f1`
    fi
    for p in `echo $1 | sed 's/,/ /g'`
    do
      ./$DOCKER_CONSOLE_SCRIPT_NAME $2 $p
    done
  )
  return 1
}

function console_project_exist {

  if [[ "$1" != *"/"* ]]
  then
    if [ ! -z "$DOCKER_CONSOLE_DEFAULT_PROJECT_GROUP" ]
    then
      if console_project_exist_subroutine "$DOCKER_CONSOLE_DEFAULT_PROJECT_GROUP/$1"
      then
        echo "$DOCKER_CONSOLE_DEFAULT_PROJECT_GROUP/$1"
        return 0
      fi
      console_error "Project directory not found [$DOCKER_CONSOLE_DEFAULT_PROJECT_GROUP/$1]"
      console_project_list_display >&2
      return 1
    else
      console_warn "Missing project group [?/$1]"
      for g in $(console_project_group_list)
      do
        console_info "Checking in $g/"
        if console_project_exist_subroutine "$g/$1"
        then
          echo "$g/$1"
          return 0
        fi
      done
    fi
  else
    if console_project_exist_subroutine $1
    then
      echo "$1"
      return 0
    fi
  fi

  console_error "Project directory not found [$1]"
  console_project_list_display >&2
  return 1
}

function console_project_exist_subroutine {

  for i in $(console_project_list)
  do
    if [ "$i" == "$1" ]
    then
      console_okay "Project found $1"
      return 0
    fi
  done
  return 1
}

function console_repo_link_all_set {
    cp "$DOCKER_CONSOLE_DOCKERS_DIR_PATH"/"$1"/docker-compose.yml.tpl "$DOCKER_CONSOLE_DOCKERS_DIR_PATH"/"$1"/docker-compose.yml
    repos=true
    for i in {1..9}
    do
        dev_repo_link="$DOCKER_CONSOLE_DOCKERS_DIR_PATH"/"$1"/DEV_REPO_"$i"
        if [ -e $dev_repo_link ]; then
            repos=false
            dev_repo_link_target=$(cat $dev_repo_link)
            SED_VAR=$(sed 's/\//\\\//g' <<< "$dev_repo_link_target")
            sed -i "s/DEV_REPO_$i/$SED_VAR/g" "$DOCKER_CONSOLE_DOCKERS_DIR_PATH"/"$1"/docker-compose.yml
        fi
    done
    if $repos
    then
      console_warn "This project has no repos configured currently and has a configuration template ($DOCKER_CONSOLE_DOCKERS_DIR_PATH/$1/docker-compose.yml.tpl)"
    fi
}

function console_repo_link {

  if [ ! -e "$DOCKER_CONSOLE_DOCKERS_DIR_PATH"/"$1"/docker-compose.yml.tpl ]
  then
    console_warn "This project has no compose configuration template"
    return 3
  fi

  dev_repo_link="$DOCKER_CONSOLE_DOCKERS_DIR_PATH"/"$1"/DEV_REPO_"$3"
  link_path=$(realpath $2)
  if [ -e $dev_repo_link ]; then
    dev_repo_link_target=$(cat $dev_repo_link)
    console_warn "Already linked repository $1 with $dev_repo_link_target"
	  console_info "Unlinking..."
    console_repo_unlink $1 $3
  fi
  if [ ! -e "$link_path/.git" ]; then
    console_error "Not a valid git repository path: $link_path"
    return 3
  fi
  echo $link_path > $dev_repo_link
  console_repo_link_all_set $1
  console_okay "Project linked with repository directory as requested"
}

function console_repo_unlink {
  dev_repo_link="$DOCKER_CONSOLE_DOCKERS_DIR_PATH"/"$1"/DEV_REPO_"$2"
  if [ -e $dev_repo_link ]; then
    rm $dev_repo_link
    if [ $? -eq 0 ]; then
        console_okay "Project unlinked as requested"
        return
    fi
    console_error "Unlink failed"
    return 4
  fi
  return "$(console_repo_link_check $1)"
}

function console_repo_link_check {
  if [ -e "$DOCKER_CONSOLE_DOCKERS_DIR_PATH"/"$1"/docker-compose.yml ]
  then
    return 0
  fi
  console_error "Error: Project $1 has no ${DOCKER_CONSOLE_DEFAULT_PROJECT_GROUP:-dev} repo linked"
  return 2
}

# HOST PROXY

function console_project_host_proxy {
  proxy_file="$DOCKER_CONSOLE_DOCKERS_DIR_PATH"/"$1"/local.host-proxy.site.nginx.conf
  if [ ! -e "$proxy_file" ]
  then
    console_error "Missing $proxy_file for nginx proxy auto configuration"
    return 5
  fi
  proxy_link_target="$(echo "$(head -n 1 $proxy_file | cut -d '#' -f2)" | sed 's/ //g')"
  nginx_path=${2%/}
  if [ ! -d "$nginx_path" ]
  then
    console_error "Path $nginx_path is not a directory"
    return 5
  fi
  proxy_link_target="$nginx_path"/"$proxy_link_target"
  if [ -e "$proxy_link_target" ]
  then
    console_error "Proxy link target $proxy_link_target already exists"
    return 5
  fi
  console_info "Linking $1 proxy configuration file to $proxy_link_target"
  sudo ln -s $proxy_file $proxy_link_target
  if [ ! -e "$proxy_link_target" ]
  then
    console_error "Linking failed"
    return 5
  fi
  console_okay "DONE!"
  console_info "Please ${CC_RED}RESTART your NGINX server${CC_NC} for the changes to be applied"

  sudo -K
}

# DOCK SETTINGS

CONSOLE_DOCKER_SETTINGS=""
CONSOLE_DOCKER_SETTINGS_RESET=""

function console_docker_settings_preset {
  CONSOLE_DOCKER_SETTINGS=$1
}

function console_docker_settings_reset {
  CONSOLE_DOCKER_SETTINGS_RESET="reset"
}

function console_docker_settings_preset_check_update {
  f=$DOCKER_CONSOLE_DOCKERS_DIR_PATH/$1/docker/.settings
  if [ -z "$CONSOLE_DOCKER_SETTINGS" ] && [ -z "$CONSOLE_DOCKER_SETTINGS_RESET" ]
  then
    if [ ! -e "$f-default" ]
    then
      return 0;
    fi
    if [ ! -e "$f" ]
    then
      cp $f-default $f
    fi
    return 0;
  fi
  if [ ! -e "$f-default" ]
  then
    console_error "Missing default settings file '$1/docker/.settings-default', required for settings validation"
    return 9;
  fi
  if [ ! -e "$f" ]
  then
    cp $f-default $f
  fi
  if [ ! -z "$CONSOLE_DOCKER_SETTINGS_RESET" ]
  then
    console_info "Resetting docker/.settings to default as requested"
    cp $f-default $f
  fi
  for r in $(echo $CONSOLE_DOCKER_SETTINGS | sed "s/,/ /g")
  do
    s=$(echo $r|cut -d'=' -f1)
    v=$(echo $r|sed 's/[^=]*=//')
    set +e
    t=$(cat $f-default|grep "$s")
    set -e
    if [ -z "$t" ]
    then
      console_error "Setting '$s' not found in '$f-default'"
      return 9;
    fi
    console_info "Updating setting config with $s=$v"
    sed -i "s/\(^$s.*=\).*/\1$v/" $f
  done
  return 0;
}

function console_docker_settings_display {
  f=$DOCKER_CONSOLE_DOCKERS_DIR_PATH/$1/docker/.settings

  if [ ! -e "$f-default" ]
  then
    console_warn "Project has no build settings"
    echo
    echo "  Nothing to display"
    echo
    return
  fi
  (

  cb=$CC_BLU
  co=$CC_ORG
  cc=$CC_CYA
  cg=$CC_GRE
  cn=$CC_NC

  echo
  echo -e "[${cb}.settings-default${cn}]"
  cat $f-default
  echo

  if [ ! -e "$f" ]
  then
    echo -e "[.settings] - settings file not yet created"
    echo
    return
  fi

  echo -e "[${cg}.settings${cn}]"
  cat $f
  echo
  )
}

# DOCK SCRIPTS

function console_docker_script_run {
  # we need this here because of dep functions will follow up in this path
  cd $DOCKER_CONSOLE_DOCKERS_DIR_PATH/$1

  script="$2-$3.sh"
  if [ -e ./$script ]
  then
    console_info "Executing script [$script]"
    (
      export DOCKER_CONSOLE_SCRIPT_PATH
      ./$script
    )
    return 0;
  fi

  if [ "$#" -gt 3 ]
  then
    console_error "$script not found in $1 folder"
    return 6;
  fi
}

# DOCKER PROJECT

function console_docker_project_var_set {

  if [ -e $DOCKER_CONSOLE_DOCKERS_DIR_PATH/$1/docker-project ]
  then
    readonly DOCKER_CONSOLE_DOCKER_PROJECT=`head -n 1 $DOCKER_CONSOLE_DOCKERS_DIR_PATH/$1/docker-project`
    return 0;
  fi

  # fallback
  readonly DOCKER_CONSOLE_DOCKER_PROJECT="becomewater-$1"
}

# BUILD

function console_docker_compose_build {

  console_docker_script_run $1 pre build
  docker-compose -p "$DOCKER_CONSOLE_DOCKER_PROJECT" build
  console_docker_script_run $1 post build
}

# REBUILD

function console_docker_compose_rebuild {

  console_docker_script_run $1 pre build
  docker-compose -p "$DOCKER_CONSOLE_DOCKER_PROJECT" build --no-cache
  console_docker_script_run $1 post build
}

# UP

function console_docker_compose_up {

  console_docker_script_run $1 pre up
  docker-compose -p "$DOCKER_CONSOLE_DOCKER_PROJECT" up -d
  console_docker_script_run $1 post up
}

# DOWN

function console_docker_compose_down {

  console_docker_script_run $1 pre down
  docker-compose -p "$DOCKER_CONSOLE_DOCKER_PROJECT" down
  console_docker_script_run $1 post down
}

# START

function console_docker_compose_start {

  console_docker_script_run $1 pre start
  docker-compose -p "$DOCKER_CONSOLE_DOCKER_PROJECT" start
  console_docker_script_run $1 post start
}

# STOP

function console_docker_compose_stop {

  console_docker_script_run $1 pre stop
  docker-compose -p "$DOCKER_CONSOLE_DOCKER_PROJECT" stop
  console_docker_script_run $1 post stop
}

# WIPE

function console_docker_wipe_all {

  echo
  echo ALERT : THIS WILL REMOVE ALL YOUR DOCKER IMAGES AND CONTAINERS IN 15 seconds !!!!
  echo
  echo CTRL+C    - TO CANCEL
  echo

  for i in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15
  do
    sleep 1
    if [ "$i" = 1 ] || [ "$i" = 5 ] || [ "$i" = 10 ] || [ "$i" = 15 ]
    then
      echo -n $i
    else
      echo -n "."
    fi
  done

  echo
  echo "REMOVING ALL CONTAINERS"
  for i in `docker ps -a | awk '{print $1}' | grep -v CONT`; do docker rm $i; done
  echo "REMOVING ALL IMAGES"
  for i in `docker images | awk '{print $3}' | grep -v IMAG`; do docker rmi -f $i; done
  echo "REMOVING ALL NETWORKS"
  for i in `docker network ls | grep default | cut -d' ' -f1`; do docker network rm $i; done
}

# MAIN LOOP

if [ "$#" -eq 0 ]
then
  console_help
  console_docker_tools_update_required
  exit 0
fi

console_loop_escape=0

while [ "$#" -gt 0 ]
do
  case "$1" in
    -r)
      console_docker_settings_reset
      ;;
    -s)
      console_docker_settings_preset $2
      shift
      ;;
    settings)
      p=$(console_project_exist $2)
      console_docker_settings_display $p
      console_loop_escape=1
      ;;
    help)
      console_help
      console_loop_escape=1
      # this is now considered command => so we want to escape
      # but in the future it may be used also as a switch for help and together with command may give help
      ;;

    examples)
      console_help
      console_help_examples
      console_loop_escape=1
      ;;
    list|l)
      console_project_list_display
      console_loop_escape=1
      ;;
    link)
      p=$(console_project_exist $2)
      [ -z "${4}" ] && n='1' || n=${4}
      console_repo_link $p $3 $n
      console_loop_escape=1
      ;;
    unlink)
      p=$(console_project_exist $2)
      [ -z "${3}" ] && n='1' || n=${3}
      console_repo_unlink $p $n
      console_loop_escape=1
      ;;
    proxy)
      p=$(console_project_exist $2)
      console_project_host_proxy $p $3
      console_loop_escape=1
      ;;
    build|b)
      p=$(console_project_exist_multi $2 b)
      console_docker_settings_preset_check_update $p
      console_repo_link_check $p
      console_docker_project_var_set $p
      console_docker_compose_build $p
      console_loop_escape=1
      ;;
    rebuild|r)
      p=$(console_project_exist_multi $2 r)
      console_repo_link_check $p
      console_docker_project_var_set $p
      console_docker_compose_rebuild $p
      console_loop_escape=1
      ;;
    up|u)
      p=$(console_project_exist_multi $2 u)
      console_repo_link_check $p
      console_docker_project_var_set $p
      console_docker_compose_up $p
      console_loop_escape=1
      ;;
    down|d)
      p=$(console_project_exist_multi $2 d)
      console_repo_link_check $p
      console_docker_project_var_set $p
      console_docker_compose_down $p
      console_loop_escape=1
      ;;
    start|s)
      p=$(console_project_exist_multi $2 s)
      console_repo_link_check $p
      console_docker_project_var_set $p
      console_docker_compose_start $p
      console_loop_escape=1
      ;;
    stop|p)
      p=$(console_project_exist_multi $2 p)
      console_repo_link_check $p
      console_docker_project_var_set $p
      console_docker_compose_stop $p
      console_loop_escape=1
      ;;
    exec|e)
      p=$(console_project_exist_multi $2)
      console_repo_link_check $p
      console_docker_project_var_set $p
      console_docker_script_run $p script $3 "validate"
      console_loop_escape=1
      ;;
    wipe)
      console_docker_wipe_all
      console_loop_escape=1
      ;;
    update-compat-check)
      if console_docker_tools_update_required killoutput
      then
        console_info "Update is not needed"
      fi
      if console_docker_tools_autoinstall_check
      then
        if [ $output -gt 0 ]; then console_okay "Your OS is compatible with auto updater"; fi
      fi
      exit
      ;;
    update-docker-toolkit)
      console_docker_tools_autoremove
      console_docker_tools_autoinstall
      exit
      ;;
    req)
      console_docker_tools_install_help
      exit
      ;;
    about)
      console_docker_about
      exit
      ;;
    *)

      # batch commands

      if [ "$console_loop_escape" -gt 0 ]
      then
        break
      fi

      if [[ "$1" == *","* ]]
      then
        cmds=$1
        shift
        cd $DOCKER_CONSOLE_SCRIPT_PATH
        for c in $(echo $cmds | tr "," "\n")
        do
            set +e
            ./$DOCKER_CONSOLE_SCRIPT_NAME $c "$@"
            set -e
        done
        console_loop_escape=1
      fi

      break;
      ;;
  esac
  shift
done

cd $DOCKER_CONSOLE_SCRIPT_PATH

if [ "$console_loop_escape" -eq 0 ]
then
  console_error "command not found"
  console_help_suggest
fi

console_docker_tools_update_required
set +e