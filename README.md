Some examples of building VPCs using Terraform, plus some other goodies on
top of the VPCs like RDS, consul, images via consul, etc. Adapted (somewhat - mostly ripped off) from [here](https://nickcharlton.net/posts/terraform-aws-vpc.html)

The initial cut at these is a mix of some injection of config and some
config that assumes a specific region (like the NAT ami, availability zone,
etc). Needs some work to inject all config.

Note some of the examples can't be run in a network environment that requires
a sox proxy for the SSH to go through.