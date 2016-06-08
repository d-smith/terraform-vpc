Some examples of building VPCs using Terraform. Adapted (somewhat - mostly ripped off) from [here](https://nickcharlton.net/posts/terraform-aws-vpc.html)

The initial cut at these is a mix of some injection of config and some
config that assumes a specific region (like the NAT ami, availability zone,
etc). Needs some work to inject all config.
