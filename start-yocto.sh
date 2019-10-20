yoctobranch=thud
directory=$HOME/yocto

function getsources() {
  remoteurl=$1
  dir=$2
  if [ ! -d ${dir} ]; then
    git clone -b ${yoctobranch} ${remoteurl} $dir
  else
    cd ${dir}
    git pull
    cd - 
  fi
}

if [ ! -e "${directory}" ]; then mkdir -p "${directory}"; fi
cd "${directory}"

getsources git://git.yoctoproject.org/poky.git poky 
getsources https://github.com/agherzan/meta-raspberrypi.git layer/meta-raspberrypi
getsources https://github.com/openembedded/meta-openembedded.git layer/meta-openembedded

source ./poky/oe-init-build-env
