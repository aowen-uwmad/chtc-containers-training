# CHTC Container Training

The files in this repository are for the CHTC Container Training.

## Files

### `version.sh`

The `version.sh` script is a short shell script that reports the 
version of the operating system and then the version of any 
command that is passed to it as an argument. For example:

```
$ ./version.sh python3

Detected operating system:
    Ubuntu 22.04.1 LTS

$ python3 --version | head -n 1
Python 3.10.6

```

This script is used as the central core to the training regardless 
of the system being used.

### Files for the HTC system

If using the HTC system, in addition to the `version.sh` script,
you will be using the files ending in `.sub`. The `logs` directory 
is also provided for convience. 

### Files for the HPC system

If using the HPC system, in addition to the `version.sh` script,
you will be using the files ending in `.sbatch`.

## Instructions

All participants should follow these instructions, but use the
command(s) for their system when noted.
These instructions assume that you already have access to one of the
systems. 

### Quickstart demo

First, a quick demonstration of what a container does.
Watch and listen to the instructor as they perform the demonstration.

### Log in and setup

Log in to the system you wish to use for the container training.
For instructions on logging in to CHTC systems, see the 
[Log in to CHTC](https://chtc.cs.wisc.edu/uw-research-computing/connecting)
guide.

Once logged in, run the following command to clone this repository:

```
git clone https://github.com/aowen-uwmad/chtc-containers-training.git
```

Move into the directory that was downloaded.

### Submit regular job

You will use the `version.sh` script to explore the software environment
of a regular job on your preferred system.

To start, open the `regular` file for your preferred system
(`.sub` for HTC, `.sbatch` for HPC).

Examine the contents of the file to understand the job details.
The argument `python3` has been provided for you.
If you want to see the versions of other commands, add them after
`python3` using a space to separate each item of the list.

When ready, submit the job using the command for the system you are logged into.

**HTC**

```
condor_submit regular.sub
```

**HPC**

```
sbatch regular.sbatch
```

The submitted job should run and complete within a couple of minutes.
Once completed, examine the contents of `regular.out`.

* What was the operating system where the job ran?
* What was the version of `python3`?
* If you added other commands to check: did they exist and, if so, what were their versions?

> Note: Because of the simplicity of the `version.sh` script, the output
> for the HPC system will be duplicated by the number of tasks requested.

### Submit container job

You will follow a similar process now to submit a container job.
For this job, you'll be using the `container` file for your system 
(`.sub` for HTC, `.sbatch` for HPC).

Compare the contents of the `regular` and `container` job file.
What has changed?

If you added other commands as arguments besides `python3` to the `regular` file,
repeat the process to add them to the `container` file.

> *HTC ONLY*: Consider changing the container address from `python:3.13` to
  the address of some other container available on [DockerHub](hub.docker.com).

When ready, submit the `container` job. 

**HTC**

```
condor_submit container.sub
```

**HPC**

```
sbatch container.sbatch
```

Again, the job should run and complete within a couple of minutes.
Once completed, examine the contents of `container.out`.

* What was the operating system where the job ran?
* What was the version of `python3`?
* If you added other commands to check: did they exist and, if so, what were their versions?

And

* How does the output of the `container` job compare to the output of the `regular` job?

### Building your own Apptainer container


