resource "aws_kinesis_stream" "xen_test_stream" {
    name = "xen-test"
    shard_count = 1
    retention_period = 24
    tags {
        Environment = "dev"
    }
}