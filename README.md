# CHTC Container Training

The files in this repository are for the CHTC Container Training.
Corresponding slides:

* [Feb. 11, 2025](https://docs.google.com/presentation/d/10CD4K_xGjFKkOYV-AA0NPOpMPCNusg77-lk1UgUY57g/edit?usp=sharing)

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

Next, you'll build a simple container using Apptainer.

Building a container can be an intensive process, like any software installation,
so first you need to start an interactive session on the system.

**HTC**

```
condor_submit -i interactive.sub
```

**HPC**

```
srun --mpi=pmix -n4 -N1 -t 240 -p int --pty bash
```

Once the interactive session has started, create a file called
`container.def` with the following contents:

```
Bootstrap: docker
From: python:3.13

%post
    python3 -m pip install cowsay
```

This file is the "definition" file for how Apptainer should 
construct the container.

* The first two lines tell Apptainer to use the `python:3.13` 
  container that is already published on DockerHub.

* The lines under the `%post` section are the commands that 
  Apptainer should use to install additional software, in this case
  the `cowsay` package that can be used to print messages using ASCII art.
  (This section takes normal shell commands as instructions.)

Now, still in the interactive job, run the following command:

```
apptainer build container.sif container.def
```

* The first argument of this command is desired name of the container image file.
  For historic reasons, Apptainer uses the `.sif` extension to indicate an
  Apptainer image file.

* The second argument of this command is the name of the definition file that
  you wrote, in this case, `container.def`.

As the command runs, you'll see a variety of information printed to the screen.

> First will be information about Apptainer downloading the Docker container 
> from DockerHub.
> Next, there will be the usual `pip install` output for installing the `cowsay` package,
> which comes from Apptainer executing the commands in the `%post` section.
> Finally, assuming no errors, Apptainer will create a single standalone file
> (the `.sif` file).

If everything works correctly, once the command completes there should be a new
`container.sif` file in your current directory.

### Testing the container

While still in the interactive job (and assuming there is a `container.sif` file),
run the following command:

```
apptainer shell -e container.sif
```

You'll see your prompt change from `[yourNetID@hostname ~]$ ` to `Apptainer> `.
That means when you run a command, you will be using the operating system and
software that is inside of the container image.

You should be able to run the following command:

```
./version.sh python3
```

To test that the `cowsay` package is installed, run the following command:

```
python3 -c 'import cowsay; cowsay.cow("Hello, my name is Cow!")'
```

You should see the following message:

```
  ______________________
| Hello, my name is Cow! |
  ======================
                      \
                       \
                         ^__^
                         (oo)\_______
                         (__)\       )\/\
                             ||----w |
                             ||     ||
```

### Relocating the container image

If you still see `Apptainer> ` as your command prompt, enter `exit` to exit the
running container.

**HTC**

The `/staging` system is the home for `.sif` files on the HTC system.

Move the `container.sif` file into your staging directory:

```
mv container.sif /staging/YOUR_NETID/
```

If you do not have a staging directory, you can skip this step, and
the file will be returned to your directory on the access point.
BUT before using the container at scale, you need to first place the
container in a staging directory.

**HPC**

The `/home` filesystem is the home for `.sif` files on the HPC system.

Move the `container.sif` file into your home directory:

```
mv container.sif ~/
```

### Wrap up

**Remember to exit your interactive job!**

Now that you've built a container, you can use a similar procedure as
we did in the beginning to use it in your calculation.

We have quite a few guides about using containers on our website, and
they should get you most of the way to creating a container with your
software and using it in your large scale jobs.

**Apptainer guides**

* Use, build containers on **HTC**: [https://chtc.cs.wisc.edu/uw-research-computing/apptainer-htc](https://chtc.cs.wisc.edu/uw-research-computing/apptainer-htc)
* Use, build containers on **HPC**: [https://chtc.cs.wisc.edu/uw-research-computing/apptainer-hpc](https://chtc.cs.wisc.edu/uw-research-computing/apptainer-hpc)
* Convert Docker container to Apptainer: [https://chtc.cs.wisc.edu/uw-research-computing/htc-docker-to-apptainer](https://chtc.cs.wisc.edu/uw-research-computing/htc-docker-to-apptainer)
* Detailed guide to Apptainer definition files: [https://chtc.cs.wisc.edu/uw-research-computing/apptainer-build](https://chtc.cs.wisc.edu/uw-research-computing/apptainer-build)
* Example of an advanced Apptainer definition file: [https://chtc.cs.wisc.edu/uw-research-computing/apptainer-htc-advanced-example](https://chtc.cs.wisc.edu/uw-research-computing/apptainer-htc-advanced-example)

**Docker guides**

* Use Docker container on HTC: [https://chtc.cs.wisc.edu/uw-research-computing/docker-jobs](https://chtc.cs.wisc.edu/uw-research-computing/docker-jobs)
* Build a Docker container locally: [https://chtc.cs.wisc.edu/uw-research-computing/docker-build](https://chtc.cs.wisc.edu/uw-research-computing/docker-build)
* Test a Docker container locally: [https://chtc.cs.wisc.edu/uw-research-computing/docker-test](https://chtc.cs.wisc.edu/uw-research-computing/docker-test)

**Recipes**

* CHTC Recipes GitHub: [https://github.com/CHTC/recipes](https://github.com/CHTC/recipes)

See also our "Quickstart" software guides: [https://chtc.cs.wisc.edu/uw-research-computing/software-overview-htc#quickstart](https://chtc.cs.wisc.edu/uw-research-computing/software-overview-htc#quickstart)

