USAGE

setup_buildenv_ubuntu25.10_arm64.sh

 -setup the build env necessary tools to build edgetx from a arm64/pi5 running ubuntu25.10 

it will create edgetx-venv , when ready to build project dont forget to 

source $HOME/edgetx-venv/bin/activate

ive always build using the method described here for linux on 20.04 
https://github.com/EdgeTX/edgetx/wiki/Build-Instructions-under-Ubuntu-20.04 
adjust accordingly

ive notice my cm5116000 will always crash hung the machine when reaching 100% if in x11 , but not in wayland 
(if not all 4 core/processor shoots to 100% , memory and swap looks normal tho )
i also had to systrace and tee while building and somehow that worked but not without , go figure maybe its heavy for the sdcard..

IE for my tx16s that have lsm6ds33 gyro on the external port i would 

cmake -LAH ../ > ~/edgetx_main-cmake-options.txt && cmake -DPCB=X10 -DPCBREV=TX16S -DDEFAULT_MODE=2 -DGVARS=YES -DIMU_LSM6DS33=YES -DLUA_MIXER=YES -DCMAKE_BUILD_TYPE=Release ../ 

cmake -LAH ../ > ~/edgetx_main-cmake-options.txt && make configure

ulimit -c unlimited

export CORE_PATTERN="/tmp/core.%e.%p"

strace -f -o ~/edgetx/strace-build.log make VERBOSE=1 -j4 firmware 2>&1 | tee ~/edgetx/teebuild.log

strace -f -o ~/edgetx/strace-build.log make VERBOSE=1 -j4 libsimulator 2>&1 | tee ~/edgetx/teebuild.log

...

thats how i got those to build


OPTIONNALY

git-all-edgetx.sh

 - will git all the edge tx repo including the useless ones in the current dir . its pretty well commented edit it yourself if required its usefull


setup_translation_dir.sh

 - setup the translation file location to help find them while compiling the project
PERSONNALISE THE FILE setup_translation_dir.sh THIS IS NECESSARY IF YOU ARE TO RUN IT MY INFO IS THERE AS AN EXAMPLE


NOTE 

since this is made for a CM511600 , its a good idea to help the 100% bottle necking cores and ram with a swap the size of the ram in this case a montruous 16gb for
all the absurd qt6 linking

here how 

urn off swap (so we can resize it):

sudo swapoff /swapfile


Resize the swapfile (to 16 GB):

sudo fallocate -l 16G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile


Turn swap back on:

sudo swapon /swapfile


Verify:

swapon --show
free -h


Now, your system will have 16 GB of swap.
