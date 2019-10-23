
<!-- README.md is generated from README.Rmd. Please edit that file -->

# maketest

<!-- badges: start -->

<!-- badges: end -->

The goal of maketest is to specify a workflow that allows flexible
parallelised execution of R-scripts via make. Flexible means that the
environment in which the R-script is executed should be comfortable to
change (from **local** to **container** to **cluster**). All of these
levels should work seamless to enable rapid development and fast cycles
between development on the local machine and a cluster.

# Generell Approach

The general idea is to have one script that generates files with
settings in one folder and a script that processes these settings and
saves the result — corresponding to one settings file — into another
folder. Each settings file represents one task. One task means it is
solved within one process, but may, of course, be a multitude of
problems to solve. The problem motivating this approach (a simulation
study) had a lot of independent subproblems which are then arbitrarily
grouped into tasks — so one settings file may represent a set of
settings. Each of these tasks may then be further distributed with a
more sophisticated parallelisation technique.

# How to use it?

The [Makefile](Makefile) is the heart of the project, the rest is just a
silly example (multipling numbers by 2). It is farely well commented,
but it should be sufficient to just edit the variables at the beginning
and of course add you own scripts. Please note that the target `input`
must be build — in a seperate call to make — before targets based on it.
I have not (yet) figured out how to circumvent this inconvinience.

## local

  - on the local machine, with the local R-version

<!-- end list -->

    # note *two* seperate calls to make
    make input && make output
    # reset everything
    make reset

### local & parallel

  - on the local machine within multiple local R-sessions

<!-- end list -->

    make input && make -j 4
    # reset everything
    make reset

### docker

*under construction*

  - on the local machine within a docker container

<!-- end list -->

    # build image
    make build
    # execute
    make DOCKER=TRUE input && make DOCKER=TRUE output

### docker & paralell

*under construction*

  - on the local machine within multiple containers

<!-- end list -->

    # build image
    make build
    # execute
    make DOCKER=TRUE input && make -j 4 DOCKER=TRUE output 

### singularity

*under construction*

  - on the local machine within a singularity container

<!-- end list -->

    # build image
    make build
    # execute
    make SINGULARITY=TRUE input && make SINGULARITY=TRUE output 

### TORQUE/qsub

*under construction*

  - on a TORQUE computation cluster with the clusters R-version

<!-- end list -->

    # execute
    make input && make QSUB=TRUE output 

### TORQUE/qsub & singularity

*under construction*

  - on a TORQUE computation cluster within multiple singularity
    containers

<!-- end list -->

    # execute
    make SINGULARITY=TRUE input && make SINGULARITY=TRUE QSUB=TRUE output 

# Parallelisation

To utilise the power of the cluster, we need two levels of
parallelisation, one for the machine and one for the cores on each of
these machines. The task level is handled by make, meaning each task is
a single target. The parallelisation at the core level is left to the
R-script, and if only one machine is available, this level should be
preferred. The parallelisation on the task level is not generally
prefered and is often called “poor man’s parallelism” (PMP), because it
does not share the random access memory (RAM) of the machine between the
tasks. However, it is a relatively robust and straightforward approach.
It is utilised here since clusters usually do not share their RAM, so
the main downside is irrelevant and PMP works with every program which
can interact with a shell, which makes it widely applicable.
