
---

### **README: Build Environment Setup and Usage Guide**

---

#### **USAGE**

**setup_buildenv_ubuntu25.10_arm64.sh**

* **Purpose:** Sets up the necessary tools and environment to build EdgeTX on an ARM64/Pi5 running Ubuntu 25.10.
* **Creates**: `edgetx-venv` virtual environment.
* **Important**: After setup, don’t forget to activate the virtual environment before building:

  ```bash
  source $HOME/edgetx-venv/bin/activate
  ```

I've always built using the method described [here for Ubuntu 20.04](https://github.com/EdgeTX/edgetx/wiki/Build-Instructions-under-Ubuntu-20.04).
Adjust accordingly.

---

#### **EXAMPLE: Building for TX16S**

For my **TX16S** with an **LSM6DS33 gyro** on the external port, I use the following CMake commands:

```bash
cmake -LAH ../ > ~/edgetx_main-cmake-options.txt && \
cmake -DPCB=X10 -DPCBREV=TX16S -DDEFAULT_MODE=2 -DGVARS=YES -DIMU_LSM6DS33=YES -DLUA_MIXER=YES -DCMAKE_BUILD_TYPE=Release ../
```

Then, configure with:

```bash
cmake -LAH ../ > ~/edgetx_main-cmake-options.txt && make configure
```

Next, adjust core limits:

```bash
ulimit -c unlimited
export CORE_PATTERN="/tmp/core.%e.%p"
```

Finally, build with `strace` logging:

```bash
strace -f -o ~/edgetx/strace-build.log make VERBOSE=1 -j4 firmware 2>&1 | tee ~/edgetx/teebuild.log
strace -f -o ~/edgetx/strace-build.log make VERBOSE=1 -j4 libsimulator 2>&1 | tee ~/edgetx/teebuild.log
```

These commands are how I successfully built the project.

---

#### **OPTIONAL SCRIPTS**

**git-all-edgetx.sh**

* **Purpose:** This script will clone all EdgeTX repos, including the less useful ones, into your current directory.
* It’s **well-commented**—feel free to edit it as needed.

---

**setup_translation_dir.sh**

* **Purpose:** Configures the location for translation files to be used during the build.
* **Important:** You must **personalize this file**. My information is provided as an example.

---

#### **IMPORTANT NOTES**

Since this setup is designed for the **CM511600** hardware, **swap** can help alleviate the bottleneck caused by limited cores and RAM during the build process.

The build, especially with Qt6 dependencies, can push the system to its limits (100% CPU, 100% RAM). Monitor ing with `htop` during builds will show the strain, and swap will help prevent freezing.
For best results, I recommend setting up **16 GB of swap** to handle the heavy workload.

---

#### **How to Set Up Swap:**

1. **Turn off swap** (if it’s already enabled):

   ```bash
   sudo swapoff /swapfile
   ```

2. **Resize the swap file** to 16 GB:

   ```bash
   sudo fallocate -l 16G /swapfile
   sudo chmod 600 /swapfile
   sudo mkswap /swapfile
   ```

3. **Turn swap back on**:

   ```bash
   sudo swapon /swapfile
   ```

4. **Verify swap status**:

   ```bash
   swapon --show
   free -h
   ```

---

#### **Set Swappiness to 10:**

1. **Check current swappiness**:

   ```bash
   cat /proc/sys/vm/swappiness
   ```

2. **Set swappiness to 10** (or another preferred value):

   ```bash
   sudo sysctl vm.swappiness=10
   ```

3. **Make the change permanent**:

   Create a custom configuration file in `/etc/sysctl.d/`:

   ```bash
   sudo nano /etc/sysctl.d/99-swappiness.conf
   ```

   Add the following line to the file:

   ```
   vm.swappiness=10
   ```

   Save and exit (`CTRL + X`, then `Y`, and `Enter`).

4. **Apply the change**:

   ```bash
   sudo sysctl --system
   ```

5. **Verify** again:

   ```bash
   cat /proc/sys/vm/swappiness
   ```

---

#### **SUCCESSFULLY BUILT ON:**

* **Wayland Plasma**

#### **BUILDS SUCCESSFULLY RAN ON:**
  
* **X11 Plasma**
* **Wayland Plasma**

Tested successfully with the following components:

* `firmware`
* `libsimulator`
* `simu`
* `companion`
* `simulator`
