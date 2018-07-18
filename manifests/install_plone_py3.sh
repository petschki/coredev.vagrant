#!/bin/sh

# usage: ./install_plone.sh

AS_VAGRANT="sudo -u vagrant"
SHARED_DIR="/vagrant"
INSTALL_TARGET="coredev_py3"
VHOME="/home/vagrant"
COREDEV_D="$VHOME/${INSTALL_TARGET}"
COREDEV_URL="https://github.com/plone/buildout.coredev.git"
MY_PYTHON="Python-3.6"
PYTHON_VB="$VHOME/$MY_PYTHON"

# install pip and virtualenv for python 3.6
wget -q https://bootstrap.pypa.io/get-pip.py
python3.6 get-pip.py 1>/dev/null
pip3.6 install virtualenv
ln -sf /usr/local/bin/virtualenv /usr/local/bin/virtualenv3.6

if [ ! -d $MY_PYTHON ]; then
    echo "Creating a Python 3 virtualenv ..."
    $AS_VAGRANT virtualenv3.6 -q $PYTHON_VB
    if [ ! -x $PYTHON_VB ]; then
        echo "Failed to create virtualenv for $MY_PYTHON"
        exit 1
    fi
fi

if [ ! -d $INSTALL_TARGET ]; then
    echo "Getting a clone of ${INSTALL_TARGET} from github"
    $AS_VAGRANT git clone -b 5.2 $COREDEV_URL $INSTALL_TARGET
    if [ ! -d $INSTALL_TARGET ]; then
        echo "Failed to checkout buildout.coredev"
        exit 1
    fi
    cd $COREDEV_D
    if [ ! -f requirements.txt ]; then
        echo "requirements.txt missing. This is a bad checkout."
        exit 1
    fi
    echo "Bootstrapping buildout..."
    $AS_VAGRANT $PYTHON_VB/bin/pip install -r requirements.txt 2> /dev/null
    if [ ! -x $PYTHON_VB/bin/buildout ]; then
        echo "${PYTHON_VB}/bin/buildout missing. \"${PYTHON_VB}/bin/pip install -r requirements.txt\" failed."
        exit 1
    fi
else
    if [ -x $PYTHON_VB/bin/buildout ]; then
        cd $COREDEV_D
        $AS_VAGRANT $PYTHON_VB/bin/buildout -c py3.cfg
    fi
fi

# put .cfg and src into the shared directory,
# and link back to them.
if [ ! -d ${SHARED_DIR}/${INSTALL_TARGET} ]; then
    echo Moving commonly edited source files into shared directory
    echo and linking them back to coredev instance.
    echo ${SHARED_DIR}/${INSTALL_TARGET}
    $AS_VAGRANT mkdir ${SHARED_DIR}/${INSTALL_TARGET}
fi

for fn in ${COREDEV_D}/*.cfg; do
    bn=`basename $fn`
    if [ ! -f ${SHARED_DIR}/${INSTALL_TARGET}/$bn ]; then
        mv ${COREDEV_D}/$bn ${SHARED_DIR}/${INSTALL_TARGET}
        $AS_VAGRANT ln -s ${SHARED_DIR}/${INSTALL_TARGET}/$bn $COREDEV_D
    fi
done

# symbolic link for downloaded sources
if [ ! -d ${SHARED_DIR}/${INSTALL_TARGET}/src ]; then
    if [ -d ${COREDEV_D}/src ]; then
        mv ${COREDEV_D}/src ${SHARED_DIR}/${INSTALL_TARGET}
    else
        mkdir ${SHARED_DIR}/${INSTALL_TARGET}/src
    fi
    $AS_VAGRANT ln -s ${SHARED_DIR}/${INSTALL_TARGET}/src $COREDEV_D
fi


cd $VHOME
for script in ${SHARED_DIR}/manifests/guest_scripts/*; do
    if [ ! -f `basename $script` ]; then
        $AS_VAGRANT cp $script .
        chmod 755 *.sh
    fi
done

echo
echo "DONE!"
echo "Shared files are in ${COREDEV_D}."
echo "You may run the buildout by running 'vagrant provision' or manually with 'vagrant ssh'"
