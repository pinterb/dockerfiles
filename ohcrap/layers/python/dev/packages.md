

### install python dev packages
RUN apt-get install -y \
 pylint \
 python-coverage python3-coverage \
 pep8 python3-pep8

### cURL-like tool http://httpie.org/
RUN pip install --upgrade httpie
