#!/bin/bash

############################################################################
#         EDGETX BUILD ENVIRONMENT FOR UBUNTU 23.10 ON A PI400             #
#                                                                          #
#                                                                          #
#  FETCH EVERYTHING ON EDGETX GIT -NEKO KSK-                               #
#  FIND ME ON DISCORD AS  :  LAST HALT NMI  AND/OR  SILENT KEY             #
############################################################################

#EdgeTX is the cutting edge open source firmware for your R/C radio
git clone --recursive -b main https://github.com/EdgeTX/edgetx.git

#SD Card contents and images for EdgeTX
git clone --recursive -b master https://github.com/EdgeTX/edgetx-sdcard.git

#Building EdgeTx in the cloud
git clone --recursive -b master https://github.com/EdgeTX/cloudbuild.git

#User Manual for EdgeTX
git clone --recursive -b 2.11 https://github.com/EdgeTX/edgetx-user-manual.git

#Docker images to build EdgeTX
git clone --recursive -b main https://github.com/EdgeTX/build-edgetx.git

#Sound packs for EdgeTX
git clone --recursive -b main https://github.com/EdgeTX/edgetx-sdcard-sounds.git

#EdgeTX Web pages
git clone --recursive -b master https://github.com/EdgeTX/edgetx.github.io.git

#Support and API documentation for the Lua implementation used in EdgeTX
git clone --recursive -b main https://github.com/EdgeTX/lua-reference-guide.git

#The next generation tool for EdgeTX. A cross platform app, with browser compatibility.
git clone --recursive -b main https://github.com/EdgeTX/buddy.git

#Examples and links other Lua scripts
git clone --recursive -b main https://github.com/EdgeTX/lua-scripts.git

#Themes directory for EdgeTX
git clone --recursive -b main https://github.com/EdgeTX/themes.git

#Powerful and easy-to-use embedded GUI library with many widgets, advanced visual effects (opacity, antialiasing, animations) and low memory requirements (16K RAM, 64K Flash).
git clone --recursive -b master https://github.com/EdgeTX/lvgl.git

#A collection of C++ classes and QtQuick QML components for use with the Qt framework.
git clone --recursive -b master https://github.com/EdgeTX/maxLibQt.git

#Buddy API proxy
git clone --recursive -b master https://github.com/EdgeTX/buddy-proxy.git

#Expose the changes introduced by OpenTX / EdgeTX against vanilla Lua 5.2.2.
git clone --recursive -b main https://github.com/EdgeTX/lua.git

#A place for 'unsupported' scripts, code changes and modifications can be shared
git clone --recursive -b main https://github.com/EdgeTX/playground.git

