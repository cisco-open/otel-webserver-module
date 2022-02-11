FROM centos:6.9

ARG BUILD_NUMBER

LABEL NAME=apm/build-image-webserver-agent-centos6-x64 VERSION=$BUILD_NUMBER

ENV GOSU_ARCH amd64
ENV JDK_ARCH x64

# create default non-root user
RUN groupadd -r swuser && useradd -u 1000 -g swuser -m -s /sbin/nologin -c "default non-root user" swuser

RUN chmod -R 777 /opt

RUN curl https://www.getpagespeed.com/files/centos6-eol.repo --output /etc/yum.repos.d/CentOS-Base.repo

# install required packages
RUN yum update -y \
    && yum install -y \
    yum install wget -y \
    yum install -y zlib-devel \
    yum install -y openssl-devel \
    yum install java-1.8.0-openjdk -y \
    yum install pcre-devel -y \
    yum install xz -y \
    yum install httpd -y \
    && yum clean all

# install lcov package
RUN wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm \
	&& yum install ./epel-release-latest-*.noarch.rpm -y \
	&& yum install lcov -y \
	&& yum clean all

# install devtoolset toolchain
RUN curl https://www.getpagespeed.com/files/centos6-eol.repo --output /etc/yum.repos.d/CentOS-Base.repo \
  && curl https://www.getpagespeed.com/files/centos6-epel-eol.repo --output /etc/yum.repos.d/epel.repo \
  && yum -y install centos-release-scl \
  && curl https://www.getpagespeed.com/files/centos6-scl-eol.repo --output /etc/yum.repos.d/CentOS-SCLo-scl.repo \
  && curl https://www.getpagespeed.com/files/centos6-scl-rh-eol.repo --output /etc/yum.repos.d/CentOS-SCLo-scl-rh.repo \
  && yum install yum-utils -y \
  && yum-config-manager --enable rhel-server-rhscl-7-rpms -y \
  && yum install devtoolset-7 -y \
  && yum clean all
ENV PATH="/opt/rh/devtoolset-7/root/usr/bin:${PATH}"

# install python 2.7.8
RUN wget http://www.python.org/ftp/python/2.7.8/Python-2.7.8.tar.xz \
	&& unxz Python-2.7.8.tar.xz \
	&& tar -xf Python-2.7.8.tar \
	&& cd Python-2.7.8 && ./configure --prefix=/usr/local && make && make install \
	&& cd .. \
	&& rm -rf Python-2.7.8.tar.xz

# install gosu for easy step-down from root (from https://github.com/tianon/gosu/blob/master/INSTALL.md#from-centos)
ENV GOSU_VERSION=1.10
RUN gpg --keyserver pgp.mit.edu --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
    && curl -o /usr/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-amd64" \
    && curl -o /usr/bin/gosu.asc -SL "https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-amd64.asc" \
    && gpg --verify /usr/bin/gosu.asc \
    && rm /usr/bin/gosu.asc \
    && rm -r /root/.gnupg/ \
    && chmod +x /usr/bin/gosu \
    # Verify that the binary works
    && gosu nobody true

# install git required for grpc
RUN yum install git -y \
  && yum clean all

# install cmake 3.20
RUN wget https://cmake.org/files/v3.20/cmake-3.20.0-linux-x86_64.tar.gz \
  && tar -xvf cmake-3.20.0-linux-x86_64.tar.gz \
  && cd cmake-3.20.0-linux-x86_64 \
  && cp -rf * /usr/local/ \
  && cd ..

# install grpc. If planning to upgrade, make sure sed command works
RUN git clone https://github.com/grpc/grpc \
  && cd grpc \
  && git checkout tags/v1.36.4 -b v1.36.4 \
  && git submodule update --init \
  && sed -i "s/target_link_libraries(bssl ssl crypto)/target_link_libraries(bssl ssl crypto rt)/g" third_party/boringssl-with-bazel/CMakeLists.txt \
  && mkdir -p cmake/build \
  && cd cmake/build \
  && cmake ../.. -DgRPC_INSTALL=ON -DCMAKE_BUILD_TYPE=Release -DgRPC_ABSL_PROVIDER=module -DgRPC_CARES_PROVIDER=module -DgRPC_PROTOBUF_PROVIDER=module -DgRPC_RE2_PROVIDER=module -DgRPC_SSL_PROVIDER=module -DgRPC_ZLIB_PROVIDER=module \
  && make \
  && make install

COPY webserver-agent-centos6-x64-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["webserver-agent-centos6-x64-entrypoint.sh"]
