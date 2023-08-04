FROM quay.io/keycloak/keycloak:latest as builder

COPY keycloak-build.conf /conf/keycloak.conf

WORKDIR /opt/keycloak
# for demonstration purposes only, please make sure to use proper certificates in production instead
RUN keytool -genkeypair -storepass password -storetype PKCS12 -keyalg RSA -keysize 2048 -dname "CN=server" -alias server -ext "SAN:c=DNS:localhost,IP:127.0.0.1" -keystore conf/server.keystore
RUN /opt/keycloak/bin/kc.sh build

FROM quay.io/keycloak/keycloak:latest
COPY --from=builder /opt/keycloak/ /opt/keycloak/
COPY keycloak-run.conf /conf/keycloak.conf

ENTRYPOINT ["/opt/keycloak/bin/kc.sh"]
