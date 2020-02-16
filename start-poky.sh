dir=$HOME/workspace/external-projects/poky
if [ ! -d $dir ]; then
    mkdir -p $dir && cd $dir && cd .. && rmdir poky && \
    git clone https://github.com/kraj/poky.git && \
    cd $dir
else
    cd $dir && \
    git pull 
fi
source oe-init-build-env
