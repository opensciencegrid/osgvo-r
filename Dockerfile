FROM opensciencegrid/osgvo-el7

RUN yum install -y libcurl-devel

RUN VERSION=3.5.0 && \
    cd /tmp && \
    wget -nv https://cloud.r-project.org/src/base/R-3/R-$VERSION.tar.gz && \
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
    Rscript -e "install.packages('statnet')"

# build info
RUN echo "Timestamp:" `date --utc` | tee /image-build-info.txt

