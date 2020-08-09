FROM nodered/node-red:latest

USER root
# used by the WIFI Management
RUN apk --no-cache add wireless-tools wpa_supplicant
RUN mkdir -p /etc/wpa_supplicant \
    && chmod 777 /etc/wpa_supplicant
USER node-red

# copied from https://nodered.org/docs/getting-started/docker

# Copy package.json to the WORKDIR so npm builds all
# of your added nodes modules for Node-RED
COPY --chown=node-red:node-red package.json /data/projects/RedFolly/
# RUN ls -lah /data/projects/RedFolly/
RUN cd /data/projects/RedFolly/ \
    && npm install --unsafe-perm --no-update-notifier --no-fund --only=production

# TODO: figure out how to get the package.json dependencies to be installed into node-red
# https://flows.nodered.org/search
RUN cd /usr/src/node-red \
    && npm install node-red-dashboard --save \
    && npm install node-red-contrib-dmxusbpro --save \
    && npm install node-red-contrib-blockly --save \
    && npm install node-red-contrib-mongodb --save \
    && npm install node-red-contrib-timerswitch --save \
    && npm install node-red-contrib-flow-manager  --save

# RUN npx node-red admin install node-red-dashboard
# RUN npx node-red admin install node-red-contrib-dmxusbpro
# RUN npx node-red admin install node-red-contrib-blockly
# RUN npx node-red admin install node-red-contrib-mongodb
# RUN npx node-red admin install node-red-contrib-timerswitch

# Copy _your_ Node-RED project files into place
# NOTE: This will only work if you DO NOT later mount /data as an external volume.
#       If you need to use an external volume for persistence then
#       copy your settings and flows files to that volume instead.
# COPY settings.js /data/settings.js
# COPY flows_cred.json /data/flows_cred.json
# COPY flows.json /data/flows.json
COPY --chown=node-red:node-red . /data/
ENV NODE_RED_ENABLE_PROJECTS=true

# You should add extra nodes via your package.json file but you can also add them here:
#WORKDIR /usr/src/node-red
#RUN npm install node-red-node-smooth

# to enable the WIFI config we need to be root
# probably also true to use the rpi-io
USER root