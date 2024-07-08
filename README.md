# LSVerifier-Action
This action uses [LSVerifier](https://pypi.org/project/LSVerifier/) to formally verify ANSI-C projects.

## Inputs

lsverifier_options (optional): give the options to be used with LSVerifier.

## Usage

```
- name: LSVerifier
  uses: Goblin57/LSVerifier-Action@v1
```

Because this action uses a Docker container, your workflow must be executed on a runner with a Linux operating system.

## Usage Example

```
name: test workflow

on: push

jobs:
  test-job:
    runs-on: ubuntu-latest
    steps:
      - name: checkout
        uses: actions/checkout@v4
      
      - name: run action
        uses: Goblin57/LSVerifier-Action@v1
        with:
          lsverifier_options: "-r -f"
```
