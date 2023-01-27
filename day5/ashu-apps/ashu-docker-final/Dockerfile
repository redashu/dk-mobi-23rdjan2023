FROM centos
LABEL name="ashutoshh"
COPY datagen.sh /root/
WORKDIR /root
RUN chmod +x datagen.sh
ENTRYPOINT [ "./datagen.sh" ]
# using ENTRYPOINT instead of CMD 