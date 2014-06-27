
# Select your closest mirror from...
# US West Coast (N. California):        us-west-1.ec2.archive
# US West Coast (Oregon):               us-west-2.ec2.archive
# US East Coast (N. Virginia):          us-east-1.ec2.archive
# South America (São Paulo, Brazil):    sa-east-1.ec2.archive
# Western Europe (Dublin, Ireland):     eu-west-1.ec2.archive
# NorthEast Asia (Tokyo):               ap-northeast-1.ec2.archive
# SouthEast Asia (Singapore):           ap-southeast-1.ec2.archive
# Australia (Sydney):                   ap-southeast-2.ec2.archive
# ... and assign UBUNTU_MIRROR below with your selection
ENV UBUNTU_MIRROR us-east-1.ec2.archive
ONBUILD RUN sed "s@archive@${UBUNTU_MIRROR}@" -i /etc/apt/sources.list
