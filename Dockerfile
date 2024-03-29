FROM opensciencegrid/osgvo-el7

LABEL opensciencegrid.name="R"
LABEL opensciencegrid.description="Example for building R images"
LABEL opensciencegrid.url="https://www.r-project.org/"
LABEL opensciencegrid.category="Languages"
LABEL opensciencegrid.definition_url="https://github.com/opensciencegrid/osgvo-r"

RUN yum install -y libcurl-devel && \
    yum remove -y R R-core R-java-devel

RUN VERSION=4.0.2 && \
    cd /tmp && \
    wget -nv https://cloud.r-project.org/src/base/R-4/R-$VERSION.tar.gz && \
    tar xzf R-$VERSION.tar.gz && \
    cd R-$VERSION && \
    ./configure --prefix=/opt/R && \
    make && \
    make install && \
    cd /tmp && \
    rm -rf R-*

RUN PATH=/opt/R/bin:$PATH && \
    echo "r <- getOption('repos'); r['CRAN'] <- 'http://cran.us.r-project.org'; options(repos = r);" > ~/.Rprofile && \
    Rscript -e "install.packages('gdata')" && \
    Rscript -e "install.packages('tidyverse')" && \
    Rscript -e "install.packages('OpenMx')" && \
    Rscript -e "install.packages('sna')" && \
    Rscript -e "install.packages('statnet')" && \
    Rscript -e "install.packages('littler')"

COPY labels.json /.singularity.d/
COPY 95-R-env.sh /.singularity.d/env/95-R-env.sh

# build info
RUN echo "Timestamp:" `date --utc` | tee /image-build-info.txt

