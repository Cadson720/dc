FROM gradle: jkd21-jammy as build

ADD services /home/gradle/services
ADD assets /home/gradle/assets

WORKDIR /home/gradle/services

RUN gradle build --no-daemon

RUN tar -xvf server/build/distributions/app-bundle.tar

FROM eclipse-temurin:21-jdk-jammy

WORKDIR app

COPY --from=build /home/gradle/services/app-bundle ./app-bundle/
COPY --from=build /home/gradle/services/db ./services/db
COPY --from=build /home/gradle/services/styles ./services/styles
COPY --from=build /home/gradle/assets ./assets

CMD ./app-bundle.bin/server
