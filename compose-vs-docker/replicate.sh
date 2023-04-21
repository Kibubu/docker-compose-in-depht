#! /bin/sh
DIND_ID="$(docker run --rm -d --privileged docker:dind dockerd)"
# https://stackoverflow.com/a/33520390
# Wait for docker:dind to run
until [ "$(docker inspect -f '{{.State.Running}}' "$DIND_ID")" = "true" ]; do
    sleep 0.1;
done;
docker exec "$DIND_ID" docker run --name hello hello-world
docker exec "$DIND_ID" sh -c 'until [ "$(docker inspect -f '\''{{.State.Status}}'\'' hello)" = "exited" ]; do sleep 0.1; done; docker inspect hello' > inspect_run.json
docker stop "$DIND_ID"

DIND_ID=""
DIND_ID="$(docker run --rm -d --privileged docker:dind dockerd)"
until [ "$(docker inspect -f '{{.State.Running}}' "$DIND_ID")" = "true" ]; do
    sleep 0.1;
done;
docker exec "$DIND_ID" mkdir /project
docker cp compose.yaml "${DIND_ID}:/project/compose.yaml"
docker exec "$DIND_ID" sh -c 'until [ -f /project/compose.yaml ]; do sleep 0.1; done; docker compose -f /project/compose.yaml up'
docker exec "$DIND_ID" sh -c 'until [ "$(docker inspect -f '\''{{.State.Status}}'\'' project-hello-1)" = "exited" ]; do sleep 0.1; done; docker inspect project-hello-1' > inspect_compose.json
docker stop "$DIND_ID"

DIND_ID=""
DIND_ID="$(docker run --rm -d --privileged docker:dind dockerd)"
until [ "$(docker inspect -f '{{.State.Running}}' "$DIND_ID")" = "true" ]; do
    sleep 0.1;
done;
docker exec "$DIND_ID" sh -c 'docker network create project_default; docker run --name project-hello-1 --network-alias="project-hello-1" --network-alias="hello" --network="project_default" --label "com.docker.compose.config-hash"="0d3df12ac3c67c5e1b09211c5224d70e73795b9a6cf03b135cc902195436a7d7" --label "com.docker.compose.container-number"="1" --label "com.docker.compose.depends_on"="" --label "com.docker.compose.oneoff"="False" --label "com.docker.compose.project"="project" --label "com.docker.compose.project.config_files"="/project/compose.yaml" --label "com.docker.compose.project.working_dir"="/project" --label "com.docker.compose.service"="hello" --label "com.docker.compose.version"="2.9.0" hello-world'
docker exec "$DIND_ID" sh -c 'until [ "$(docker inspect -f '\''{{.State.Status}}'\'' project-hello-1)" = "exited" ]; do sleep 0.1; done; docker inspect project-hello-1' > inspect_run_extended.json
docker stop "$DIND_ID"


# diff --side-by-side inspect_hello.json inspect_compose.json
# diff --side-by-side inspect_run_extended.json inspect_compose.json