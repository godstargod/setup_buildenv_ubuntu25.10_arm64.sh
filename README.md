USAGE
setup_buildenv_ubuntu25.10_arm64.sh
 -setup the build env necessary tools to build edgetx from ubuntu25.10 for an arm64

it will create edgetx-venv , when ready to build project dont forget to 

source $HOME/edgetx-venv/bin/activate

ive always build using the method described here for linux on 20.04 
https://github.com/EdgeTX/edgetx/wiki/Build-Instructions-under-Ubuntu-20.04 
adjust accordingly

ive notice my cm5116000 will always crashed when reaching 100% if in x11 , but not in wayland
i also had to systrace and tee while building and showhow that worked but not without , go figure

ie for my tx16s that have lsm6ds33 gyro on the external port i would 
cmake -LAH ../ > ~/edgetx_main-cmake-options.txt && cmake -DPCB=X10 -DPCBREV=TX16S -DDEFAULT_MODE=2 -DGVARS=YES -DIMU_LSM6DS33=YES -DLUA_MIXER=YES -DCMAKE_BUILD_TYPE=Release ../ && cmake -LAH ../ > ~/edgetx_main-cmake-options.txt && make configure
ulimit -c unlimited
export CORE_PATTERN="/tmp/core.%e.%p"
strace -f -o ~/edgetx/strace-build.log make VERBOSE=1 -j4 firmware 2>&1 | tee ~/edgetx/teebuild.log
strace -f -o ~/edgetx/strace-build.log make VERBOSE=1 -j4 libsimulator 2>&1 | tee ~/edgetx/teebuild.log
...

thats how i got those to buid


OPTIONNALY
setup_translation_dir.sh
 - setup the translation file location to help find them while compiling the project
PERSONNALISE THE FILE setup_translation_dir.sh THIS IS NECESSARY IF YOU ARE TO RUN IT MY INFO IS THERE AS AN EXAMPLE

