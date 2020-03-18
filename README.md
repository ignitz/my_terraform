# My personal infra

## Dependencies

- jq
- ssh-keygen
- make

## Usage

Deploy

```
make
```

Destroy

```
make clean
```


## Delete UserData in AWS CLI

The User-data is stored in AWS and have to clear to avoid password leak

```
aws ec2 modify-instance-attribute --instance-id <your-instance-id> --user-data ":"
```