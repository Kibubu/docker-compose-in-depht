docker network create project_default
docker run --rm \
    --name project-hello-1 \
    --network-alias="project-hello-1" \
    --network-alias="hello" \
    --network="project_default" \
    --label "com.docker.compose.config-hash"="0d3df12ac3c67c5e1b09211c5224d70e73795b9a6cf03b135cc902195436a7d7" \
    --label "com.docker.compose.container-number"="1" \
    --label "com.docker.compose.depends_on"="" \
    --label "com.docker.compose.oneoff"="False" \
    --label "com.docker.compose.project"="project" \
    --label "com.docker.compose.project.config_files"="/project/compose.yaml" \
    --label "com.docker.compose.project.working_dir"="/project" \
    --label "com.docker.compose.service"="hello" \
    --label "com.docker.compose.version"="2.9.0" \
    hello-world
