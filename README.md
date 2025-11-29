
USAGE

setup_buildenv_ubuntu25.10_arm64.sh

 -setup the build env necessary tools to build edgetx from a arm64/pi5 running ubuntu25.10

it will create edgetx-venv , when ready to build project dont forget to 

source $HOME/edgetx-venv/bin/activate

ive always build using the method described here for linux on 20.04 
https://github.com/EdgeTX/edgetx/wiki/Build-Instructions-under-Ubuntu-20.04 
adjust accordingly


EXAMPLE

for my tx16s that have lsm6ds33 gyro on the external port i would 

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


IMPORTANTLY

since this is made for a CM511600 , its a good idea to help the 100% bottle necking cores and ram with a swap the size of the ram in this case a montruous 16gb for
all the absurd qt6 linking . its the only way i got success as the machine will be pushed to its limit , ive monitor with htop from another shell while building to see all that 
( the 4 processors will get to 100%, 16gb ram up to 100% too and expect libsimulator and companion to reach 9-10GB swap saving the whole thing from freezing )


here how 

Turn off swap (so we can resize it if theres one already):

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

Final Steps

Check current swappiness:

cat /proc/sys/vm/swappiness


Set swappiness to 10 (or your preferred value 0-1 being lowest 60 seems to be the default will use it more agressively):

sudo sysctl vm.swappiness=10

Now, your system will have 16 GB of swap. that tirggers at like 90% cpu usage with an sdcard ready to build the heavy parts of the project. ..and in retrospect necessary 



And here's how you can set the swappiness permanently:

1. Create a new configuration file for swappiness

You can create a custom .conf file in /etc/sysctl.d/ for your swappiness setting.

Open a new file (e.g., 99-swappiness.conf):

sudo nano /etc/sysctl.d/99-swappiness.conf

2. Add the swappiness setting

In the file, add the following line:

vm.swappiness=10

3. Save and exit

Press CTRL + X, then Y to confirm, and Enter to save.

4. Apply the changes

Apply the settings immediately without needing a reboot:

sudo sysctl --system

5. Verify

Check the current swappiness value:

cat /proc/sys/vm/swappiness



SUCESSFULLY BUILD ON WAYLAND PLASMA,AND CONFIRM BUILDS WORKED IN X11 PLASMA AND WAYLAND PLASMA.

 -firmware

 -libsimulator
 
 -simu
 
 -companion
 
 -simulator
