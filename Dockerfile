FROM ubuntu:18.04

LABEL previous_maintainer="Ron Kurr <kurr@kurron.org>"

RUN apt-get update && apt-get --assume-yes install curl unzip

# Create non-root user
RUN groupadd --system snowflake --gid 444 && \
  useradd --uid 444 --system --gid snowflake --home-dir /home/snowflake --create-home --shell /sbin/nologin --comment "Docker image user" snowflake && \
  chown -R snowflake:snowflake /home/snowflake

# Default to being in the user's home directory
WORKDIR /home/snowflake

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8
ENV VERSION 1.2.10
ENV SNOWSQL_DEST /usr/local/bin
ENV SNOWSQL_LOGIN_SHELL /home/snowflake/.bashrc

# Grab the installation script
RUN curl -o snowsql-${VERSION}-linux_x86_64.bash https://sfc-repo.snowflakecomputing.com/snowsql/bootstrap/1.2/linux_x86_64/snowsql-${VERSION}-linux_x86_64.bash

# Install the tool
RUN bash snowsql-${VERSION}-linux_x86_64.bash

# Switch to the non-root user
USER snowflake
RUN snowsql --versions

ENTRYPOINT ["snowsql"]

CMD ["-v"]
