#!/bin/bash
# S3 installer and configurator
#
# Installs S3 and creates a minimal configuration file.
set -ex

: ${access_key_id:?}
: ${secret_access_key:?}

cat <<EOF > /root/.s3cfg
[default]
access_key = ${access_key_id}
secret_key = ${secret_access_key}
EOF

apt-get -y install s3cmd

# Wrapper around S3 command to allow retry until
# bucket of interest is populated.
s3cmd_wrapper ()
{
    while ! /usr/bin/s3cmd $@; do
        sleep 5
    done
}
