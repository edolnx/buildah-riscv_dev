ARG TARGETARCH
FROM riscv_dev-${TARGETARCH}:stage1
MAINTAINER "Carl Perry <caperry@edolnx.net>"

RUN mkdir -p /root/.local/bin
RUN mkdir -p /root/work

# Add, Run, the Remove the stage2 container build script
ADD stage2-container-build.sh /root/stage2-container-build.sh
RUN bash /root/stage2-container-build.sh
RUN rm /root/stage2-container-build.sh
