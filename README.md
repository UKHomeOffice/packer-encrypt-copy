# Packer encrypt copy

## This will be useful if:
- You can't copy images that are public (aws limitation)
- You can't copy images between accounts that are encrypted (aws limitation)
- You don't mind your origin image being unencrypted
- You want your running images with your actual data to be encrypted
- You maybe have pay as you go licences RHEL or Windows that would be lost through other means (you can't specify the billing code yourself if you share/copy snapshots)

## What happens:
- packer brings up an ec2 instance with the AMI in the destination account
- packer makes an unencrypted AMI from that
- packer makes an encrypted copy from that AMI
- packer destroys the unencrypted AMI
- ~~new AMI in the destination account with a name like `something  copied from ami-xxxxx` so you can follow it back~~
- new AMI in the destination account will have the same name as the source account AMI name `ami-xxxxx` so you can see that it is (effectively) the same AMI

## Things to be aware of / downsides:
- There is a chance that when packer starts the image, something happens that won't happen on subsequent boots or changes things (cloud-init maybe?) and you'll end up imaging an 'unsealed' image.

## Usage:

### Docker
```bash
docker run \
  --rm \
  -e region=eu-west-2 \
  -e aws_id=... \
  -e aws_key=... \
  -e filters="--owner 000000 --filters "Name=name,Values=something*"" \
  UKHomeOffice/dq-packer-encrypt-copy
```

### Drone
```yaml
  packer-copy-notprod:
    image: UKHomeOffice/dq-packer-encrypt-copy
    commands:
      - export region=eu-west-2
      - export filters="--owner 000000 --filters "Name=name,Values=something*""
      - export aws_id=$${NOTPROD_ACC_ID}
      - export aws_key=$${NOTPROD_ACC_KEY}
      - ./build.sh
    secrets:
        - NOTPROD_ACC_ID
        - NOTPROD_ACC_KEY
    when:
      event: push
      branch: master
```

## Improvements
- [ ] allow `instance_type` to be configurable
- [ ] skip temp ssh key pair creation
- [ ] skip temp security group creation
- [ ] test with windows
