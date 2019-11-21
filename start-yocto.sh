#yoctobranch=master
#yoctobranch=zeus
#yoctobranch=warrior
yoctobranch=thud
directory=$HOME/yocto

function getsources() {
  remoteurl=$1
  dir=$2
  branch=$3
  if [ ! -d ${dir} ]; then
    git clone -b ${branch} ${remoteurl} $dir
  else
    cd ${dir}
    git checkout ${branch}
    git pull
    cd - 
  fi
}

if [ ! -e "${directory}" ]; then mkdir -p "${directory}"; fi
cd "${directory}"

getsources git://git.yoctoproject.org/poky.git poky ${yoctobranch}
getsources https://github.com/agherzan/meta-raspberrypi.git layer/meta-raspberrypi  ${yoctobranch}
getsources https://github.com/openembedded/meta-openembedded.git layer/meta-openembedded ${yoctobranch}
getsources git://git.openembedded.org/openembedded-core layer/openembedded-core ${yoctobranch}

source ./poky/oe-init-build-env
