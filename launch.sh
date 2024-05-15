#!/bin/bash

set -x

FORGE_VERSION=1.18.2-40.2.17
cd /data

if ! [[ "$EULA" = "false" ]] || grep -i true eula.txt; then
	echo "eula=true" > eula.txt
else
	echo "You must accept the EULA by in the container settings."
	exit 9
fi

if ! [[ -f 'DawnCraft%202.0.8%20BETA%20Serverpack.zip' ]]; then
	rm -fr config kubejs libraries mods *.zip forge*.jar
	curl -Lo 'DawnCraft%202.0.8%20BETA%20Serverpack.zip' 'https://edge.forgecdn.net/files/5339/432/DawnCraft%202.0.8%20BETA%20Serverpack.zip' && unzip -u -o 'DawnCraft%202.0.8%20BETA%20Serverpack.zip' -d /data
  curl -Lo forge-${FORGE_VERSION}-installer.jar 'https://maven.minecraftforge.net/net/minecraftforge/forge/'${FORGE_VERSION}'/forge-'${FORGE_VERSION}'-installer.jar'
	java -jar $(ls forge-*-installer.jar) --installServer && rm -f forge-*-installer.jar
fi

if [[ -n "$JVM_OPTS" ]]; then
	sed -i '/-Xm[s,x]/d' user_jvm_args.txt
	for j in ${JVM_OPTS}; do sed -i '$a\'$j'' user_jvm_args.txt; done
fi
if [[ -n "$MOTD" ]]; then
    sed -i "/motd\s*=/ c motd=$MOTD" /data/server.properties
fi
if [[ -n "$LEVEL" ]]; then
    sed -i "/level-name\s*=/ c level-name=$LEVEL" /data/server.properties
fi
if [[ -n "$OPS" ]]; then
    echo $OPS | awk -v RS=, '{print}' > ops.txt
fi
if [[ -n "$ALLOWLIST" ]]; then
    echo $ALLOWLIST | awk -v RS=, '{print}' > white-list.txt
fi

sed -i 's/server-port.*/server-port=25565/g' server.properties

chmod +x run.sh
./run.sh